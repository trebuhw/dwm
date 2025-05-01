#!/bin/bash

# Skrypt do integracji bootloaderów różnych systemów z systemd-boot
# Ten skrypt wykrywa bootloadery Windows, macOS, oraz innych dystrybucji Linuxa
# Ten skrypt wymaga uprawnień root!

set -e
set -u

# Sprawdzenie czy skrypt jest uruchomiony z uprawnieniami root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ten skrypt musi być uruchomiony z uprawnieniami root"
    echo "Spróbuj: sudo $0"
    exit 1
fi

# Funkcja do wyświetlania informacji
info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

# Funkcja do wyświetlania ostrzeżeń
warning() {
    echo -e "\e[1;33m[OSTRZEŻENIE]\e[0m $1"
}

# Funkcja do wyświetlania błędów
error() {
    echo -e "\e[1;31m[BŁĄD]\e[0m $1"
    exit 1
}

# Funkcja do znajdowania partycji EFI
find_efi_partition() {
    info "Szukanie partycji EFI..."
    
    # Sprawdzenie, czy system jest uruchomiony z UEFI
    if [ ! -d "/sys/firmware/efi" ]; then
        error "System nie został uruchomiony w trybie UEFI. Ten skrypt działa tylko z systemami UEFI."
    fi
    
    # Znajdź wszystkie partycje EFI
    EFI_PARTITIONS=$(lsblk -o NAME,PARTTYPE,PARTLABEL -n -p | grep -i c12a7328-f81f-11d2-ba4b-00a0c93ec93b || true)
    
    if [ -z "$EFI_PARTITIONS" ]; then
        # Alternatywna metoda - wyszukiwanie po etykiecie systemu plików
        EFI_PARTITIONS=$(lsblk -o NAME,FSTYPE,MOUNTPOINT -n -p | grep -i "vfat" | grep -i "/boot/efi" || true)
    fi
    
    if [ -z "$EFI_PARTITIONS" ]; then
        error "Nie znaleziono partycji EFI. Upewnij się, że system korzysta z partycji EFI."
    fi
    
    # Wybierz pierwszą partycję EFI (można rozszerzyć o interaktywny wybór)
    EFI_PARTITION=$(echo "$EFI_PARTITIONS" | head -n1 | awk '{print $1}')
    info "Znaleziono partycję EFI: $EFI_PARTITION"
    
    return 0
}

# Funkcja do sprawdzenia, czy partycja EFI jest zamontowana i jej montowanie, jeśli nie jest
mount_efi_partition() {
    info "Sprawdzanie montowania partycji EFI..."
    
    # Sprawdź, czy partycja EFI jest już zamontowana
    EFI_MOUNTPOINT=$(lsblk -o NAME,MOUNTPOINT -n -p | grep "^$EFI_PARTITION" | awk '{print $2}')
    
    if [ -z "$EFI_MOUNTPOINT" ]; then
        # Jeśli nie jest zamontowana, zamontuj ją
        info "Partycja EFI nie jest zamontowana. Montowanie..."
        EFI_MOUNTPOINT="/mnt/efi"
        mkdir -p "$EFI_MOUNTPOINT"
        mount "$EFI_PARTITION" "$EFI_MOUNTPOINT"
        TEMP_MOUNTED=true
        info "Zamontowano partycję EFI w $EFI_MOUNTPOINT"
    else
        info "Partycja EFI jest już zamontowana w $EFI_MOUNTPOINT"
        TEMP_MOUNTED=false
    fi
    
    return 0
}

