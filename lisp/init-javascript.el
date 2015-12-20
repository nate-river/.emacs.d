(setq auto-mode-alist (cons `("\\.\\(js\\|es6\\)\\(\\.erb\\)?\\'" . js2-mode) auto-mode-alist))
(setq-default js2-basic-offset 2)

(provide 'init-javascript)
