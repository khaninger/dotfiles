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
    lsp-mode
    flycheck
    projectile
    #xclip # copy-paste in terminal
    clipetty
  ]);
in
{
  targets.genericLinux.enable = true; # when not using Nix

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
    nixd # includes nix-tree
    
    # General dev
    tree-sitter
    emacs-all-the-icons-fonts

    # Misc
    ghostscript
    poppler_utils # pdffonts, check for type 3
    ffmpeg
    htop
    btop # prettier htop
    usbtop # also needs `sudo modprobe usbmon`
    dua # disk usage, `dua i`  for interactive
    xdg-utils # xdg-open for links

    # Compress the pdf main.pdf
    (writeShellScriptBin "compress_main_pdf" ''
      gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/printer -dPrinted=false -sOutputFile=compressed.pdf main.pdf
    '')
    
    # The videos from kazaam screen record cant be imported to ppt
    (writeShellScriptBin "video_reencode_kazam_ppt" ''
      for file in *.mp4; do
          ffmpeg -i "$file" -c:v libx264 -pix_fmt yuv420p -crf 23 -c:a copy "$file"_yuv420p.mp4
      done
    '')

    # Open the remote of a git repo in browser
    (writeShellScriptBin "open_remote" ''
      remote_url=$(git config --get remote.origin.url)
      if [ -z "$remote_url" ]; then
       echo "Error: No remote URL found"
       exit 1
      fi
      if [[ $remote_url == git@* ]]; then
       remote_url=$(echo $remote_url | sed 's/:/\//g' | sed 's/git@/https:\/\//g')
      fi
      xdg-open "$remote_url"
      echo "Opened $remote_url in your default browser"
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

  programs = rec {
    home-manager.enable = true;
    
    emacs = {
     enable = true;
     package = my-emacs-with-packages;
    };

    git = {
      enable = true;
      userName = "Kevin Haninger";
      userEmail = "khaninger@gmail.com";
      delta.enable = true; # use the delta highlighter
      extraConfig = {
        http.postBuffer = 157286400;
        pull.rebase = false;
        init.defaultBranch = "main";
      };
    };

    # Command line helpers
    ripgrep = { enable = true; };
    fd = { enable = true; };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # Shells
    zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -l --color=auto";
        em = "emacsclient -a '' -nw $1";
        nix = "nix --experimental-features flakes --extra-experimental-features nix-command";
        ga = "git add";
        gc = "git commit -m";
        gco = "git checkout";
        gl = "git prettylog";
        gp = "git push";
        ".." = "cd ..";
      };
      syntaxHighlighting.enable = true;
      initExtra = ''
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        setopt incappendhistory
        function vterm_printf() { printf "\e]%s\e\\" "$1" }      
        vterm_prompt_end() { vterm_printf "51;A$(whoami)@$(hostname):$(pwd)" }
        starship_precmd_user_func="vterm_prompt_end"
      '';
      history = {
        size = 10000;
        ignorePatterns = ["ls" "cd" "exit"];
        ignoreAllDups = true;
        extended = false;
        share = false; # true forces timesteps in history file
        path = "$HOME/.bash_history";
      };
      profileExtra = ''''; # .profile not sourced by vterm in emacs! 
    };
    bash = {
      enable = true;
      shellAliases = zsh.shellAliases;
      historyFile = zsh.history.path;
      historyIgnore = zsh.history.ignorePatterns;
      historyControl = ["ignoreboth"]; # duplicates and with leading space
      initExtra = ''
      vterm_printf() {
        printf "\e]%s\e\\" "$1"
      }      
      
      vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
      }
      starship_precmd_user_func="vterm_prompt_end"; 
      '';
    };
  starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
        format = "($virtualenv$direnv$nix_shell)$directory$git_branch$git_status$character";
        git_branch = {
          truncation_length = 10;
          format = "[$symbol$branch(:$remote_branch)]($style)";
        };
        direnv = {
          disabled = false;
          unloaded_msg = "";
          loaded_msg = "direnv ";
          format = "[$loaded]($style)";
        };
        nix_shell = {
          format = "[$symbol]($style)";
          symbol = "❄️ ";
        };
        git_status = {
          stashed = ""; # basically always have a stash
          style = "bold purple";
        };
      };
    };
  };
}
