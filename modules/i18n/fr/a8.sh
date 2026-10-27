# Textes français du collecteur a8. Ne modifier que le texte.
T_COMP="Les périphériques sont tout ce que vous branchez à l'ordinateur : clavier, souris, clé USB, webcam, imprimante. Chacun passe par un port USB, la prise standard."
T_COMP_NO="Les périphériques sont tout ce que vous branchez à l'ordinateur : clavier, souris, clé USB, webcam, imprimante."
T_NO_O="Aucun appareil USB n'est détecté pour l'instant. Pourquoi : rien n'est branché, ou vos clavier et souris passent par un autre type de connexion. Ce n'est pas un problème."
T_NO_R="Aucun appareil USB"
T_CMD="/sys/bus/usb/devices"
T_V() {
case $sp in 1.5) V="USB 1.0, très lent";; 12) V="USB 1.1, lent";; 480) V="USB 2.0, vitesse correcte";; 5000) V="USB 3.0, rapide";; 10000|20000) V="USB 3.x, très rapide";; *) V="USB";; esac
}
T_T() {
case $c in
03) T="clavier, souris ou manette"; E="C'est ce qui vous permet de commander l'ordinateur. Sans lui, vous ne pourriez ni taper ni cliquer.";;
08) T="clé USB ou disque externe"; E="C'est un support de stockage amovible, utile pour transporter ou sauvegarder des fichiers. Un port rapide accélère les copies.";;
0e) T="webcam"; E="C'est la caméra qui filme pour les appels vidéo.";;
01) T="appareil audio (micro, casque, enceinte)"; E="Il sert à entendre ou à enregistrer du son.";;
07) T="imprimante"; E="Elle imprime vos documents.";;
e0) T="Bluetooth (sans fil)"; E="Il permet de connecter casque, souris ou manette sans câble.";;
09) T="répartiteur (hub USB)"; E="C'est une multiprise USB : elle multiplie les ports, mais ils se partagent la même vitesse.";;
02|0a) T="modem ou carte réseau USB"; E="Il sert à se connecter à un réseau.";;
ff) T="appareil spécifique (fabricant)"; E="Son rôle précis dépend du fabricant, mais le système l'a reconnu.";;
*) T="appareil USB"; E="Il est reconnu par le système.";;
esac
}
T_DEV() { O="$O${NL}${NL}🔌 Appareil $N : « $nom »${NL}   • Type : $T${NL}   • Rôle : $E${NL}   • Connexion : $V"; }
T_O() {
X="Cette liste suffit à vérifier que tout ce que vous avez branché est reconnu, donc prêt à servir. Si un appareil manque, essayez un autre câble ou un autre port, car le système ne peut utiliser que ce qu'il reconnaît. Astuce : pour un disque ou une clé, privilégiez un port marqué USB 3.0 (souvent bleu), car la copie y est bien plus rapide."
O="Votre ordinateur reconnaît $N appareil(s) USB :$O"
R="$N appareil(s) reconnu(s)"
}
