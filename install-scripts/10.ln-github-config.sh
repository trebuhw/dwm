#!/bin/bash

# Ścieżka do folderu, z którego chcesz utworzyć linki symboliczne
zrodlo="$HOME/Dokumenty/GitHub/dwm-install/files/.config"

# Ścieżka do folderu, w którym chcesz utworzyć linki symboliczne
cel="$HOME/.config"

# Opcja usuwania folderów źródłowych
usun_zrodlo=true

# Usuwanie folderów źródłowych, jeśli opcja jest ustawiona
if [ "$usun_zrodlo" = true ]; then
    for folder in "$cel"/*; do
        if [ -e "$folder" ]; then
            rm -rf "$folder"
            echo "Usunięto: $folder"
        fi
    done
fi

# Przechodzenie do folderu źródłowego
cd "$zrodlo" || exit

# Wylistowanie plików i utworzenie linków symbolicznych w folderze docelowym
for plik in *; do
    if [ -e "$cel/$plik" ]; then
        rm -f "$cel/$plik"
        echo "Usunięto: $cel/$plik"
    fi

    ln -s "$zrodlo/$plik" "$cel/$plik"
    echo "Utworzono link symboliczny dla: $cel/$plik"
done

echo "Proces zakończony."
