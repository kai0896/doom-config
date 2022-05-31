;;; doom-config/general.el -*- lexical-binding: t; -*-

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; map key to awesome grep search thing
(map! :leader :desc"rgrep" "sg" #'rgrep)

;; make company faster
(setq company-dabbrev-downcase 0)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 2)

;; some vterm binds
(defun exec-last-vterm ()
  (interactive)
  (progn
    (+vterm/toggle nil)
    (evil-collection-vterm-insert)
    (vterm-send-up)
    (vterm-send-return)
    (evil-escape)))

;; some rempas:
(map! :leader
      :desc"ranger"
      "r" #'ranger)

(map! :leader
      :desc"window-next"
      "j" #'evil-window-next)

(map! :leader
      :desc"toggle-vterm"
      "tv" (lambda () (interactive) (+vterm/toggle t)))

(map! :leader
      :desc"run-last-vterm-command"
      "v" #'exec-last-vterm)

(map! :leader
      :desc"recompile"
      "e" #'recompile)

;; improve scrolling
(setq mouse-wheel-scroll-amount '(9 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; this is for smooth scroll-margin
(setq scroll-margin 8)
(defvar sm-use-visual-line t)
(defun sm-fix-enable()
  (advice-add 'previous-line :around 'sm-fix))
(defun sm-fix-disable()
  (advice-remove 'previous-line 'sm-fix))
(defun sm-get-lines-from-top ()
  (if sm-use-visual-line
      (save-excursion
        (beginning-of-line)
        (count-screen-lines (point) (window-start)))
    (- (line-number-at-pos (point)) (line-number-at-pos (window-start)))))
(defun sm-fix(old-function &rest args)
  (apply old-function args)
  (let ((diff (- scroll-margin (sm-get-lines-from-top))))
    (when (> diff 0)
    (scroll-down diff))))
(sm-fix-enable)

(setq ranger-show-hidden t)
(setq doom-modeline-height 36)

;; auto indent after yank and paste
(defun paste-and-indent-after ()
  (interactive)
  (evil-paste-after 1)
  (evil-indent (evil-get-marker ?\[) (evil-get-marker ?\])))

(defun paste-and-indent-before ()
  (interactive)
  (evil-paste-before 1)
  (evil-indent (evil-get-marker ?\[) (evil-get-marker ?\])))

(evil-define-key 'normal 'global (kbd "p") 'paste-and-indent-after)
(evil-define-key 'normal 'global (kbd "P") 'paste-and-indent-before)
