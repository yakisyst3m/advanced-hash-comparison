#!/bin/bash

# Définir le chemin du répertoire à vérifier
DIRECTORY="./MON_DOSSIER"

time(
    # Recalculer les empreintes de fichiers en parallèle
    echo "Recalcul des empreintes de fichiers..."
    find "$DIRECTORY" -type f -print0 | sort -z | xargs -0 -n1 -P$(nproc) sha256sum > file_hashes_verify_unsorted.txt

    # Trier les empreintes de fichiers
    sort file_hashes_verify_unsorted.txt > file_hashes_verify.txt
    rm file_hashes_verify_unsorted.txt

    # Vérifier l'empreinte de la liste de fichiers
    echo "Vérification de l'empreinte de la liste des fichiers..."
    sha256sum file_hashes_verify.txt > directory_hash_verify.txt

    # Comparer les empreintes
    if cmp file_hashes.txt file_hashes_verify.txt ; then
        echo "Les fichiers file_hashes.txt et file_hashes_verify.txt contenant les hashs des fichiers n'ont pas été modifiés."
        printf "Empreinte numérique de la liste de hashs d'origine : %s\n" "$(cat directory_hash_verify.txt)"
        printf "Empreinte numérique de la liste de hashs de la copie : %s\n" "$(cat directory_hash.txt)"

    else
        echo "Les fichiers ont été modifiés ou sont corrompus."
    fi
)
