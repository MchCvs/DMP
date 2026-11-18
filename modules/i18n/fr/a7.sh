# Textes français du collecteur a7. Ne modifier que le texte.
T_COMP="Debian est le système d'exploitation : le grand chef d'orchestre qui fait fonctionner ensemble tout le matériel et tous vos programmes."
T_CMD="/etc/os-release, uname"
T_O() {
case $VC in
13) XU="Debian 13 est la version stable actuelle : elle reçoit les mises à jour de sécurité, vous êtes à jour.";;
12) XU="Debian 12 est la version précédente : elle reste suivie (support prolongé), mais prévoyez de passer à Debian 13.";;
none) XU="Votre version n'est pas numérotée (test ou instable) : plus récente, mais moins stable.";;
derive) XU="Votre système est dérivé de Debian (Linux Mint, Ubuntu…) : il reçoit ses mises à jour de sécurité de son éditeur.";;
*) XU="Cette version de Debian est ancienne et n'est plus suivie pour la sécurité : une mise à niveau est recommandée, car les failles découvertes ne sont plus corrigées.";;
esac
X="$XU Pour un usage courant, Debian est parfaitement suffisante : navigateur, bureautique et multimédia fonctionnent sans souci."
O="$(tr_cle a7.observations p="$PRETTY_NAME" k="$(uname -r)" m="$(uname -m)")"
R="Debian 13, version actuelle"; [ "$VC" = derive ] && R="Système dérivé de Debian, mis à jour par son éditeur"; [ "$VC" = 12 ] && R="Debian 12, bientôt en fin de vie : prévoyez la mise à niveau"; [ "$VC" = old ] && R="Version de Debian ancienne, sans mises à jour de sécurité"; [ "$VC" = none ] && R="Version de Debian non identifiée"
}
