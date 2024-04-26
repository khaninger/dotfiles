{ config, pkgs, ... }:

{
  targets.genericLinux.enable = true; # when not using NixOS

  home.username = "hanikevi";
  home.homeDirectory = "/home/hanikevi";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs;  [
  ];

  # Manage home files
  home.file = {
    ".emacs.d" = {
        source = "/home/hanikevi/.dotfiles/emacs";
        recursive = true;
    };
  };

  home.shellAliases = {
    ll = "ls -l";
    em = "emacs -nw $1";
    update = "sudo nixos-rebuild switch";    
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };
 
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Kevin Haninger";
    userEmail = "email@host.com";
  }; 
  programs.emacs = {
   enable = true;
   #package = pkgs.emacs29-pgtk;
   package = pkgs.emacs29;
   extraPackages = (
     epkgs: (with epkgs; [
       spacemacs-theme
     ])
   );
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
      format = "$directory$git_branch";
    };
  };

  
  
}
