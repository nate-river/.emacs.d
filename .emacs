;;session setting
;;(require 'session)
;;(add-hook 'after-init-hook 'session-initialize)
;;(add-to-list 'load-path "/usr/share/emacs24/site-lisp")
;;(require 'xcscope)
;;redo
;;(require 'redo+')
;;(global-set-key (kbd "C-?") 'redo)
;;lisp  sbcl
;;(add-to-list 'load-path "~/.emacs.d/slime/")
;;(setq inferior-lisp-program "sbcl")
;;(require 'slime-autoloads)
;;(slime-setup  '(slime-fancy))
;;(slime-setup)
;;(split-window-vertically)
;;(setq initial-frame-alist 
;;      '((top . 0) (left . 250) 
;;        (width . 180) (height .  50)))
;;switch buffer setting
;;(require 'iswitchb)
;;(iswitch-default-keybindings)
;;format emacs title
;;(setq frame-title-format "L@%b::%m@")
;;(menu-bar-mode nil)
;;(tool-bar-mode nil)
;;(scroll-bar-mode nil)
;;auto fill mode on 
;;(setq-default 
;; auto-fill-function 'do-auto-fill)
;;(setq-default mode-line-format t)

;;------------------------------------
;;-----emacs original settings--------

;;hidden emacs starup-message
(setq inhibit-startup-message t)

;;set the default text coding system
(setq default-buffer-file-coding-system 'utf-8)

;;setting English Font
(set-face-attribute
 'default nil :font "consolas 11")

;; Chinese Font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
   (set-fontset-font (frame-parameter nil 'font)
                    charset
                   (font-spec :family "Microsoft Yahei" :size 13)))

(setq c-basic-offset 4)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq sgml-basic-offset 4)

(global-font-lock-mode t)
(require 'ibuffer)
(global-set-key (kbd "C-x b") 'ibuffer)

;;scroll page settings
(setq scroll-step 1
      scroll-margin 3
      scroll-conservatively 10000)

;;line set
(column-number-mode t)
(global-linum-mode 1)


;;rember desktop
(load "desktop")
(desktop-load-default)
(desktop-read)

;;make emacs can open image
(auto-image-file-mode)

;;time setting
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)


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
(global-set-key  [(f1)] 'toggle-hiding)
(global-set-key  [(f2)]  'toggle-selective-display)
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'php-mode-hook        'hs-minor-mode)
(add-hook 'javascript-mode-hook 'hs-minor-mode)
(add-hook 'html-mode-hook       'hs-minor-mode)

(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;--------------------------------------------
;;-----functions base on files 
;;placed in .emacs.d/ dir-----------

(add-to-list 'load-path "~/.emacs.d/")

(require 'php-mode)
;;auto-load php-mode
(add-to-list 
 'auto-mode-alist 
 '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))
;;(require 'tabbar)
;;(tabbar-mode)

;;auto complete
(global-set-key [(meta ?/)] 'hippie-expand)
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
;;-------------------------------------------------

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


(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
;;(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)

(add-to-list 'load-path
              "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(load "~/.emacs.d/color-theme-molokai.el")
(color-theme-molokai)

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)



(setq enable-recursive-minibuffers t)
(setq auto-save-default nil)
(setq initial-scratch-message nil)
(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

