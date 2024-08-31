  
  ;; Org Agenda  
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (setq org-use-fast-todo-selection 'expert)
  (setq org-agenda-files (directory-files org-directory nil "\\.org$"))
  ;;(setq org-agenda-files (list org-directory))
  (setq org-agenda-start-on-weekday nil)
  (setq org-deadline-warning-days 0)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "BLOCKED(b@)" "STAGED(s)" "DELEGATED(e)" "|" "DONE(d)" "DROPPED(r@)")))
  (setq org-log-states-order-reversed t)
  (setq org-log-done t)
  (setq org-log-mode-items '(closed clock state))
  (setq org-agenda-prefix-format
        '((agenda . " %i %-8c %-12(kevin/get-highest-tag)")
          (todo .   " %i %-8c %-12(kevin/get-highest-tag)")
          (tags .   " %i %-8c %-12(kevin/format-filename-for-agenda)")
          (search . " %i %-8c %-12(kevin/format-filename-for-agenda)")))
  ;;(setq org-agenda-todo-ignore-scheduled 'future)
  (setq org-agenda-show-inherited-tags 'always)
  (setq org-use-property-inheritance t)
  (setq org-agenda-tags-todo-honor-ignore-options nil)

  (setq org-refile-targets
        '((org-agenda-files :maxlevel . 2)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-completion-use-ido t)

  
  ;; Org Super Agenda
  (setq spacemacs-theme-org-agenda-height nil
        org-agenda-time-grid '((today) (0800 1000 1200 1400 1600 1800) " ┈┈┈┈┈" "")
        org-agenda-current-time-string " ᐊ Now"
        org-agenda-skip-scheduled-if-done nil
        org-agenda-skip-deadline-if-done nil
        org-agenda-include-deadlines t
        org-agenda-block-separator ""
        org-agenda-compact-blocks nil
        org-agenda-start-with-log-mode t
        org-agenda-start-with-follow-mode nil
        org-agenda-todo-keyword-format ""
        org-agenda-remove-tags t
        org-super-agenda-hide-empty-groups nil
        ;org-super-agenda-header-properties '(org-super-agenda-header t org-agenda-structural-header t))
        org-super-agenda-header-properties '(org-agenda-structural-header t))
  (setq org-agenda-custom-commands
      '(("p" "Planning view"
         ((agenda  "" ((org-agenda-overriding-header "Deadlines")
                       (org-agenda-span 'week)
                       (org-agenda-time-grid '((nil) (nil) "" ""))
                       (org-agenda-entry-types '(:deadline))
                       (org-agenda-skip-deadline-if-done t)
                       ))
          (alltodo "" ((org-agenda-overriding-header "Scheduled in past")
                        (org-super-agenda-groups
                         '((:name ""
                                  :scheduled past
                                  :order 2)
                           (:discard (:anything t))
                           ))
                        ))
         (alltodo "" ((org-agenda-overriding-header "TODOs")
                       (org-agenda-sorting-strategy '(category-down))
                       (org-super-agenda-groups
                        `((:name "Blocked"
                                 :todo "BLOCKED"
                                 :order 9 )
                          (:discard (:todo "DELEGATED"))
                          (:name "Staged"
                                 :todo "STAGED"
                                 :order 1)
                          (:name "Scheduled - Next week"
                                 :scheduled (before ,(org-read-date nil nil "+8"))
                                 :deadline (before ,(org-read-date nil nil "+8"))
                                 :order 10)
                          (:name "Scheduled - Distant future"
                                 :scheduled (after ,(org-read-date nil nil "+7"))
                                 :deadline (after ,(org-read-date nil nil "+7"))
                                 :order 12)

                          (:name "Unblocked, unscheduled, (unbothered)"
                                 :and (:category "proj" :not (:scheduled future))
                                 :order 3)
                            (:name ""
                                 :and (:category "adv" :not (:scheduled future))
                                 :order 4)
                            (:name ""
                                 :and (:category "acq" :not (:scheduled future))
                                 :order 5)
                            (:name ""
                                 :and (:category "paper" :not (:scheduled future))
                                 :order 6)
                            (:name ""
                                 :and (:category "misc" :not (:scheduled future))
                                 :order 7)
                            (:name ""
                                 :and (:category "capt" :not (:scheduled future))
                                 :order 8)))
                           (org-agenda nil "a")))
         (alltodo "" ((org-agenda-overriding-header "DELEGATED")
                      (org-agenda-sorting-strategy '(category-down tag-down))
                      (org-agenda-prefix-format "  %i %-12(kevin/get-highest-tag) %-10(kevin/get-lowest-tag)")
                      (org-super-agenda-groups
                       `((:name ""
                          ;;:auto-map kevin/get-highest-tag
                          :todo "DELEGATED"
                          :order 2 )
                         (:discard (:anything t))))
                      ))
         ))
        
         ("d" "Day view"
          ((agenda "" ((org-agenda-overriding-header "Today")
                       (org-agenda-span 1)
                       (org-scheduled-past-days 1) ;; ignore tasks scheduled in past
                       (org-agenda-time-leading-zero t)
                       (org-agenda-use-timegrid t)
                       (org-agenda-include-diary nil)
                       (org-agenda-files (append '("exchange2org/outlook_calendar.org") org-agenda-files))
                       (org-agenda-prefix-format "  %i %-6t ")
                       (org-agenda-entry-types '(:scheduled*))
                       ))
           (agenda "" ((org-agenda-overriding-header "Deadlines")
                       (org-agenda-span 3)
                       (org-agenda-include-diary nil)
                       (org-agenda-use-timegrid nil)
                       (org-agenda-skip-scheduled-if-done t)
                       (org-agenda-skip-deadline-if-done t)
                       (org-agenda-skip-timestamp-if-done t)
                       (org-agenda-time-grid '((nil) (nil) "" ""))
                       (org-agenda-prefix-format "  %i %-12T")
                       (org-agenda-entry-types '(:deadline))
                       (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE")))
                       ;;(org-agenda-log-mode-items nil)
                       ))
           (alltodo "" ((org-agenda-overriding-header "Staged")
                        (org-super-agenda-groups
                         '((:name ""
                                  :todo "STAGED"
                                  :scheduled today
                                  :scheduled past
                                  :order 2)
                           (:discard (:anything t))
                           ))
                        ))
           ))
         ("r" "Projects"
          ((todo "STATUS|TODO|STAGED"
                 ((org-agenda-prefix-format "  ")
                  (org-agenda-overriding-header "Projects")
                  (org-agenda-files (file-expand-wildcards "proj_*.org"))
                  (org-super-agenda-groups
                     '((:auto-map (lambda (item)
                      (-when-let* ((marker (or (get-text-property 0 'org-marker item)
                                               (get-text-property 0 'org-hd-marker item)))
                                   (file-path (->> marker marker-buffer buffer-file-name))
                                   (file-name (substring file-path 48 -4))
                                   (directory-name (->> file-path file-name-directory directory-file-name file-name-nondirectory)))
                        (concat "" file-name))))))))
          (todo "STATUS|TODO|STAGED"
                 ((org-agenda-prefix-format "  ")
                  (org-agenda-overriding-header "Advising")
                  (org-agenda-files (file-expand-wildcards "adv_*.org"))
                  (org-super-agenda-groups
                     '((:auto-map (lambda (item)
                      (-when-let* ((marker (or (get-text-property 0 'org-marker item)
                                               (get-text-property 0 'org-hd-marker item)))
                                   (file-path (->> marker marker-buffer buffer-file-name))
                                   (file-name (substring file-path 47 -4))
                                   (directory-name (->> file-path file-name-directory directory-file-name file-name-nondirectory)))
                        (concat "" file-name))))))))
          (todo "STATUS|TODO|STAGED"
                 ((org-agenda-prefix-format "  ")
                  (org-agenda-overriding-header "Papers")
                  (org-agenda-files (file-expand-wildcards "paper_*.org"))
                  (org-super-agenda-groups
                     '((:auto-map (lambda (item)
                      (-when-let* ((marker (or (get-text-property 0 'org-marker item)
                                               (get-text-property 0 'org-hd-marker item)))
                                   (file-path (->> marker marker-buffer buffer-file-name))
                                   (file-name (substring file-path 49 -4))
                                   (directory-name (->> file-path file-name-directory directory-file-name file-name-nondirectory)))
                        (concat "" file-name))))))))))
         )
      )
