(add-to-list 'load-path "~/.emacs.d/el")

(require 'php-mode)
;;auto-load php-mode
(add-to-list 
 'auto-mode-alist 
 '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'load-path  "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)


;;hidden emacs starup-message
(setq inhibit-startup-message t)

;;set the default text coding system
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(setq c-basic-offset 4)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq sgml-basic-offset 4)

(global-font-lock-mode t)
(require 'ibuffer)
(global-set-key (kbd "C-x b") 'ibuffer)

;;line set
(column-number-mode t)
(global-linum-mode 1)

(require 'iswitchb)
(iswitch-default-keybindings)

(load "desktop")
(desktop-load-default)
(desktop-read)

;;make emacs can open image
(auto-image-file-mode)
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(require 'hl-line)
(global-hl-line-mode 1)

(setq enable-recursive-minibuffers t)
(setq initial-scratch-message nil)
(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

;disable backup
(setq backup-inhibited t)
;disable auto save
(setq auto-save-default nil)


;;hideshow
(load-library "hideshow")

(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'php-mode-hook        'hs-minor-mode)
(add-hook 'javascript-mode-hook 'hs-minor-mode)
(add-hook 'html-mode-hook       'hs-minor-mode)

;;scroll page settings
(setq scroll-step 1
      scroll-margin 3
      scroll-conservatively 10000)

;;auto complete
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

;;key bindings
(global-set-key (kbd "C-x x") 'evil-mode)
(global-set-key (kbd "C-x C-p") 'bookmark-set)
(global-set-key (kbd "C-x C-n") 'bookmark-jump)
(global-set-key [(f4)] 'kill-buffer-and-window)
(global-set-key [(f3)] 'speedbar)
(global-set-key [(f5)] 'other-window)
(global-set-key [(control s)] 'isearch-forward-regexp)
(global-set-key [(control meta s)] 'isearch-forward)
(global-set-key [(control r)] 'isearch-backward-regexp)
(global-set-key [(control meta r)] 'isearch-backward)
(global-set-key [(meta ?/)] 'hippie-expand)
(global-set-key  [(f1)] 'toggle-hiding)
(global-set-key  [(f2)]  'toggle-selective-display)
