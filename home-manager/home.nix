{ config, pkgs, ... }:

let
  my-emacs = pkgs.emacs29.override {
    withNativeCompilation = true;
    withSQLite3 = true;
    withTreeSitter = true;
    withWebP = true;
  };
  my-emacs-with-packages = (pkgs.emacsPackagesFor my-emacs).emacsWithPackages (epkgs: with epkgs; [
    vterm
    pdf-tools
    treesit-grammars.with-all-grammars
  ]);
in
{
  targets.genericLinux.enable = true; # when not using NixOS

  home.username = "hanikevi";
  home.homeDirectory = "/home/hanikevi";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs;  [
    # Dev
    ruff
    ruff-lsp
    python3Packages.python-lsp-server
    
    cargo
    
    tree-sitter
    emacs-all-the-icons-fonts
    

    

    # Misc
    ghostscript
  ];

  # Manage home files
  home.file = {
    ".emacs.d" = {
        source = "/home/hanikevi/.dotfiles/emacs";
        recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };
 
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Kevin Haninger";
    userEmail = "khaninger@gmail.com";
  }; 
  programs.emacs = {
   enable = true;
   #package = pkgs.emacs29;
   package = my-emacs-with-packages;
   #package = pkgs.emacs-pgtk;
   extraPackages = epkgs: [
     epkgs.spacemacs-theme
     ];
  }; 
  programs.zsh = {
    enable = true;
    #oh-my-zsh = {    
    #  enable = true;
    #  plugins = [ "git" ];
    #  theme = "agnoster";
    #};

    shellAliases = {
      ll = "ls -l";
      em = "emacs -nw $1";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
    };
  };

  
  
}
