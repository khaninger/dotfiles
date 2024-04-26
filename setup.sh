if [ ! -f "${HOME}/.dotfiles/setup.sh" ]; then
  echo "ERROR: Make sure .dotfiles is in home directory"
  exit 1
fi

# Setup emacs files
echo "Soft linking emacs .dotfiles"\\
mkdir ${HOME}/.emacs.d
mkdir ${HOME}/.emacs.d/auto-save
for file in emacs/*; do
  echo "Soft linking ${file}"
  ln -s ${HOME}/.dotfiles/"$file" ${HOME}/.emacs.d/"$(basename "$file")"
done

# Setup home-manager
echo "Setting up home-manager"
# Setup home-manager file
echo "Soft linking home.nix"

curl -L https://nixos.org/nix/install | sh
# Verify nix, e.g. 'nix-shell', might need to run the activation script/restart or chown sth

sudo chown ${USER} /nix
bash /home/hanikevi/.nix-profile/etc/profile.d/nix.sh

# Add nix home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
# Now you should be able to activate 'home-manager'

rm ${HOME}/.config/home-manager/home.nix
ln -s ${HOME}/.dotfiles/home-manager/home.nix ${HOME}/.config/home-manager/


echo ". $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" >> $HOME/.profile


# Setup fonts
echo "Installing fonts!"
sudo mkdir /usr/share/fonts/berkeley-mono
sudo cp fonts/berkeley-mono/TTF/*.ttf /usr/share/fonts/berkeley-mono/
sudo fc-cache -f

# Minor configs
echo "Killing the cursed bash bell!"
sudo echo "set bell-style none" >> /etc/inputrc

echo ${HOME}/.nix-profile/bin/zsh | sudo tee -a /etc/shells
sudo usermod -s ${HOME}/.nix-profile/bin/zsh $USER


# Setup github ssh key
echo "Generating a pub ssh key:"
ssh-keygen -t rsa -b 4096 -C khaninger@gmail.com
cat ~/.ssh/id_rsa.pub
