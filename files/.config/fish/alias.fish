#list
alias ls='lsd --color=auto'
alias la='lsd -a'
alias ll='lsd -al'
alias l='lsd'
alias lt='lsd --tree'
alias l.="lsd -A | egrep '^\.'"
alias df='df -h'
alias free="free -mt"
alias update-fc='sudo fc-cache -fv'
alias hw="hwinfo --short"
alias wget="wget -c"
alias userlist="cut -d: -f1 /etc/passwd | sort"
alias ws="watch sensors"
alias ns="nvidia-smi"
alias bt='blueman-adapters'
alias nma='nm-applet'
alias br='sudo systemctl restart bluetooth'
alias btinfo="bluetoothctl info"
alias think="bluetoothctl info | awk '/Name:/ || /Battery Percentage:/' | bat "
alias logout='pkill -KILL -u hubert'
alias bs='brightnessctl set'
alias bi='brightnessctl i'
alias am='alsamixer'

#fix obvious typo's
alias cd..='cd ..'
alias wal='cd $HOME/Obrazy/Wallpaper'
alias cp='cp -riv'
alias mv='mv -iv'
alias rm="trash-put -v" # trash-cli przenosi pliki do kosza
alias tl="trash-list" # lista plików w koszu
alias te='trash-empty' #opróżnianie kosza
alias tr='trash-restore' #przywracanie plików z kosza
alias trm='trash-rm' #usówa pojedyńcze pliki z kosza
#alias rm='rm -rdv' # usówa pliki całkowicie 
alias mkdir='mkdir -vp'
alias pdw='pwd'
alias zyp='sudo zypper'
alias up='sudo zypper refresh && sudo zypper update --no-recommends && sudo zypper dist-upgrade --no-recommends'
alias dup='sudo zypper refresh && sudo zypper dist-upgrade --no-recommendsa'
alias zin='sudo zypper install --no-recommends'
alias zrm='sudo zypper remove -u'
alias zse='sudo zypper search'
alias zsi='zypper search -i' # show installed Packages
alias zre='sudo zypper repos'
alias zrf='sudo zypper refresh'
alias zdr='sudo zypper mr -d' #disablerepo, dr - Wyłączenie wybranego repozytorium podać nazwę
alias zer='sudo zypper mr -e' #removerepo, er - Włączenie wybranego repozytorium podać nazwę
alias zrr='sudo zypper rr' #removerepo, rr - Usuwanie wybranego repozytorium
alias zcd='sudo zypper packages --unneeded' # Usówanie osieroconych pakietów
alias zcl='sudo zypper clean --all' # Clean repo, key repo, cache

#alias tldr='tldr -t ocean'
# alias tldr='tldr --color always' # Install OpenSuse tealdeer run tldr -h

alias find='find -name'
alias locate='locate -b'

alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /usr/bin/fish && echo 'Now log out.'"

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#iso and version used to install ArcoLinux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"
alias isoo="cat /etc/dev-rel"

#search content with ripgrep
alias rg="rg --sort path"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#know what you do in these files
alias ngrub="sudo $EDITOR /etc/default/grub"
alias nconfgrub="sudo $EDITOR /boot/grub/grub.cfg"
alias upgrub="grub2-mkconfig -o /boot/grub2/grub.cfg"
alias nmkinitcpio="sudo $EDITOR /etc/mkinitcpio.conf"
alias nfstab="sudo $EDITOR /etc/fstab"
alias nhosts="sudo $EDITOR /etc/hosts"
alias nhostname="sudo $EDITOR /etc/hostname"

#reading logs with bat
alias lxorg="bat /var/log/Xorg.0.log"
alias lxorgo="bat /var/log/Xorg.0.log.old"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"

