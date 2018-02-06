(require-package 'js2-mode)
(setq auto-mode-alist (cons `("\\.\\(jsx\\|js\\|es6\\)\\(\\.erb\\)?\\'" . js2-mode) auto-mode-alist))
(setq-default js2-basic-offset 2)
(add-hook 'js2-mode-hook 'hs-minor-mode)
(add-hook 'css-mode-hook 'hs-minor-mode)
(add-hook 'html-mode-hook 'hs-minor-mode)

(provide 'init-javascript)
