(defun sanityinc/utf8-locale-p (v)
  "Return whether locale string V relates to a UTF-8 locale."
  (and v (string-match "UTF-8" v)))

(defun sanityinc/locale-is-utf8-p ()
  "Return t iff the \"locale\" command or environment variables prefer UTF-8."
  (or (sanityinc/utf8-locale-p (and (executable-find "locale") (shell-command-to-string "locale")))
      (sanityinc/utf8-locale-p (getenv "LC_ALL"))
      (sanityinc/utf8-locale-p (getenv "LC_CTYPE"))
      (sanityinc/utf8-locale-p (getenv "LANG"))))

(when (or window-system (sanityinc/locale-is-utf8-p))
  (set-language-environment 'utf-8)
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-selection-coding-system (if (eq system-type 'windows-nt) 'utf-16-le 'utf-8))
  (prefer-coding-system 'utf-8))

(defun qiang-comment-dwim-line (&optional arg)
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(global-linum-mode t)
(global-auto-revert-mode t)
(electric-pair-mode t)
(show-paren-mode t)
(auto-save-mode 0)
(setq make-backup-files nil)

(global-set-key "\M-l" '(lambda () (interactive) (dired ".")))

(provide 'init-local)
