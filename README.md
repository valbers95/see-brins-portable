# SEE Brins 0.16.2 — transfert et installation utilisateur

Ce dépôt privé contient le paquet du plugin sous forme de texte Base64. Il ne contient pas de DLL du logiciel SEE, de SDK constructeur, de clé ou de dossier projet.

1. Ouvrir `payload.base64.txt` sur GitHub, choisir **Raw**, puis copier uniquement son contenu dans un fichier texte `payload.base64.txt` sur le PC cible.
2. Placer `Reconstituer.sh` à côté (également fourni dans le ZIP de livraison).
3. Dans Bash (Git Bash ou WSL) :

```bash
bash Reconstituer.sh payload.base64.txt
```

Le script recrée le dossier `SEE-Brins-0.16.2-PC-officiel` et son ZIP. Il vérifie les empreintes du flux compressé et de l'archive avant d'extraire. Il refuse d'écraser une destination existante. Aucun plugin n'est lancé ni enregistré automatiquement.

Une autre destination peut être donnée en second argument. Sous WSL, utiliser un dossier Windows local (par exemple sous `/mnt/c/Users/...`), pas le système de fichiers Linux, pour l'installation du plugin.

Outils requis : Bash, base64, xz, sha256sum, unzip et commandes habituelles (tr, mktemp, mv, rm, dirname). Test de reconstruction effectué sous WSL. Git Bash prévu, non testé ici.

Fermer SEE, puis depuis le dossier reconstruit :

```bash
bash Gerer-plugin.sh activer
# Pour retirer l'enregistrement :
bash Gerer-plugin.sh desactiver
```

Le gestionnaire `Gerer-plugin.exe` est aussi conservé pour une installation graphique. Aucune élévation administrateur demandée. L'inscription se fait dans le registre de l'utilisateur Windows ; le script d'installation appelle le reg.exe standard de Windows. Fermer et relancer toutes les instances SEE pour décharger un plugin déjà chargé.

Les contrôles de compatibilité sont conservés. Les fichiers officiels de la construction V5R2 étudiée sont acceptés, mais pas toutes les versions V5R2. Premier essai sur une copie indépendante d'un projet : pas de validation réelle sur le PC professionnel ni de garantie d'absence de défaut.

Base64 est un format de transport, sans chiffrement. Il ne modifie pas les politiques de sécurité de l'entreprise et ne dispense pas d'autorisation pour installer un plugin.
