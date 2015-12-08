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
