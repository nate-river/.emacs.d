(require-package 'default-text-scale)
(require 'default-text-scale)

(set-default-font *font*)

;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     charset
;;                     (font-spec :family "STHeitiSC-Light" :size 11)))
(dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family "Hannotate SC" :size 13)))

(provide 'init-fonts)
