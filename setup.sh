# Setup emacs files
echo "Moving emacs .dotfiles"\\
mkdir ${HOME}/.emacs.d
mv ./emacs/* ${HOME}/.emacs.d/


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
mv ./home-manager/home.nix ${HOME}/.config/home-manager/


# Setup fonts
echo "Installing fonts!"
sudo mkdir /usr/share/fonts/berkeley-mono
mv ./fonts/berkeley-mono/*.ttf /usr/share/fonts/berkeley-mono/
sudo fc-cache -f
