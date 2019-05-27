#!/usr/bin/env bash

backup_existing_conf(){
    if ! [ -d .config_backup ]; then
        mkdir -p .config_backup/config
    fi
    [ -f ${HOME}/.zshrc ] || mv --backup=numbered ${HOME}/.zshrc ${HOME}/.config_backup
    [ -f ${HOME}/.bashrc ] || mv --backup=numbered ${HOME}/.bashrc ${HOME}/.config_backup
    [ -f ${HOME}/.Xdefaults ] || mv --backup=numbered ${HOME}/.Xdefaults ${HOME}/.config_backup
    [ -f ${HOME}/.bash_profile ] || mv --backup=numbered ${HOME}/.bash_profile ${HOME}/.config_backup
    [ -f ${HOME}/.bash_exports ] || mv --backup=numbered ${HOME}/.bash_exports ${HOME}/.config_backup
    [ -f ${HOME}/.bash_aliases ] || mv --backup=numbered ${HOME}/.bash_aliases ${HOME}/.config_backup
    [ -f ${HOME}/.bash_funcs ] || mv --backup=numbered ${HOME}/.bash_funcs ${HOME}/.config_backup
    [ -f ${HOME}/.profile ] || mv --backup=numbered ${HOME}/.profile ${HOME}/.config_backup
    [ -d ${HOME}/.config/awesome ] || mv --backup=numbered ${HOME}/.config/awesome ${HOME}/.config_backup/config/
    [ -d ${HOME}/.config/zsh ] || mv --backup=numbered ${HOME}/.config/awesome ${HOME}/.config_backup/config/
    [ -d ${HOME}/.config/bash ] || mv --backup=numbered ${HOME}/.config/awesome ${HOME}/.config_backup/config/
    [ -d ${HOME}/.urxvt ] || mv --backup=numbered ${HOME}/.urxvt ${HOME}/.config_backup/
    [ -d ${HOME}/.oh-my-zsh ] || mv --backup=numbered ${HOME}/.oh-my-zsh ${HOME}/.config_backup/
}


### Check if my configuration is already existing on the machine ###
exists=0
[ -d ${HOME}/.dotfileconf/ ] && exists=1 || mkdir ${HOME}/.dotfileconf


### create a backup of the existing configuration and clone my dotfiles from github ###
[ $exists -eq "0" ] \
    && backup_existing_conf \
    && git clone --bare https://www.github.com/zieglemc/Dotfiles.git $HOME/.dotfileconf \
    && git --git-dir=$HOME/.dotfileconf/ --work-tree=$HOME config --local status.showUntrackedFiles no

### installing fzf ###
[ -d ${HOME}/.fzf ] || ( git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install )

### getting my emacs config ###
if [ -d $HOME/.emacs.d ];then
    cd $HOME/.emacs.d
    if !  git status >/dev/null 2>&1 ; then
        cd - || exit 1
        rm -rf $HOME/.emacs.d
        git clone https://github.com/zieglemc/EmacsInit $HOME/.emacs.d
    fi
else
    git clone https://github.com/zieglemc/EmacsInit $HOME/.emacs.d
fi

### enable and start the daemons using systemctl ###


### setting zsh as the default shell ###
curr_shell=$(grep $USER /etc/passwd | rev | cut -d: -f1 | rev)
[ "$curr_shell" = "/bin/zsh" ] || ( [ -f /bin/zsh ] && chsh -s /bin/zsh )
