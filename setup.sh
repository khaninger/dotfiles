if [ ! -f "${HOME}/.dotfiles/setup.sh" ]; then
  echo "ERROR: Make sure .dotfiles is in home directory"
  exit 1
fi

# Setup emacs files
echo "Soft linking emacs .dotfiles"\\
mkdir ${HOME}/.emacs.d
for file in emacs/*; do
  echo "Soft linking ${file}"
  ln -s ${HOME}/.dotfiles/"$file" ${HOME}/.emacs.d/"$(basename "$file")"
done

# Setup home-manager
echo "Setting up home-manager"
curl -L https://nixos.org/nix/install | sh
# Verify nix, e.g. 'nix-shell', might need to run the activation script/restart or chown sth

# Add nix home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
# Now you should be able to activate 'home-manager' 

# Setup home-manager file
echo "Soft linking home.nix"
rm ${HOME}/.config/home-manager/home.nix
ln -s ${HOME}/.dotfiles/home-manager/home.nix ${HOME}/.config/home-manager/

# Setup fonts
echo "Installing fonts!"
sudo mkdir /usr/share/fonts/berkeley-mono
sudo cp fonts/berkeley-mono/TTF/*.ttf /usr/share/fonts/berkeley-mono/
sudo fc-cache -f

# Setup github ssh key
echo "Generating a pub ssh key:"
ssh-keygen -t rsa -b 4096 -C khaninger@gmail.com
cat ~/.ssh/id_rsa.pub
