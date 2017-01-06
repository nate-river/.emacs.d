;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defconst *is-a-mac* (eq system-type 'darwin))
(when *is-a-mac*
  (require 'init-osx-keys))

(defconst *work-dir* "C:/users/l/desktop/documents/" )
(when *is-a-mac*
  (setq *work-dir* "~/Documents/Star/") )

(defconst *font* "consolas 11")
(when *is-a-mac*
  (setq *font* "monaco 11") )

(require 'init-package)
(require 'init-hippie-expand)
(require 'init-ido)
(require 'init-whitespace)
(require 'init-smex)
(require 'init-evil)
(require 'init-fonts)
(require 'init-file-tree)
(require 'init-zencoding)
(require 'init-yasnippet)

;;---------------------------------
(require 'init-local)
;; --------------------------------

;; --------------------------------
(require 'init-javascript)
(require 'init-web-beautify)
(require 'init-scheme)

;; --------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (phpcbf yasnippet zencoding-mode neotree term+ sqlplus json-mode exec-path-from-shell web-beautify company auto-complete php-mode php+-mode auto-save-buffers-enhanced default-text-scale markdown-mode+ js2-mode smex paren-face paredit evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
