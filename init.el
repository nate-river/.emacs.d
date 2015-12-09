(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defconst *is-a-mac* (eq system-type 'darwin))
(when *is-a-mac*
  (require 'init-osx-keys))

(defconst *work-dir* "c:/users/l/desktop/documents/" )
(when *is-a-mac*
  (setq *work-dir* "~/Documents/Star/") )

(defconst *font* "consolas")
(when *is-a-mac*
  (setq *font* "monaco") )

(require 'init-package)
(require 'init-fonts)
(require 'init-smex)
(require 'init-hippie-expand)
(require 'init-ido)
(require 'init-yasnippet)
(require 'init-javascript)
(require 'init-whitespace)

(require 'init-evil)
(require 'init-local)
