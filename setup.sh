#!/bin/bash
if [ ! -f "${HOME}/.dotfiles/setup.sh" ]; then
  echo "ERROR: Make sure .dotfiles is in home directory"
  exit 1
fi

read -p "Setup emacs files? Not needed if doing home-manager [y/n] " response
if [[ "$response" == "y" ]]; then
    echo "Soft linking emacs .dotfiles"\\
    mkdir ${HOME}/.emacs.d
    mkdir ${HOME}/.emacs.d/auto-save
    for file in emacs/*; do
        echo "Soft linking ${file}"
        ln -s ${HOME}/.dotfiles/"$file" ${HOME}/.emacs.d/"$(basename "$file")"
    done
fi


read -r -p "Setup home-manager files? [y/n] " response
if [ $response == "y" ]
then
    curl -L https://nixos.org/nix/install | sh
    
    sudo chown ${USER} /nix
    . /home/hanikevi/.nix-profile/etc/profile.d/nix.sh

    # Add nix home-manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update

    nix-shell '<home-manager>' -A install

    echo "Soft linking home.nix"
    rm ${HOME}/.config/home-manager/home.nix
    ln -s ${HOME}/.dotfiles/home-manager/home.nix ${HOME}/.config/home-manager/

    echo ". $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" >> $HOME/.profile
fi

read -r -p "Install Windows configs to C://Users/$USER [y/n] " response
if [ $response == "y" ]
then
    cp -r windows/. "/mnt/c/Users/$USER/"
fi

read -r -p "Make emacs shortcut in /usr/share/applications? [y/n] " response
if [ $response == "y" ]
then
    sudo cp emacs.desktop /usr/share/applications/
fi

read -r -p "Install font? [y/n] " response
if [ $response == "y" ]
then
    sudo mkdir /usr/share/fonts/berkeley-mono
    sudo cp fonts/berkeley-mono/TTF/*.ttf /usr/share/fonts/berkeley-mono/
    sudo fc-cache -f
fi


read -r -p "Set zsh as default shell? [y/n] " response
if [ $response == "y" ]
then
    echo ${HOME}/.nix-profile/bin/zsh | sudo tee -a /etc/shells
    sudo usermod -s ${HOME}/.nix-profile/bin/zsh $USER
fi


read -r -p "Setup pub key for github? [y/n] " response
if [ $response == "y" ]
then
    echo "Generating a pub ssh key:"
    ssh-keygen -t rsa -b 4096 -C khaninger@gmail.com
    cat ~/.ssh/id_rsa.pub
fi

read -r -p "Setup venv for python? [y/n] " response
if [ $response == "y" ]
then
    sudo apt install python-is-python3
    sudo apt install python3-venv
fi
