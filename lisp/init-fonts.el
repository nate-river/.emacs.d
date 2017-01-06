(require 'default-text-scale)

(set-default-font *font*)

(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
                    charset
                    (font-spec :family "STHeitiSC-Light" :size 12)))

(provide 'init-fonts)
