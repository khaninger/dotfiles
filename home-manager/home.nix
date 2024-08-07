{ config, pkgs, ... }:

let
  my-emacs = pkgs.emacs29.override {
    withNativeCompilation = true;
    withSQLite3 = true;
    withTreeSitter = true;
    withWebP = true;
  };
  my-emacs-with-packages = (pkgs.emacsPackagesFor my-emacs).emacsWithPackages (epkgs: with epkgs; [
    spacemacs-theme
    vterm
    pdf-tools
    treesit-grammars.with-all-grammars
    xclip
  ]);
in
{
  targets.genericLinux.enable = true; # when not using NixOS

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs;  [
    # Python
    ruff
    ruff-lsp
    poetry
    python3Packages.python-lsp-server

    # Rust
    cargo

    # Nix
    nixd
    
    # General dev
    tree-sitter
    emacs-all-the-icons-fonts

    # Misc
    ghostscript
    poppler_utils #pdffonts
    ffmpeg
    htop
    usbtop # also needs sudo modprobe usbmon
    
    (writeShellScriptBin "video_reencode_kazam_ppt" ''
      for file in *.mp4; do
          ffmpeg -i "$file" -c:v libx264 -pix_fmt yuv420p -crf 23 -c:a copy "$file"_yuv420p.mp4
      done
    '')

  ];

  # Manage home files
  home.file = {
    ".emacs.d" = {
      source = "${config.home.homeDirectory}/.dotfiles/emacs";
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
    delta.enable = true; # use the delta highlighter
    extraConfig = {
      http.postBuffer = 157286400;
      pull.rebase = false;
    };
  };

  # Command line helpers
  programs.ripgrep = { enable = true; };
  programs.fd = { enable = true; };
  
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  
  programs.emacs = {
   enable = true;
   package = my-emacs-with-packages;
  }; 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      em = "emacsclient -a '' -nw $1";
      nix = "nix --experimental-features flakes --extra-experimental-features nix-command";
    };
    initExtra = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
    '';
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      git_branch.truncation_length = 10;
      format = "(\($virtualenv\))$directory$git_branch$git_status$character";
    };
  };

  
  
}
