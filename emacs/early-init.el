;;(setq gc-cons-threshold most-positive-fixnum)
(setq read-process-output-max (* 1024 1024)) ;; recommended for lsp-mode
;;(setq inhibit-compacting-font-caches t)

(setq package-enable-at-startup nil
      package-quickstart nil
      load-prefer-newer t)

;;; Native compilation settings
(setq native-comp-speed 2)
(setq native-comp-async-report-warnings-errors nil)
;;(when (boundp 'native-comp-eln-load-path)
;;  (startup-redirect-eln-cache "/home/hanikevi/.emacs.d/eln-cache/")))


(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message (user-login-name))
(setq initial-scratch-message nil)
(setq inhibit-startup-message t)

(defun display-startup-echo-area-message ()
  (message ""))

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(undecorated t) default-frame-alist)

(setq frame-inhibit-implied-resize t)
