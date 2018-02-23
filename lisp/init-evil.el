(require-package 'evil)
(evil-mode t)

(define-key evil-normal-state-map "q" 'qiang-comment-dwim-line)
(define-key evil-normal-state-map "s" 'save-buffer)
(define-key evil-normal-state-map "c" 'query-replace-regexp)
(define-key evil-normal-state-map "b" 'switch-to-buffer)
(define-key evil-normal-state-map "g=" 'indent-buffer)
(define-key evil-normal-state-map "\M-f" 'indent-buffer)

(define-key evil-normal-state-map "g1" 'delete-other-windows)
(define-key evil-normal-state-map "go" 'other-window)

(define-key evil-normal-state-map "g-" 'hs-hide-all)

(define-key evil-normal-state-map "-" 'hs-hide-block)
(define-key evil-normal-state-map "=" 'hs-show-block)
(define-key evil-normal-state-map "\C-i" 'hs-toggle-hiding)


(define-key evil-normal-state-map "+" 'default-text-scale-increase)
(define-key evil-normal-state-map "_" 'default-text-scale-decrease)

(define-key evil-normal-state-map "\C-n" 'evil-next-line)
(define-key evil-normal-state-map "\C-p" 'evil-previous-line)
(define-key evil-normal-state-map "\C-j" 'evil-next-line)
(define-key evil-normal-state-map "\C-k" 'evil-previous-line)
(define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
(define-key evil-normal-state-map "\M-n" 'evil-next-line)
(define-key evil-normal-state-map "\M-p" 'evil-previous-line)
(define-key evil-normal-state-map "\M-j" 'evil-next-line)
(define-key evil-normal-state-map "\M-k" 'evil-previous-line)
(define-key evil-normal-state-map "\M-e" 'evil-end-of-line)

(define-key evil-normal-state-map "\M-v" 'yank)
(define-key evil-normal-state-map "\M-s" 'save-buffer)

(define-key evil-insert-state-map "\C-j" 'evil-normal-state)
(define-key evil-insert-state-map "\C-k" 'evil-normal-state)
(define-key evil-insert-state-map "\C-h" 'evil-normal-state)
(define-key evil-insert-state-map "\C-l" 'evil-normal-state)
(define-key evil-insert-state-map "\C-n" 'evil-nex-line)
(define-key evil-insert-state-map "\C-p" 'evil-previous-line)
(define-key evil-insert-state-map "\C-f" 'forward-char)
(define-key evil-insert-state-map "\C-b" 'backward-char)

(define-key evil-insert-state-map "\M-j" 'evil-normal-state)
(define-key evil-insert-state-map "\M-k" 'evil-normal-state)
(define-key evil-insert-state-map "\M-h" 'evil-normal-state)
(define-key evil-insert-state-map "\M-l" 'evil-normal-state)
(define-key evil-insert-state-map "\M-n" 'evil-next-line)
(define-key evil-insert-state-map "\M-p" 'evil-previous-line)
(define-key evil-insert-state-map "\M-f" 'forward-char)
(define-key evil-insert-state-map "\M-b" 'backward-char)

(define-key evil-insert-state-map "\M-v" 'yank)
(define-key evil-insert-state-map "\M-s" 'save-buffer)


(eval-after-load 'dired
  '(progn
     (evil-make-overriding-map dired-mode-map 'normal t)
     (evil-add-hjkl-bindings dired-mode-map 'normal
       "j" 'dired-next-line
       "k" 'dired-previous-line
       [(\/)] 'evil-search-forward
       "n" 'evil-search-next
       [(\~)] (lambda () (interactive) (dired "~/"))
       "q" (lambda () (interactive) (dired *work-dir*))
       [(tab)] 'dired-up-directory
       ";" (lookup-key dired-mode-map ":"))))

(eval-after-load 'ibuffer
  '(progn
     (define-key ibuffer-mode-map "j" 'evil-next-line)
     (define-key ibuffer-mode-map "k" 'evil-previous-line)))

(provide 'init-evil)