# Funkcja do wykrywania bootloaderów różnych systemów operacyjnych
find_bootloaders() {
    info "Szukanie bootloaderów różnych systemów operacyjnych..."
    
    # Zainicjuj tablicę na znalezione bootloadery
    declare -A BOOTLOADERS
    
    # Typowe lokalizacje bootloadera Windows
    WINDOWS_BOOT_PATHS=(
        "/EFI/Microsoft/Boot/bootmgfw.efi"
        "/EFI/Boot/bootx64.efi"
        "/bootmgr.efi"
    )
    
    # Typowe lokalizacje bootloadera macOS
    MACOS_BOOT_PATHS=(
        "/EFI/Apple/Boot/bootmgfw.efi"
        "/System/Library/CoreServices/boot.efi"
    )
    
    # Typowe lokalizacje bootloaderów różnych dystrybucji Linuxa
    LINUX_BOOT_PATHS=(
        # Ubuntu / Debian
        "/EFI/ubuntu/grubx64.efi"
        "/EFI/debian/grubx64.efi"
        # Fedora
        "/EFI/fedora/grubx64.efi"
        "/EFI/fedora/shimx64.efi"
        # Arch Linux
        "/EFI/arch/grubx64.efi"
        # openSUSE
        "/EFI/opensuse/grubx64.efi"
        # Generic GRUB
        "/EFI/GRUB/grubx64.efi"
        # rEFInd
        "/EFI/refind/refind_x64.efi"
        # systemd-boot (dla innych instalacji)
        "/EFI/systemd/systemd-bootx64.efi"
        # Gentoo
        "/EFI/gentoo/grubx64.efi"
        # Elementary OS
        "/EFI/elementary/grubx64.efi"
        # Manjaro
        "/EFI/Manjaro/grubx64.efi"
        # Pop!_OS
        "/EFI/Pop_OS/grubx64.efi"
        "/EFI/Pop_OS/kernelx64.efi"
        # Linux Mint
        "/EFI/linuxmint/grubx64.efi"
        # Zorin OS
        "/EFI/zorin/grubx64.efi"
        # Kali Linux
        "/EFI/kali/grubx64.efi"
        # MX Linux
        "/EFI/MX/grubx64.efi"
        # EndeavourOS
        "/EFI/endeavouros/grubx64.efi"
        # Garuda Linux
        "/EFI/garuda/grubx64.efi"
    )
    
    # Szukaj bootloadera Windows
    info "Szukanie bootloadera Windows..."
    for boot_path in "${WINDOWS_BOOT_PATHS[@]}"; do
        full_path="$EFI_MOUNTPOINT$boot_path"
        if [ -f "$full_path" ]; then
            BOOTLOADERS["windows"]="$boot_path"
            info "Znaleziono bootloader Windows: $boot_path"
            break
        fi
    done
    
    # Szukaj bootloadera macOS
    info "Szukanie bootloadera macOS..."
    for boot_path in "${MACOS_BOOT_PATHS[@]}"; do
        full_path="$EFI_MOUNTPOINT$boot_path"
        if [ -f "$full_path" ]; then
            BOOTLOADERS["macos"]="$boot_path"
            info "Znaleziono bootloader macOS: $boot_path"
            break
        fi
    done
    
    # Szukaj bootloaderów różnych dystrybucji Linuxa
    info "Szukanie bootloaderów innych systemów Linux..."
    for boot_path in "${LINUX_BOOT_PATHS[@]}"; do
        full_path="$EFI_MOUNTPOINT$boot_path"
        if [ -f "$full_path" ]; then
            # Określ nazwę systemu na podstawie ścieżki
            system_name=$(echo "$boot_path" | cut -d'/' -f3 | tr '[:upper:]' '[:lower:]')
            BOOTLOADERS["$system_name"]="$boot_path"
            info "Znaleziono bootloader dla systemu $system_name: $boot_path"
        fi
    done
    
    # Szukaj innych bootloaderów EFI, które nie zostały jeszcze zidentyfikowane
    info "Szukanie innych bootloaderów EFI..."
    
    # Znajdź wszystkie pliki .efi w katalogu EFI
    readarray -t OTHER_EFI_FILES < <(find "$EFI_MOUNTPOINT/EFI" -name "*.efi" 2>/dev/null)
    
    for efi_file in "${OTHER_EFI_FILES[@]}"; do
        # Pomiń już znalezione bootloadery
        skip=0
        for known_path in "${BOOTLOADERS[@]}"; do
            if [ "$EFI_MOUNTPOINT$known_path" = "$efi_file" ]; then
                skip=1
                break
            fi
        done
        
        if [ $skip -eq 0 ]; then
            # Usuń przedrostek ścieżki montowania
            rel_path=${efi_file#"$EFI_MOUNTPOINT"}
            
            # Określ nazwę systemu na podstawie ścieżki
            system_name=$(echo "$rel_path" | cut -d'/' -f3 | tr '[:upper:]' '[:lower:]')
            
            # Jeśli dla tego systemu jeszcze nie ma wpisu, dodaj go
            if [ -z "${BOOTLOADERS[$system_name]+x}" ]; then
                BOOTLOADERS["$system_name"]="$rel_path"
                info "Znaleziono dodatkowy bootloader dla systemu $system_name: $rel_path"
            fi
        fi
    done
    
    # Sprawdź czy znaleziono jakiekolwiek bootloadery
    if [ ${#BOOTLOADERS[@]} -eq 0 ]; then
        warning "Nie znaleziono żadnych bootloaderów na partycji EFI"
    else
        info "Znaleziono w sumie ${#BOOTLOADERS[@]} bootloaderów"
    fi
    
    return 0
}

# Funkcja do sprawdzenia i aktualizacji systemd-boot
update_systemd_boot() {
    info "Sprawdzanie systemd-boot..."
    
    # Sprawdź, czy systemd-boot jest zainstalowany
    if ! command -v bootctl &> /dev/null; then
        error "systemd-boot nie jest zainstalowany. Zainstaluj pakiet systemd-boot."
    fi
    
    # Sprawdź, czy katalog entries istnieje
    SYSTEMD_BOOT_ENTRIES="$EFI_MOUNTPOINT/loader/entries"
    if [ ! -d "$SYSTEMD_BOOT_ENTRIES" ]; then
        info "Tworzenie katalogu entries dla systemd-boot..."
        mkdir -p "$SYSTEMD_BOOT_ENTRIES"
    fi
    
    # Katalog loader dla pliku konfiguracyjnego
    LOADER_CONFIG_DIR="$EFI_MOUNTPOINT/loader"
    if [ ! -d "$LOADER_CONFIG_DIR" ]; then
        info "Tworzenie katalogu loader dla systemd-boot..."
        mkdir -p "$LOADER_CONFIG_DIR"
    fi
    
    # Upewnij się, że plik konfiguracyjny loader.conf istnieje i ma podstawowe ustawienia
    LOADER_CONFIG="$LOADER_CONFIG_DIR/loader.conf"
    if [ ! -f "$LOADER_CONFIG" ]; then
        info "Tworzenie pliku konfiguracyjnego loader.conf..."
        cat > "$LOADER_CONFIG" << EOF
timeout 5
default @saved
console-mode auto
editor no
EOF
        info "Utworzono plik konfiguracyjny loader.conf"
    fi
    
    # Utwórz wpisy dla znalezionych bootloaderów
    info "Tworzenie wpisów dla znalezionych bootloaderów..."
    
    # Licznik znalezionych systemów
    FOUND_SYSTEMS=0
    
    # Utwórz wpis dla Windows
    if [ -n "${BOOTLOADERS["windows"]+x}" ]; then
        WINDOWS_ENTRY="$SYSTEMD_BOOT_ENTRIES/windows.conf"
        info "Tworzenie wpisu dla Windows w systemd-boot..."
        
        cat > "$WINDOWS_ENTRY" << EOF
[Boot Loader Entry]
title Windows
efi ${BOOTLOADERS["windows"]}
EOF
        info "Utworzono wpis dla Windows w systemd-boot: $WINDOWS_ENTRY"
        ((FOUND_SYSTEMS++))
    fi
    
    # Utwórz wpis dla macOS
    if [ -n "${BOOTLOADERS["macos"]+x}" ]; then
        MACOS_ENTRY="$SYSTEMD_BOOT_ENTRIES/macos.conf"
        info "Tworzenie wpisu dla macOS w systemd-boot..."
        
        cat > "$MACOS_ENTRY" << EOF
[Boot Loader Entry]
title macOS
efi ${BOOTLOADERS["macos"]}
EOF
        info "Utworzono wpis dla macOS w systemd-boot: $MACOS_ENTRY"
        ((FOUND_SYSTEMS++))
    fi
    
    # Utwórz wpisy dla innych systemów Linux
    for system_name in "${!BOOTLOADERS[@]}"; do
        # Pomiń już obsłużone systemy
        if [ "$system_name" != "windows" ] && [ "$system_name" != "macos" ]; then
            ENTRY_FILE="$SYSTEMD_BOOT_ENTRIES/${system_name}.conf"
            
            # Ładniejszy tytuł z pierwszą literą wielką
            NICE_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${system_name:0:1})${system_name:1}"
            
            info "Tworzenie wpisu dla $NICE_NAME w systemd-boot..."
            
            cat > "$ENTRY_FILE" << EOF
[Boot Loader Entry]
title $NICE_NAME
efi ${BOOTLOADERS["$system_name"]}
EOF
            info "Utworzono wpis dla $NICE_NAME w systemd-boot: $ENTRY_FILE"
            ((FOUND_SYSTEMS++))
        fi
    done
    
    # Sprawdź, czy utworzono jakiekolwiek wpisy
    if [ $FOUND_SYSTEMS -eq 0 ]; then
        warning "Nie utworzono żadnych wpisów dla systemd-boot, ponieważ nie znaleziono żadnych bootloaderów"
    else
        info "Utworzono wpisy dla $FOUND_SYSTEMS systemów operacyjnych"
    fi
    
    # Aktualizacja systemd-boot
    info "Aktualizacja systemd-boot..."
    bootctl update
    
    return 0
}

# Funkcja do skanowania dysków w poszukiwaniu innych systemów operacyjnych
scan_os_probes() {
    info "Skanowanie dysków w poszukiwaniu innych systemów operacyjnych..."
    
    # Sprawdź, czy os-prober jest zainstalowany
    if command -v os-prober &> /dev/null; then
        info "Wykrywanie systemów operacyjnych za pomocą os-prober..."
        
        # Uruchom os-prober, aby znaleźć inne systemy operacyjne
        OS_PROBES=$(os-prober 2>/dev/null || true)
        
        if [ -n "$OS_PROBES" ]; then
            info "Znalezione systemy operacyjne przez os-prober:"
            echo "$OS_PROBES" | while IFS=: read -r device name type description; do
                info "  $description ($type) na $device"
                
                # Dla systemów, które nie były wcześniej wykryte przez EFI
                if [ "$type" = "windows" ] && [ -z "${BOOTLOADERS["windows"]+x}" ]; then
                    info "Znaleziono Windows przez os-prober, ale nie przez EFI"
                    # Można tutaj dodać dodatkową obsługę
                elif echo "$type" | grep -qi "linux"; then
                    linux_distro=$(echo "$description" | awk '{print tolower($1)}')
                    if [ -z "${BOOTLOADERS["$linux_distro"]+x}" ]; then
                        info "Znaleziono $description przez os-prober, ale nie przez EFI"
                        # Można tutaj dodać dodatkową obsługę
                    fi
                fi
            done
        else
            info "os-prober nie znalazł dodatkowych systemów operacyjnych"
        fi
    else
        info "os-prober nie jest zainstalowany. Pomijanie dodatkowego skanowania dysków."
        info "Aby zainstalować os-prober, użyj menedżera pakietów swojej dystrybucji."
    fi
}

# Główna funkcja
main() {
    info "Rozpoczynanie integracji bootloaderów różnych systemów z systemd-boot..."
    
    # Zainicjuj globalną tablicę asocjacyjną na znalezione bootloadery
    declare -A BOOTLOADERS
    
    find_efi_partition
    mount_efi_partition
    find_bootloaders
    scan_os_probes
    update_systemd_boot
    
    # Odmontuj partycję EFI, jeśli została tymczasowo zamontowana
    if [ "$TEMP_MOUNTED" = true ]; then
        info "Odmontowywanie tymczasowo zamontowanej partycji EFI..."
        umount "$EFI_MOUNTPOINT"
        rmdir "$EFI_MOUNTPOINT"
    fi
    
    info "Integracja zakończona pomyślnie!"
    
    # Wyświetl podsumowanie znalezionych systemów
    if [ ${#BOOTLOADERS[@]} -gt 0 ]; then
        info "Wykryte systemy operacyjne, które powinny teraz być widoczne w menu systemd-boot:"
        for system_name in "${!BOOTLOADERS[@]}"; do
            NICE_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${system_name:0:1})${system_name:1}"
            info "  - $NICE_NAME (${BOOTLOADERS["$system_name"]})"
        done
    else
        warning "Nie wykryto żadnych dodatkowych systemów operacyjnych. Sprawdź ręcznie konfigurację komputera."
    fi
    
    return 0
}

# Eksportuj zmienną BOOTLOADERS jako globalną
export -A BOOTLOADERS

# Wywołanie głównej funkcji
main
