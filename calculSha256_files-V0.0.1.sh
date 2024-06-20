#!/bin/bash

# Définir le chemin du répertoire
DIRECTORY="./MON_DOSSIER"

time(
    # Calcul des empreintes de fichiers en parallèle
    echo "Calcul des empreintes de fichiers..."
    find "$DIRECTORY" -type f -print0 | sort -z | xargs -0 -n1 -P$(nproc) sha256sum > file_hashes_unsorted.txt

    # Trier les empreintes de fichiers
    sort file_hashes_unsorted.txt > file_hashes.txt
    rm file_hashes_unsorted.txt

    # Calcul de l'empreinte du fichier de listes
    echo "Calcul de l'empreinte de la liste des fichiers..."
    sha256sum file_hashes.txt > directory_hash.txt

    # Afficher les résultats
    echo "Empreintes calculées et sauvegardées dans file_hashes.txt et directory_hash.txt"
)