# Moje aliasy
alias v='nvim'
alias nv='nvim'
alias vim='vim'
alias ffa='$HOME/.config/scripts/fzf-run-app.sh'
alias ffc='$HOME/.config/scripts/fzf-config.sh'
alias ffl='$HOME/.config/scripts/fzf-import-rofi.sh'
alias ffd='$HOME/.config/scripts/fzf-run-dir-scripts.sh'
alias ffr='$HOME/.config/scripts/fzf_speed/run/fzf-run.sh'
alias ffe='$HOME/.config/scripts/fzf_speed/edit/fzf-edit.sh'
alias ffes='$HOME/.config/scripts/fzf-scripts.sh'
alias ffcp='cliphist list | fzf | cliphist decode | wl-copy'
alias i30='nvim $HOME/Dokumenty/"i30_info.txt"'
alias nf='neofetch'
alias wi='xprop' # info run program
alias wg='xwininfo' # geometry winows
alias bg='sxiv -t $HOME/Obrazy/Wallpaper/'
alias sbg='cd $HOME/Obrazy/Wallpaper && sxiv'
alias e="exit"
alias po="systemctl poweroff"
alias rb="systemctl reboot"
alias rh="hyprctl dispatch exit"
alias r='ranger'
# alias r='~/.config/dwm/scripts/ranger.sh'
#alias y='$HOME/Pobrane/git/yazi/yazi/target/release/yazi'
alias y='yazi'
alias rs='ranger --confdir=$HOME/.config/ranger.st/'
alias b="btop"
alias c="cal -y"
alias pcinfo="inxi -Fxz"
alias nm="nmtui"
alias nma='nm-applet'
#alias nt='SpeedTest++'
alias nt='speedtest-cli'
alias hnt='cd $HOME/.config/scripts&&./fast'
alias wcolor="$HOME/.config/scripts/grim-gcolor.sh"
alias cis="$HOME/.config/scripts/grim-copyimg.sh"
alias cl="clear"
alias ag="alias | grep"
alias hg='history | grep '
alias pogoda='curl wttr.in/Swidnica'
alias pacup='sudo pacman -Syyu'
alias yayup='yay -Syyu'
alias pp='pacman -Qqet' # pacman - zainstalowane pakiety
alias pq='pacman -Q' # pacman - zainstalowane programy
alias oi="grep -i installed /var/log/pacman.log"
alias uo='pacman -Rsn $(pacman -Qdtq)' # usówanie osieroconych pakietów
alias app='hyprctl clients' # class i id window
alias rk='du -sh *'
alias mpdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=' # Merge pdf. Podać nazwa po połączeniu potem nazwy złączanych plików.
alias sddmb='sudo cp $HOME/.background.jpg /usr/share/sddm/themes/arcolinux-simplicity/images/background.jpg'
alias picker='hyprpicker -an'
alias cc='rm /home/hubert/.cache/cliphist/db' # Clear list cliphist - historia kopiowania, numeracja elementów skopiowanych będzię kontynuowana 
#alias cc='cliphist wipe && rm /home/hubert/.cache/cliphist/db' # Clear list cliphist - historia kopiowania, numeracja elementów skopiowanych będzię kontynuowana 
alias chwipe='cliphist wipe' # Clear list cliphist - historia kopiowania, numeracja elementów skopiowanych będzię kontynuowana 
alias chdel='rm /home/hubert/.cache/cliphist/db' # Cliphist usunięcie  bazy - numeracja skopiowanych będzię kontynuowana od nowa
alias umount='sudo umount -dflnrv' # Podaj ścieżkę zamontowanego katalogu
alias mocp='mocp -C $HOME/.config/moc/config.example'
alias ff='fastfetch'
alias td='sudo hdparm -t' # test prędkości dysku użycie sudo hdparm -t /dev/sda
alias hc='nvim ~/.config/hypr/hyprland.conf'
alias af='nvim ~/.config/fish/alias.fish'
alias exp='~/.config/hypr/scripts/export-archiv'
alias cdh='cd ~/ && ls'
alias cdcl='cd ~/Cloud/ && ls'
alias cdd='cd ~/Dokumenty/ && ls'
alias cdo='cd ~/Obrazy/ && ls'
alias cdp='cd ~/Pobrane/ && ls'
alias cdc='cd ~/.config && ls'
alias cddw='cd ~/.config/suckless/dwm/ && ll'
alias cds='cd ~/.config/suckless/ && ll'
alias cdbg='cd ~/.config/dwm/bg/ && ls'
alias cdf='cd ~/.config/fish/ && ls'
alias cdss='cd ~/.config/suckless/scripts/ && ll'
alias cdhs='cd ~/.config/hypr/scripts/ && ll'
alias brc='nvim ~/bashrc'
alias ptt='pdftotext -layout'
alias backup='~/.config/suckless/scripts/rsync-backup.sh'
alias rsdwm='rsync -av ~/.config/dwm/ ~/Dokumenty/GitHub/dwm-install/files/.config/dwm/'
alias mpdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=' # Merge pdf. Podać nazwa po połączeniu potem nazwy złączanych plików.

# Aliases GITBARE
alias gb='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' # git --bare
alias gbs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status'
alias gba='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add'
alias gbr='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME rm -r --cached'
alias gbc='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -am'
alias gbpush='$HOME/Dokumenty/Git/gitbare-push.sh'
alias gbpull='$HOME/Dokumenty/Git/gitbare-pull.sh'
alias mgc='$HOME/Dokumenty/Git/my-git-clone.sh'
alias mga='git add'
alias mgs='git status'
alias mgcom='git commit -am'
alias mgpush='$HOME/Dokumenty/Git/my-git-push.sh'
alias mgpull='$HOME/Dokumenty/Git/my-git-pull.sh'
#alias gbp='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME push'
#alias gbpull='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull'
alias gbf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch origin' # reset scalanie - merge 
# Aliases rsync
alias sync='rsync -rlpva --delete'
alias synchypr='rsync -rlpva ~/.config/hypr/ ~/Dokumenty/GitHub/hypr/' #rsync hypr config to GIT repos
alias gitsync='rsync -av --exclude="*git*" ~/Dokumenty/GitHub/dwm-install/ ~/Dokumenty/GitHub/dwm/'
