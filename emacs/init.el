;;;;;; File system
(setq default-directory (if (file-directory-p "/mnt/c/Users/hanikevi/Dropbox/01_Notes/Org/")
                            "/mnt/c/Users/hanikevi/Dropbox/01_Notes/Org/"
                            "~/"))
(setq org-directory default-directory)
(setq export-directory-custom "/mnt/c/Users/hanikevi/Desktop/")
(setq org-archive-location (concat org-directory "archived/%s_archive::"))
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq make-backup-files nil)    ;; Avoid filename.ext~ appearing
(setq create-lockfiles nil)     ;; Avoid lockfiles
(when (getenv "WSLENV")
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
	(cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
	    browse-url-generic-args     cmd-args
	    browse-url-browser-function 'browse-url-generic
	    search-web-default-browser 'browse-url-generic))))

;;;;;;; Startup
(setq-default mode-line-format
                  (list "%e" mode-line-front-space mode-line-modified mode-line-frame-identification mode-line-buffer-identification " " mode-line-modes mode-line-end-spaces))
(setq-default truncate-lines t)           ;; No line wrapping
(setq-default global-auto-revert-mode t)  ;; Reload files from disk when changed
(setq-default visible-bell t)                ;; Turn off the hell-bell
(setq-default sentence-end-double-space nil) ;; Sentence division on double space
(setq-default show-paren-mode 1)             ;; Turn on highlighting ()
(setq-default normal-erase-is-backspace-mode 1) ;; Ctrl-backspace work in terminal mode
                                        ;(setq-default vterm-shell "$SHELL -l")   ;; for zsh to load interactively
(setq-default vterm-shell "bash -l")   ;; for zsh to load interactively
(setq-default initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
(setq-default server-client-instructions nil)  ;;  prevent help instructions on  server client start


;; General appearance
(setq-default indent-tabs-mode nil)
(setq-default pop-up-windows nil)
(setq-default pixel-scroll-precision-mode 1)
(setq-default mode-line-format '("%e" mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification " L%l " (vc-mode vc-mode)))


(advice-add 'help-window-display-message :around #'ignore)
(global-tab-line-mode)

;; Fonts
(add-to-list 'default-frame-alist '(font . "Berkeley Mono-14"))

;;;;;;;; Packages
(require 'package)
(add-to-list 'package-archives '("MELPA" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package spacemacs-theme)
(load-theme 'spacemacs-dark t)

(use-package ligature
  :config
  (ligature-set-ligatures
   '(prog-mode org-mode)
   '(; Group A
     ".." ".=" "..." "..<" "::" ":::" ":=" "::=" ";;" ";;;" "??" "???"
     ".?" "?." ":?" "?:" "?=" "**" "***" "/*" "*/" "/**"
     ; Group B
     "<-" "->" "-<" ">-" "<--" "-->" "<<-" "->>" "-<<" ">>-" "<-<" ">->"
     "<-|" "|->" "-|" "|-" "||-" "<!--" "<#--" "<=" "=>" ">=" "<==" "==>"
     "<<=" "=>>" "=<<" ">>=" "<=<" ">=>" "<=|" "|=>" "<=>" "<==>" "||="
     "|=" "//=" "/="
     ; Group C
     "<<" ">>" "<<<" ">>>" "<>" "<$" "$>" "<$>" "<+" "+>" "<+>" "<:" ":<"
     "<:<" ">:" ":>" "<~" "~>" "<~>" "<<~" "<~~" "~~>" "~~" "<|" "|>"
     "<|>" "<||" "||>" "<|||" "|||>" "</" "/>" "</>" "<*" "*>" "<*>" ":?>"
     ; Group D
     "#(" "#{" "#[" "]#" "#!" "#?" "#=" "#_" "#_(" "##" "###" "####"
     ; Group E
     "[|" "|]" "[<" ">]" "{!!" "!!}" "{|" "|}" "{{" "}}" "{{--" "--}}"
     "{!--" "//" "///" "!!"
     ; Group F
     "www" "@_" "&&" "&&&" "&=" "~@" "++" "+++" "/\\" "\\/" "_|_" "||"
     ; Group G
     "=:" "=:=" "=!=" "==" "===" "=/=" "=~" "~-" "^=" "__" "!=" "!==" "-~"
     "--" "---"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t)) 

(use-package dashboard
  :diminish dashboard-mode
  :custom
  (dashboard-center-content t)
  (dashboard-banner-logo-title "Dashboard")
  (dashboard-startupify-list '(dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-items
                               dashboard-insert-newline))
  (dashboard-items '((recents . 10) (projects . 8) (bookmarks . 10)))
  (dashboard-icon-type 'all-the-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  :custom-face
  (dashboard-banner-logo-title ((t (:foreground "#bc6ec5"
                                    :weight bold
                                    :height 2.4))))
  :config  
  (dashboard-setup-startup-hook)
  (setq dashboard-projects-backend 'projectile)
)

(use-package all-the-icons :ensure)

;; Cut/copy from terminal
;(use-package xclip
;  :ensure t
;  :config (xclip-mode))
(use-package clipetty
  :hook (after-init . global-clipetty-mode))


;; Rust IDE Config
(use-package rustic :ensure
  :config
  (setq rustic-test-arguments "-- --nocapture")
  )

;; NIX  IDE config
(use-package nix-mode :ensure)

;;;;;; General IDE Config
(use-package projectile
  :ensure
  :config
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/"))
  :bind
  ("C-c p" . projectile-command-map)
  )

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-idle-delay 0.5
        lsp-enable-symbol-highlighting t
        lsp-enable-snippet nil
        lsp-headerline-breadcrumb-enable nil
        lsp-pylsp-plugins-ruff-enabled f
        lsp-clients-clangd-executable "clangd"
        )
  
  (lsp-register-client (make-lsp-client :new-connection (lsp-stdio-connection "nixd")
                                        :major-modes '(nix-mode)
                                        :priority 0
                                        :server-id 'nixd))
  ;; rust lsp hooks set in rustic
  :hook (python-ts-mode . lsp-deferred)
  :hook (nix-mode . lsp-deferred)
  :hook (c-mode . lsp-deferred)
  :hook (c++-mode . lsp-deferred)
  )

;;(use-package flycheck
;;  :ensure t
;;  :hook (lsp-mode . global-flycheck-mode))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-position 'bottom
        lsp-ui-flycheck-enable t))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode))

(use-package magit)

;;;;;;;;; General navigation, etc
(use-package counsel
  :init (setq projectile-completion-system 'ivy)
  :custom
  (enable-recursive-minibuffers nil)
  (ivy-use-selectable-prompt t) ;; can select the input itself in case similar file exists
  :bind
  ("C-f" . 'swiper)
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  :config
  (ivy-mode 1)
)

(use-package org
  :custom
  (org-startup-indented t)
  (org-startup-shrink-all-tables t)
  (org-startup-folded t)
  (org-return-follows-link t)
  (org-hidden-keywords '(title))
  (org-cycle-level-faces nil)
  (org-tags-column -55)
  (org-n-level-faces 5)
  (org-hide-emphasis-markers t)  ; Make so *bold* is typeset as bold

  ;; Capture
  (org-default-notes-file (concat org-directory "\misc_todos.org"))
  (org-capture-templates
      '(("t" "TODO" entry (file+headline "misc_todos.org" "Captured")
         "** TODO %?")
        ("p" "Personal TODO" entry (file+headline "misc_pers_todos.org" "Captured")
         "** TODO %?")))
  
  ;; Export
  (org-export-with-toc nil)
  (org-export-with-section-numbers 2)

  :bind
  ("\C-ca" . org-agenda)
  ("\C-cc" . org-capture)
  ("\C-ct" . org-show-todo-tree) ;; Show the todo items in the current buffer
  ("\C-cm" . org-mark-subtree)
  ("\C-cb" . org-mark-ring-goto)
  ("\C-n" . org-next-visible-heading)
  ("\C-p" . org-previous-visible-heading)
  (:map org-mode-map ("C-S-k" . kevin/org-kill-subtree))
  
  :hook
  (org-mode . visual-line-mode)

  :config  
  (load-file (concat user-emacs-directory "init-agenda.el"))
  (add-to-list 'org-modules 'org-habit t)

)

(use-package move-text
  :bind
  ("<M-S-up>" . move-text-up)
  ("<M-S-down>" . move-text-down)
)

(use-package transient
  :ensure t
  :config
  (transient-define-prefix kevin/keybindings-buffer ()
    "Temp buffer with my commonly-used keybindings"
    [
     ["File Navigation"
      ("s" "TODOs" (lambda () (interactive) (find-file (expand-file-name "misc_todos.org"))))
      ("d" "Dashboard" (lambda () (interactive) (switch-to-buffer "*dashboard*")))
      ("f" "Personal TODOs" (lambda () (interactive) (find-file (expand-file-name "misc_pers_todos.org"))))
      
      ]

     ["Agenda"
      ("j" "Planning view" (lambda () (interactive) (org-agenda nil "p")))
      ("k" "Day view" (lambda () (interactive) (org-agenda nil "d")))
      ("l" "Tag view" (lambda () (interactive) (org-agenda nil "m")))
      (";" "Capture TODO" (lambda () (interactive) (org-capture nil "t")))
     ]
     
     ["Org"
      ("s" "(C-c t)       Show TODO tree" org-show-todo-tree)
      ("n" "(C-c n)       Narrow to subtree" org-narrow-to-subtree)
      ("x" "(C-c C-x C-a) Archive subtree" org-archive-subtree)
      ("m" "(C-c m)       Mark subtree" org-mark-subtree)
      ]

    ["Reference"
      ("*" "(M-S-up)      Move text up" move-text-up)
      ("*" "(M-S-down)    Move text down" move-text-down)
      ("*" "(C-SPC C-SPC) Mark to ring "
       (lambda () (interactive) (message "Use C-SPC C-SPC to set mark to ring")))
      ("*" "(C-x C-SPC)   Pop global mark ring "
       (lambda () (interactive) (message "Use C-x C-SPC to pop global mark ring")))]
    ]
    )
  :bind
  ("C-d" . kevin/keybindings-buffer)
  )

(defun kevin/org-kill-subtree ()
  "Kill the current subtree."
  (interactive)
  (org-back-to-heading t)
  (org-cut-subtree))

;; Archive subtrees under the same hierarchy as the original org file.
;; Link: https://gist.github.com/Fuco1/e86fb5e0a5bb71ceafccedb5ca22fcfb
(require 'dash)

(defadvice org-archive-subtree (around fix-hierarchy activate)
  (let* ((fix-archive-p (and (not current-prefix-arg)
                             (not (use-region-p))))
         (afile  (car (org-archive--compute-location
		       (or (org-entry-get nil "ARCHIVE" 'inherit) org-archive-location))))
         (buffer (or (find-buffer-visiting afile) (find-file-noselect afile))))
    ad-do-it
    (when fix-archive-p
      (with-current-buffer buffer
        (goto-char (point-max))
        (while (org-up-heading-safe))
        (let* ((olpath (org-entry-get (point) "ARCHIVE_OLPATH"))
               (path (and olpath (split-string olpath "/")))
               (level 1)
               tree-text)
          (when olpath
            (org-mark-subtree)
            (setq tree-text (buffer-substring (region-beginning) (region-end)))
            (let (this-command) (org-cut-subtree))
            (goto-char (point-min))
            (save-restriction
              (widen)
              (-each path
                (lambda (heading)
                  (if (re-search-forward
                       (rx-to-string
                        `(: bol (repeat ,level "*") (1+ " ") ,heading)) nil t)
                      (org-narrow-to-subtree)
                    (goto-char (point-max))
                    (unless (looking-at "^")
                      (insert "\n"))
                    (insert (make-string level ?*)
                            " "
                            heading
                            "\n"))
                  (cl-incf level)))
              (widen)
              (org-end-of-subtree t t)
              (org-paste-subtree level tree-text))))))))


(use-package org-super-agenda
  :hook
  (org-mode . org-super-agenda-mode)
  :custom-face
  (org-agenda-structure ((t (:inherit 'org-level-1))))
  (org-super-agenda-header ((t (:inherit 'org-level-2)))))

(use-package org-superstar
  :custom
  (org-superstar-mode 1)
  (org-hide-leading-stars nil) 
  (org-superstar-leading-bullet nil)
  (org-indent-mode-turns-on-hiding-stars t)
  (org-superstar-headline-bullets-list '("◈" "◉" "▪" "◇" "◦" "▫"))

  :hook
  (org-mode . org-superstar-mode))


;; Old packages not currently used
;;(use-package ein :custom (ein:jupyter-server-use-subcommand "notebook"))
;;(use-package 'org-tree-slide)
;;(use-package 'org-download)
;;(add-hook 'dired-mode-hook 'org-download-enable)
;;(use-package 'org-fragtog)
;;(add-hook 'org-mode-hook (lambda () (org-fragtog-mode 1)))
;;(use-package 'citeproc)  ;;Org-Outlook integration


(defun kevin/org-prompt-for-tag-on-todo-state-change ()
  "Prompt for a tag when changing to a specific TODO state."
  (when (string= org-state "DELEGATED")  ;; replace MYSTATE with your desired TODO state
    (let ((tag (completing-read "Tag to add: " (org-get-buffer-tags))))
      (when (not (string-empty-p tag))
        (org-set-tags-to tag )))))



(defadvice org-export-output-file-name (before org-add-export-dir activate)
  "Set export file name to DATE_HEADLINE.html in `export-directory-custom`."
  (let* ((headline (or (nth 4 (org-heading-components)) "export"))
         (safe-headline (replace-regexp-in-string "[^A-Za-z0-9]+" "_" headline))
         (date-prefix (format-time-string "%Y%m%d"))
         (new-filename (concat date-prefix "_" safe-headline)))
    (when (not pub-dir)
      (setq pub-dir export-directory-custom)
      (unless (file-directory-p pub-dir)
        (make-directory pub-dir t)))
    (ad-set-arg 0
                (expand-file-name
                (concat new-filename ".html")
                pub-dir))))
;; Org capture
(defadvice break-org-export-output-file-name (before org-add-export-dir activate)
"Modifies org-export to place exported files in a different directory"
  (when (not pub-dir)
    (setq pub-dir export-directory-custom)
    (when (not (file-directory-p pub-dir))
      (make-directory pub-dir))))

(defun exchange2org ()
  (interactive)
  (shell-command (concat default-directory "exchange2org/outlook2org.sh")))

(defun kevin/strip-filename (str) (substring str (1+ (string-match "_" str)) -4) )
  (defun kevin/format-filename-for-agenda ()
  "Format the contents of :SUMMARY: property to show in agenda view."
    (let ((local_fname (kevin/strip-filename (file-name-nondirectory (org-entry-get (point) "FILE")))))
    (if (not (seq-empty-p local_fname))
	(format "%s " local_fname) "")))

(defun kevin/get-highest-headline ()
  "Return the highest headline in the current outline path."
  (let ((path (org-get-outline-path t))) ; t = use full text
    (nth 0 path))) ;; index 0 = highest headline, 1 = second highest

(defun kevin/get-second-highest-headline ()
  "Return the 2nd-highest headline in the current outline path, 
or an empty string if there isn't one."
  (let ((path (org-get-outline-path t))) ; t = use full text
    (if (> (length path) 2)  ;; means: top-level, second-level, current
        (nth 1 path)
      "")))

(defun kevin/get-highest-tag ()
  (let ((tags (org-get-tags (point) nil)))
    (if tags (car tags) "" )))

(defun kevin/get-second-highest-tag ()
  (let ((tags (org-get-tags (point) nil)))
    (if (and tags (cadr tags))
        (cadr tags)
      "")))

(defun kevin/get-lowest-tag ()
  (let ((tags (org-get-tags (point) nil)))
    (if tags (car (last tags)) "" )))

;;;;;;; Keybindings
(global-set-key (kbd "C-z") 'undo)   ;; Emacs default is bound to hide Emacs
(global-unset-key (kbd "C-s"))

;; Navigating
(global-set-key (kbd "<M-down>") #'scroll-down-line)
(global-set-key (kbd "<M-up>") #'scroll-up-line)
(global-set-key (kbd "C-x p") 'switch-to-prev-buffer)
(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-S-tab>") 'previous-buffer)

;;(use-package tramp
;;  :custom
;; (tramp-default-method "ssh"))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(ignored-local-variable-values '((eval ispell-change-dictionary "en_US")))
 '(warning-suppress-types '((use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
