;; (require 'psvn)
;;hideshow
;; (load-library "hideshow")
;; (defun toggle-selective-display (column)
;;   (interactive "P")
;;   (set-selective-display
;;    (or column
;;        (unless selective-display
;;          (1+ (current-column))))))
;; (defun toggle-hiding (column)
;;   (interactive "P")
;;   (if hs-minor-mode
;;       (if (condition-case nil
;;               (hs-toggle-hiding)
;;             (error t))
;;           (hs-show-all))
;;     (toggle-selective-display column)))
;; (add-hook 'c-mode-common-hook   'hs-minor-mode)
;; (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
;; (add-hook 'java-mode-hook       'hs-minor-mode)
;; (add-hook 'lisp-mode-hook       'hs-minor-mode)
;; (add-hook 'perl-mode-hook       'hs-minor-mode)
;; (add-hook 'sh-mode-hook         'hs-minor-mode)
;; (add-hook 'php-mode-hook        'hs-minor-mode)
;; (add-hook 'js-mode-hook         'hs-minor-mode)
;; (setq-default mode-line-format nil)
;;make emacs can open image
;; (auto-image-file-mode)
;;(setq enable-recursive-minibuffers t)
;; (global-set-key [(f2)] 'toggle-selective-display)
;; (tabbar-mode nil)
;; (osx-key-mode nil)
;; (add-hook 'c-mode-common-hook   'evil-local-mode)
;; (add-hook 'emacs-lisp-mode-hook 'evil-local-mode)
;; (add-hook 'java-mode-hook       'evil-local-mode)
;; (add-hook 'lisp-mode-hook       'evil-local-mode)
;; (add-hook 'perl-mode-hook       'evil-local-mode)
;; (add-hook 'sh-mode-hook         'evil-local-mode)
;; (add-hook 'php-mode-hook        'evil-local-mode)
;; (add-hook 'js-mode-hook         'evil-local-mode)
;; (add-hook 'css-mode-hook        'evil-local-mode)
;; (add-hook 'sql-mode-hook        'evil-local-mode)
;; (add-hook 'dired-mode-hook        'evil-local-mode)
;; (add-hook 'ibuffer-mode-hooks        'evil-local-mode)
;; (add-hook 'fundamental-mode        'evil-local-mode)
;; (defun my-html-mode-hooks ()
;;   "Set ups for how I like html mode."
;;   ;; (hs-minor-mode 1)
;;   (html-mode 1)
;;   )
;; (add-hook 'html-mode-hook 'my-html-mode-hooks)
;; auto-load php-mode

;;(tabbar-mode t)
;;(setq tabbar-buffer-groups-function
;;    (lambda (b) (list "All Buffers")))
;; (setq tabbar-buffer-list-function
;;    (lambda ()
;;        (remove-if
;;          (lambda(buffer)
;;             (find (aref (buffer-name buffer) 0) " *"))
;;          (buffer-list))))
;;(require 'recentf)
;;(recentf-mode 1)
;;(defun recentf-open-files-compl ()
;; (interactive)
;;  (let* ((all-files recentf-list)
;;         (tocpl (mapcar (function
;;                         (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
;;         (prompt (append '("File name: ") tocpl))
;;         (fname (completing-read (car prompt) (cdr prompt) nil nil)))
;;    (find-file (cdr (assoc-ignore-representation fname tocpl)))))

;;(global-set-key [(control x)(f)] 'recentf-open-files-compl)
;; (autoload 'mmm-mode "mmm-mode" "Multiple Major Modes" t)
;; (autoload 'mmm-parse-buffer "mmm-mode" "Automatic MMM-ification" t)
;;key bindings

;; (setq ffip-project-root-function '~/Documents/green)
;; (require 'ido)
;; (ido-mode t)
;;(require 'session)
;;(add-hook 'after-init-hook 'session-initialize)


(add-to-list 'load-path "~/.emacs.d/el")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/themes")
(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path  "~/.emacs.d/yasnippet")
(add-to-list 'magic-mode-alist 
    '("\\(?:<\\?xml\\s +[^>]*>\\)?\\s *<\\(?:!--\\(?:[^-]\\|-[^-]\\)*-->\\s *<\\)*\\(?:!DOCTYPE\\s +[^>]*>\\s *<\\s *\\(?:!--\\(?:[^-]\\|-[^-]\\)*-->\\s *\<\\)*\\)?[Hh][Tt][Mm][Ll]"
        . html-mode))
(add-to-list
 'auto-mode-alist
 '("\\.html\\'" . html-mode))

(require 'evil)
(evil-mode 1)
(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-indent-mode)
(require 'php-mode)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(require 'ibuffer)
(require 'dired-isearch)
(require 'find-file-in-project)

(setq inhibit-startup-message t)
(tool-bar-mode t)
(setq frame-title-format "")

(setq locale-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(setq c-basic-offset 4)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq sgml-basic-offset 4)
(global-font-lock-mode t)
;; (scroll-bar-mode )

(column-number-mode t)
(global-linum-mode 1)

(show-paren-mode t)
(setq show-paren-style 'parentheses)

(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(setq backup-inhibited t)
(setq auto-save-default nil)
(setq scroll-step 1
      scroll-margin 6
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

(require 'browse-kill-ring)
(global-set-key [(control x)(k)] 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

(setq x-select-enable-clipboard t)
(require 'textmate)
(tm/initialize)
;;不让evil-mode污染光标颜色
(setq evil-default-cursor nil)
;; (set-background-color "black")
(defun qiang-comment-dwim-line (&optional arg)
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)

(eval-after-load 'dired '(progn (require 'joseph-single-dired)))
(put 'narrow-to-page 'disabled nil)


(setq mac-command-modifier 'control)
(global-set-key [(control ?/)] 'hippie-expand)
(global-set-key [(f1)] 'ibuffer)
(global-set-key [(f2)] 'evil-local-mode)
(global-set-key [(f3)] 'rgrep)
(global-set-key [(f4)] 'eshell)
(global-set-key [(f8)] 'svn-status)
(global-set-key [(f10)] 'clipboard-yank)
(global-set-key [(f11)] 'clipboard-kill-region)
(global-set-key [(control l)] '(lambda () (interactive) (dired ".")))
(global-set-key [(control s)] 'save-buffer)
(global-set-key [(control q)] 'kill-buffer)
(global-set-key [(control r)] 'isearch-forward-regexp)


(set-default-font "Monaco 13")
(require 'color-theme)
(color-theme-initialize)
;; (color-theme-snow)
;; (color-theme-monokai)
(color-theme-mac-classic)
;; (color-theme-vim-colors)
;; (color-theme-blackboard)
;; (color-theme-all-hallows-eve)
;; (color-theme-andreas)
;; (color-theme-bharadwaj)
;; (color-theme-resolve)
;; (load "desktop")
;; (desktop-load-default)
;; (desktop-read)
