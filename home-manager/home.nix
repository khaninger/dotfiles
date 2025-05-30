{ config, pkgs, ... }:

let
  my-emacs = pkgs.emacs30.override {
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
    move-text
    clipetty
  ]);

in
{
  targets.genericLinux.enable = true; # when not using Nix

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs;  [
    # Python
    ruff
    #ruff-lsp # missing in unstable, but seems to run from just ruff 
    poetry

    # Rust
    rustup
    
    # Nix
    nixd # includes nix-tree
    nh
    cachix
    
    # C++
    cmake
    clang-tools # needed for C++ mode emacs
    
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
      gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/printer -dColorImageResolution=600 -dPrinted=false -sOutputFile=compressed.pdf main.pdf
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

        # Custom diff and merge tool configuration
        diff.tool = "ediff";
        difftool.ediff.cmd = "ediff $LOCAL $REMOTE $MERGED";
        merge.tool = "ediff";
        mergetool.ediff.cmd = "ediff $LOCAL $REMOTE $MERGED $BASE";
        mergetool.ediff.trustExitCode = true;
  
      };
      ignores = [ " **/__pycache__/" "*.pyc" ".venv" ];
    };

    # Command line helpers
    ripgrep = { enable = true; };
    fd = {
      enable = true;
      ignores = [".git" ".direnv" ".venv" ".local" "*.pyc" "__pycache__"];
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      changeDirWidgetCommand = "fd --type d";
      fileWidgetCommand = "fd --type f";
    };
    
    # Shells
    zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -l --color=auto";
        em = "emacsclient -a '' -nw $1";
        ga = "git add";
        gc = "git commit -m";
        gco = "git checkout";
        gl = "git prettylog";
        gp = "git push";
        ".." = "cd ..";
      };
      syntaxHighlighting.enable = false;
      initContent = ''
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word

        # Not exposed via home-manager, but needed to keep zsh history updated online
        setopt incappendhistory

        source ${builtins.toString ./wezterm.sh}
      '';
      history = {
        size = 10000;
        ignorePatterns = ["ls" "cd" "exit"];
        ignoreAllDups = true;
        extended = false;
        share = false; # true forces timesteps in history file
        path = "$HOME/.bash_history";
      };
      #profileExtra = ''''; # .profile not sourced by vterm in emacs! 
    };
    bash = {
      enable = true;
      shellAliases = zsh.shellAliases;
      historyFile = zsh.history.path;
      historyIgnore = zsh.history.ignorePatterns;
      historyControl = ["ignoreboth"]; # duplicates and with leading space
      initExtra = ''
      # Keep vterm directory sync with emacs
      vterm_printf() {
        printf "\e]%s\e\\" "$1"
      }      
      vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
      }
      starship_precmd_user_func="vterm_prompt_end";

      source ${builtins.toString ./wezterm.sh}
      '';
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
        format = "($virtualenv$direnv$nix_shell)$directory$git_branch$git_status$linebreak$character";
        
        character = {
          success_symbol = "[❯](#2aa198)";
          error_symbol = "[❯](#d70000)";
        };

        directory = {
          style = "#4f97d7";
        };
        
        git_branch = {
          symbol = "";
          truncation_length = 10;
          format = "[$symbol$branch(:$remote_branch)]($style)";
          style = "#af00df";
        };
        
        direnv = {
          disabled = false;
          unloaded_msg = "";
          loaded_msg = "☥";
          format = "[$loaded]($style)";
          style = "bold #00ffff";
        };
        
        nix_shell = {
          format = "[$symbol]($style)";
          symbol = "❄ ";
          style = "bold #00ffff";
        };
        
        git_status = {
          format = "([\\[$all_status$ahead_behind\\]]($style))";
          stashed = ""; # basically always have a stash
          style = "bold #af00df";
        };
      };
    };    
  };
}
