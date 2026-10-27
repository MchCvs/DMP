# Origine des paquets installés (d'après les listes APT locales). Ne pas traduire ici.
orig_block() {
  local f b c r M R k n nm lab out=""
  M=$(for f in /var/lib/apt/lists/*_Packages*; do
    [ -f "$f" ] || continue
    b=${f##*/}
    case $b in
      *debian.org_debian_dists_*|*_debian_dists_*|*_debian-security_dists_*)
        case $b in
          *non-free-firmware*) c=nff; r=2;;
          *non-free*) c=nf; r=4;;
          *contrib*) c=ct; r=3;;
          *) c=main; r=1;;
        esac;;
      *) c=tiers; r=5;;
    esac
    case $f in
      *.xz) xzcat "$f";; *.gz) zcat "$f";; *.lz4) lz4cat "$f";; *) cat "$f";;
    esac 2>/dev/null | awk -v c="$c" -v r="$r" '/^Package: /{print $2"\t"c"\t"r}'
  done | sort -t$'\t' -k1,1 -k3,3n | awk -F'\t' '!s[$1]++')
  if [ -z "$M" ]; then printf '%s' "$T_OR_TITLE${NL}   $T_OR_EMPTY"; return; fi
  R=$(echo "$TBL" | awk -F'\t' '{print $3}' | awk -F'\t' '
    NR==FNR{m[$1]=$2;next}
    {c=($1 in m)?m[$1]:"none"; n[c]++; if(c!="main" && n[c]<=12) L[c]=L[c] (L[c]!=""?", ":"") $1}
    END{split("main nff ct nf tiers none",o," ");
      for(i=1;i<=6;i++){k=o[i]; if(n[k]>12) L[k]=L[k] ", …"; printf "%s\t%d\t%s\n",k,n[k],L[k]}}
  ' <(echo "$M") -)
  while IFS=$'\t' read -r k n nm; do
    [ "${n:-0}" -gt 0 ] || continue
    lab="T_OR_$k"
    out="$out${NL}   • ${!lab}$T_OR_SEP $n"
    [ -n "$nm" ] && out="$out${NL}      $nm"
  done <<< "$R"
  printf '%s' "$T_OR_TITLE${NL}   $T_OR_WHY$out"
}
