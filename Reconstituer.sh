#!/usr/bin/env bash
set -euo pipefail
fail() { printf 'Erreur : %s\n' "$*" >&2; exit 1; }
[[ $# -le 2 ]] || fail 'Usage : bash reconstituer-plugin.sh [archive-plugin.txt] [dossier-de-sortie]'
input=${1:-archive-plugin.txt}
destination=${2:-SEE-Brins-0.16.2-PC-officiel}
[[ -f $input ]] || fail "Fichier Base64 introuvable : $input"
[[ ! -e $destination && ! -L $destination && ! -e $destination.zip && ! -L $destination.zip ]] || fail 'La destination existe deja. Choisis un autre nom pour ne rien ecraser.'
for tool in base64 xz sha256sum unzip mktemp tr cat mkdir rm dirname; do
  command -v "$tool" >/dev/null 2>&1 || fail "Outil manquant : $tool. Utilise un environnement Bash autorise disposant de cet outil."
done
[[ -d $(dirname -- "$destination") ]] || fail 'Le dossier parent de sortie doit exister.'
temporary=$(mktemp -d "$(dirname -- "$destination")/.see-brins-decode-XXXXXX")
trap 'rm -rf -- "$temporary"' EXIT
# Whitespace from a text editor is accepted; other invalid input is rejected.
if ! tr -d ' \t\r\n' < "$input" | base64 -d > "$temporary/package.zip.xz"; then
  fail 'Base64 invalide ou incomplet. Copie uniquement le contenu brut du fichier GitHub.'
fi
actual=$(sha256sum "$temporary/package.zip.xz"); actual=${actual%% *}
[[ $actual == dfe502c7a8c76a66dc8d51ceafd89b354b41e49fd51e37a0f4f5ea16838abe91 ]] || fail 'Base64 tronque ou modifie : empreinte SHA-256 incorrecte. Aucune extraction.'
xz -dc -- "$temporary/package.zip.xz" > "$temporary/package.zip" || fail 'Decompression XZ impossible.'
actual=$(sha256sum "$temporary/package.zip"); actual=${actual%% *}
[[ $actual == c07e154bd85a20b15411a96c8aa9b4898825057471b2ddae5e8e75d9d8f5b1a7 ]] || fail 'Archive ZIP incorrecte. Aucune extraction.'
unzip -tq "$temporary/package.zip" >/dev/null || fail 'Archive ZIP endommagee.'
# Keep the verified archive first. No directory rename: this operation can
# fail with Permission denied under Git Bash on Windows after extraction.
if ! (set -o noclobber; cat -- "$temporary/package.zip" > "$destination.zip"); then
  fail 'Impossible de creer le ZIP de sortie sans ecraser un fichier existant.'
fi
mkdir -- "$destination" || fail 'Creation du dossier impossible. Le ZIP verifie reste disponible.'
if ! unzip -q "$destination.zip" -d "$destination"; then
  fail 'Extraction incomplete. Le ZIP verifie reste disponible pour une extraction manuelle.'
fi
# No plugin execution, registration, network access, or policy changes here.
printf 'Integrite verifiee. Dossier reconstitue : %s\nArchive conservee : %s.zip\n' "$destination" "$destination"
printf 'Ferme SEE. Depuis le dossier reconstitue : bash Gerer-plugin.sh activer\nPremier essai sur une copie de dossier.\n'
