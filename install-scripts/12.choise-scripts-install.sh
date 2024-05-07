#!/bin/bash

folder="/home/hubert/Dokumenty/GitHub/dwm-install/install-scripts" # Zmień na właściwą ścieżkę do folderu

echo "Dostępne skrypty do instalacji:"

# Pobierz listę skryptów w folderze
scripts=("$folder"/*.sh)

# Sprawdź, czy istnieją jakiekolwiek skrypty
if [ ${#scripts[@]} -eq 0 ]; then
  echo "Brak dostępnych skryptów do instalacji."
  exit 1
fi

# Wyświetl dostępne skrypty
for ((i=0; i<${#scripts[@]}; i++)); do
  echo "$((i+1)). $(basename ${scripts[$i]})"
done

echo -n "Podaj numery skryptów do zainstalowania (oddzielone spacjami): "
read scripts_to_install

# Podziel wprowadzone numery skryptów na tablicę
IFS=" " read -ra selected_scripts <<< "$scripts_to_install"

for script_number in "${selected_scripts[@]}"; do
  # Sprawdź, czy numer skryptu jest prawidłowy
  if [[ $script_number =~ ^[0-9]+$ && $script_number -ge 1 && $script_number -le ${#scripts[@]} ]]; then
    script="${scripts[$((script_number-1))]}"
    echo "Instalowanie $script..."
    chmod +x "$script"
    "$script"
  else
    echo "Nieprawidłowy numer skryptu: $script_number"
  fi
done
