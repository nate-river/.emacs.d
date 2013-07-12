(add-to-list 'load-path "~/.emacs.d/el")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'php-mode)
;;auto-load php-mode
(add-to-list 
 'auto-mode-alist 
 '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
;;(evil-mode 1)

(add-to-list 'load-path  "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

(require 'psvn)

(require 'ibuffer)

(require 'dired-isearch)

(require 'find-file-in-project)

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

(load "desktop")
(desktop-load-default)
(desktop-read)

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

;;line set
(column-number-mode t)
(global-linum-mode 1)

;;make emacs can open image
(auto-image-file-mode)
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(setq enable-recursive-minibuffers t)
(setq initial-scratch-message nil)
(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

;disable backup
(setq backup-inhibited t)
;disable auto save
(setq auto-save-default nil)

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
(setq mac-command-modifier 'control)
(global-set-key [(control e)] 'evil-local-mode)
(global-set-key [(control ?/)] 'hippie-expand)
(global-set-key [(f1)] 'ibuffer)
(global-set-key [(f2)] 'toggle-selective-display)
(global-set-key [(f3)] 'rgrep)
(global-set-key [(f4)] 'eshell)
(global-set-key [(control l)] '(lambda () (interactive) (dired ".")))

(setq ffip-project-root-function '~/Documents/green)

(add-hook 'dired-mode-hook
'(lambda ()
(define-key dired-mode-map [(tab)] 'dired-do-isearch-regexp) 
(define-key dired-mode-map "\e\t" 'dired-do-isearch) 
(define-key dired-mode-map [(?\d)] 'dired-up-directory) 
(define-key dired-mode-map [(backspace)] 'dired-up-directory)
(define-key dired-mode-map  "z" 'dired-name-filter-only-show-matched-lines) 
(define-key dired-mode-map [(s)] 'dired-isearch-forward) 
(define-key dired-mode-map [(r)] 'dired-isearch-backward)
(define-key dired-mode-map [(\/)] (lambda () (interactive)
(dired "/"))) ; 按/返回根目录,
(define-key dired-mode-map [(\~)] (lambda () (interactive)
(dired "~/"))) ; 按~返回home.

;; 下面的快捷键打开rails项目目录对应目录, 仅供参考, 快捷键对应于c, v, b
(define-key dired-mode-map [(c)] (lambda () (interactive)
(dired (concat ffip-project-root "~/Documents/green/App/Defaults/Controller"))))
(define-key dired-mode-map [(v)] (lambda () (interactive)
(dired (concat ffip-project-root "~/Documents/green/App/Defaults/View"))))
(define-key dired-mode-map [(b)] (lambda () (interactive)
(dired (concat ffip-project-root "~/Documents/green/App/Defaults/Model"))))
(define-key dired-mode-map [(y)] (lambda () (interactive)
(dired (concat ffip-project-root "~/Documents/green/Root/script"))))
))

;;(require 'color-theme)
;;(color-theme-blackboard)

