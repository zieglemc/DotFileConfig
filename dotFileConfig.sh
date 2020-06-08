#!/usr/bin/env bash

backup_existing_conf(){
    echo "Create Backup of existing configuration"
    if ! [ -d $HOME/.config_backup ]; then
        mkdir -p $HOME/.config_backup/config
    fi
    [ -f ${HOME}/.zshrc ] && mv --backup=numbered ${HOME}/.zshrc ${HOME}/.config_backup
    [ -f ${HOME}/.bashrc ] && mv --backup=numbered ${HOME}/.bashrc ${HOME}/.config_backup
    [ -f ${HOME}/.Xdefaults ] && mv --backup=numbered ${HOME}/.Xdefaults ${HOME}/.config_backup
    [ -f ${HOME}/.bash_profile ] && mv --backup=numbered ${HOME}/.bash_profile ${HOME}/.config_backup
    [ -f ${HOME}/.bash_exports ] && mv --backup=numbered ${HOME}/.bash_exports ${HOME}/.config_backup
    [ -f ${HOME}/.bash_aliases ] && mv --backup=numbered ${HOME}/.bash_aliases ${HOME}/.config_backup
    [ -f ${HOME}/.bash_funcs ] && mv --backup=numbered ${HOME}/.bash_funcs ${HOME}/.config_backup
    [ -f ${HOME}/.profile ] && mv --backup=numbered ${HOME}/.profile ${HOME}/.config_backup
    [ -d ${HOME}/.config/awesome ] && mv --backup=numbered ${HOME}/.config/awesome ${HOME}/.config_backup/config/
    [ -d ${HOME}/.config/zsh ] && mv --backup=numbered ${HOME}/.config/zsh ${HOME}/.config_backup/config/
    [ -d ${HOME}/.config/bash ] && mv --backup=numbered ${HOME}/.config/bash ${HOME}/.config_backup/config/
    [ -d ${HOME}/.config/xfce4 ] && mv --backup=numbered ${HOME}/.config/xfce4 ${HOME}/.config_backup/config/
    [ -d ${HOME}/.urxvt ] && mv --backup=numbered ${HOME}/.urxvt ${HOME}/.config_backup/
    [ -d ${HOME}/.oh-my-zsh ] && mv --backup=numbered ${HOME}/.oh-my-zsh ${HOME}/.config_backup/
    [ -d ${HOME}/.config/terminator ] && mv --backup=numbered ${HOME}/.config/terminator ${HOME}/.config_backup/
    [ -d ${HOME}/.config/systemd ] && mv --backup=numbered ${HOME}/.config/systemd ${HOME}/.config_backup/
}


### Check if my configuration is already existing on the machine ###
exists=0
[ -d ${HOME}/.dotfileconf/ ] && exists=1 || mkdir ${HOME}/.dotfileconf

### create a backup of the existing configuration and clone my dotfiles from github ###
if [ $exists -eq "0" ]; then
    echo "Creating backup and getting my configuration"
    backup_existing_conf
    git clone --recurse-submodules --bare https://www.github.com/zieglemc/Dotfiles.git $HOME/.dotfileconf
    git --git-dir=$HOME/.dotfileconf/ --work-tree=$HOME config --local status.showUntrackedFiles no
else
    echo "Updating my current dotfile configution"
    git --git-dir=$HOME/.dotfileconf/ --work-tree=$HOME pull
fi
git --git-dir=$HOME/.dotfileconf/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfileconf/ --work-tree=$HOME submodule update

### installing fzf ###
[ -d ${HOME}/.fzf ] || ( git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install )

### getting my emacs config ###
echo "Getting the emacs configuration from github if necessary"
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
echo "Checking for current shell and changing to zsh if necessary"
curr_shell=$(grep $USER /etc/passwd | rev | cut -d: -f1 | rev)
[ "$curr_shell" = "/bin/zsh" ] || ( [ -f /bin/zsh ] && chsh -s /bin/zsh )
