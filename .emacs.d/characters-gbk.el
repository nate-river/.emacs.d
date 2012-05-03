;;; chinese-charactors.el --- syntax for Chinese GBK characters

;; Copyright (C) 2002  Free Software Foundation, Inc.

;; Author: Su Yong <ysu@mail.ustc.edu.cn>
;; Keywords: i18n

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; 

;;; Code:


;; Chinese character set (GBK)

(let ((gbk-list '(chinese-cns11643-5
		  chinese-cns11643-6
		  chinese-cns11643-7))
      generic-charset)
  (while gbk-list
    (setq generic-charset (car gbk-list))

    (modify-syntax-entry (make-char generic-charset) "w")
    (modify-syntax-entry (make-char generic-charset 33) "_")
    (modify-syntax-entry (make-char generic-charset 34) "_")
    (modify-syntax-entry (make-char generic-charset 41) "_")
    (modify-syntax-entry ?\¡² "(¡³")
    (modify-syntax-entry ?\¡´ "(¡µ")
    (modify-syntax-entry ?\¡¶ "(¡·")
    (modify-syntax-entry ?\¡¸ "(¡¹")
    (modify-syntax-entry ?\¡º "(¡»")
    (modify-syntax-entry ?\¡¼ "(¡½")
    (modify-syntax-entry ?\¡¾ "(¡¿")
    (modify-syntax-entry ?\¡³ ")¡²")
    (modify-syntax-entry ?\¡µ ")¡´")
    (modify-syntax-entry ?\¡· ")¡¶")
    (modify-syntax-entry ?\¡¹ ")¡¸")
    (modify-syntax-entry ?\¡» ")¡º")
    (modify-syntax-entry ?\¡½ ")¡¼")
    (modify-syntax-entry ?\¡¿ ")¡¾")

    (modify-category-entry (make-char generic-charset) ?c)
    (modify-category-entry (make-char generic-charset) ?\|)
    (modify-category-entry (make-char generic-charset 35) ?A)
    (modify-category-entry (make-char generic-charset 36) ?H)
    (modify-category-entry (make-char generic-charset 37) ?K)
    (modify-category-entry (make-char generic-charset 38) ?G)
    (modify-category-entry (make-char generic-charset 39) ?Y)
    (let ((row 48))
      (while (< row 127)
        (modify-category-entry (make-char generic-charset row) ?C)
        (setq row (1+ row))))
    (setq gbk-list (cdr gbk-list))))


(provide 'chinese-charactors)
;;; chinese-charactors.el ends here
