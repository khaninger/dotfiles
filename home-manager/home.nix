{ config, pkgs, ... }:

{
  targets.genericLinux.enable = true;

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hanikevi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    TEST = "IN_HOME_MANAGER";
  };
 
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Kevin Haninger";
    userEmail = "email@host.com";
  }; 
  programs.emacs = {
   enable = true;
   package = pkgs.emacs29-pgtk;
   extraPackages = (
     epkgs: (with epkgs; [
       spacemacs-theme
     ])
   );
  }; 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      em = "emacs -nw $1";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };
  
  #wayland.windowManager.sway.enable = true;
}
