# Multi-OS Bootloader dla systemd-boot

Skrypt automatycznie wykrywający i konfigurujący systemd-boot do uruchamiania wielu systemów operacyjnych.

## Opis

Ten skrypt automatycznie wykrywa bootloadery różnych systemów operacyjnych zainstalowanych na komputerze i konfiguruje systemd-boot, aby można było łatwo wybierać między nimi podczas uruchamiania komputera. Działa podobnie do GRUB2, ale wykorzystuje prostszy i szybszy systemd-boot.

## Wykrywane systemy operacyjne

Skrypt wykrywa następujące systemy operacyjne:

- Microsoft Windows (różne wersje)
- Apple macOS
- Różne dystrybucje Linuxa:
  - Ubuntu
  - Debian
  - Fedora
  - Arch Linux
  - openSUSE
  - Linux Mint
  - Pop!_OS
  - Elementary OS
  - Manjaro
  - Gentoo
  - Kali Linux
  - MX Linux
  - Zorin OS
  - EndeavourOS
  - Garuda Linux
  - I wiele innych

## Wymagania

- System UEFI (nie działa z BIOS Legacy)
- Systemd-boot zainstalowany w systemie
- Uprawnienia administratora (root)
- Opcjonalnie: os-prober (do wykrywania systemów, które nie są bezpośrednio widoczne przez EFI)

## Instalacja

```bash
# Pobierz skrypt
wget https://example.com/multi-os-bootloader.sh -O multi-os-bootloader.sh

# Nadaj uprawnienia do wykonania
chmod +x multi-os-bootloader.sh

# Uruchom jako root
sudo ./multi-os-bootloader.sh
```

## Instrukcja użycia

### Krok 1: Przygotowanie

Dla optymalnych wyników warto zainstalować pakiet `os-prober`, który pomoże wykryć wszystkie zainstalowane systemy:

- Dla Debian/Ubuntu:
  ```bash
  sudo apt install os-prober
  ```

- Dla Fedora:
  ```bash
  sudo dnf install os-prober
  ```

- Dla Arch:
  ```bash
  sudo pacman -S os-prober
  ```

### Krok 2: Uruchomienie skryptu

```bash
sudo ./multi-os-bootloader.sh
```

### Krok 3: Restart systemu

Po zakończeniu działania skryptu, zrestartuj komputer, aby sprawdzić menu systemd-boot:

```bash
sudo reboot
```

## Co robi skrypt?

1. Automatycznie wykrywa partycję EFI
2. Skanuje partycję EFI w poszukiwaniu bootloaderów różnych systemów operacyjnych
3. Używa os-prober (jeśli zainstalowany) do wykrywania dodatkowych systemów operacyjnych
4. Tworzy lub aktualizuje konfigurację systemd-boot
5. Dodaje wpisy dla wszystkich wykrytych systemów operacyjnych
6. Aktualizuje systemd-boot

## Rozwiązywanie problemów

Jeśli jakiś system nie jest wykrywany:

1. Upewnij się, że jest zainstalowany os-prober: `sudo apt/dnf/pacman install os-prober`
2. Sprawdź, czy partycja systemowa jest dostępna i nie zaszyfrowana
3. Sprawdź, czy system został zainstalowany w trybie UEFI, a nie Legacy BIOS

## Licencja

Ten skrypt jest udostępniany na licencji MIT.

## Autor

Skrypt został wygenerowany przez Claude (Anthropic) w kwietniu 2025.
