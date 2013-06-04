;;; chinese-gbk.el --- Chinese GBK support

;; Copyright (C) 2001  Su Yong <ysu@mail.ustc.edu.cn>

;; Author: Su Yong <ysu@mail.ustc.edu.cn>
;; Keywords: multilingual, Chinese, GBK

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


;; (define-charset nil 'chinese-gbk-1
;;   [2 94 2 0 ?K 0 "GBK-1" "GBK-1 (Chinese)"
;;      "GBK Chinese Part 1"])
;; (define-charset nil 'chinese-gbk-2
;;   [2 94 2 0 ?L 0 "GBK-2" "GBK-2 (Chinese)"
;;      "GBK Chinese Part 2"])
;; (define-charset nil 'chinese-gbk-3
;;   [2 94 2 0 ?M 0 "GBK-3" "GBK-3 (Chinese)"
;;      "GBK Chinese Part 3"])


;; Part 1:
;; 0x81 - 0xAA : 0x2A chars * 0xBE == 0x1F2C == 7980
;; Part 2:
;; 0xAB - 0xD4 : 0x2A chars * 0xBE == 0x1F2C == 7980
;; Part 3:
;; 0xD5 - 0xFE : 0x2A chars * 0xBE == 0x1F2C == 7980


(define-ccl-program ccl-decode-chinese-gbk
  `(2
    ((loop
      (read r0)
     
      ;; 1 byte encoding, i.e., ascii
      (if (r0 < ?\x80)
          (write r0)

        ;; 2 byte encoding
        (if (r0 > ?\x80)
            (if (r0 < ?\xFF)
                ((read r1)
                

                 (if (r1 > ?\x3F)
                     (if (r1 < ?\x7F)
                         (r1 -= ?\x40)
                       (if (r1 > ?\x7F)
                           (if (r1 < ?\xFF)
                               (r1 -= ?\x41)
                             ((write r0 r1)
                              (repeat)))
                         ((write r0 r1)
                          (repeat))))
                   ((write r0 r1)
                    (repeat)))
                       
                                
                 (if (r0 < ?\xAB)
                     ((r2 = (r0 - ?\x81)) ;; part 1
                      (r0 = ,(charset-id 'chinese-cns11643-5)))
                   (if (r0 < ?\xD5)
                       ((r2 = (r0 - ?\xAB)) ;; part 2
                        (r0 = ,(charset-id 'chinese-cns11643-6)))
                     ((r2 = (r0 - ?\xD5)) ;; part 3
                      (r0 = ,(charset-id 'chinese-cns11643-7)))))

                 (r2 *= ?\xBE) ;; 0xBE == 0xFF - 0x80 + 0x7F - 0x40
                 (r1 += r2)
                 (r2 = (r1 / 94))
                 (r2 <<= 7)
                 (r1 %= 94)
                 (r1 |= r2)
                 (r1 += ,(+ (* 33 128) 33))
                 (write-multibyte-character r0 r1))
              ((write r0 r1)
               (repeat)))
          ((write r0 r1)
           (repeat))))
      (repeat))))

  "CCL program to decode GBK.")


(define-ccl-program ccl-encode-chinese-gbk
  `(1
    ((loop
      (read-multibyte-character r0 r1)
      (if (r0 == ,(charset-id 'ascii))
          (write r1)

        (if (r0 == ,(charset-id 'chinese-cns11643-5))
            ((r0 = ((((r1 & 16256) >> 7) - 33) * 94))
             ;; 16256 == (0011 1111 1000 0000)b
             (r1 &= ?\x7F)
             (r1 += (r0 - 33))
             (r0 = (r1 / ?\xBE))     ;0xBE == 0xFF - 0x80 + 0x7F - 0x40
             (r1 %= ?\xBE)           ;0xBE == 0xFF - 0x80 + 0x7F - 0x40
             (r0 += ?\x81) ;; part 1
             (if (r1 < ?\x3F)
                 (r1 += ?\x40)
               (r1 += ?\x41))
             (write r0 r1))
         
          (if (r0 == ,(charset-id 'chinese-cns11643-6))
              ((r0 = ((((r1 & 16256) >> 7) - 33) * 94))
               ;; 16256 == (0011 1111 1000 0000)b
               (r1 &= ?\x7F)
               (r1 += (r0 - 33))
               (r0 = (r1 / ?\xBE))   ;0xBE == 0xFF - 0x80 + 0x7F - 0x40
               (r1 %= ?\xBE)         ;0xBE == 0xFF - 0x80 + 0x7F - 0x40
               (r0 += ?\xAB) ;; part 2
               (if (r1 < ?\x3F)
                   (r1 += ?\x40)
                 (r1 += ?\x41))
               (write r0 r1))
           
            (if (r0 == ,(charset-id 'chinese-cns11643-7))
                ((r0 = ((((r1 & 16256) >> 7) - 33) * 94))
                 ;; 16256 == (0011 1111 1000 0000)b
                 (r1 &= ?\x7F)
                 (r1 += (r0 - 33))
                 (r0 = (r1 / ?\xBE)) ;0xBE == 0xFF - 0x80 + 0x7F - 0x40
                 (r1 %= ?\xBE)       ;0xBE == 0xFF - 0x80 + 0x7F - 0x40
                 (r0 += ?\xD5) ;; part 3
                 (if (r1 < ?\x3F)
                     (r1 += ?\x40)
                   (r1 += ?\x41))
                 (write r0 r1))))))
      (repeat))))

  "CCL program to encode into GBK.")


(make-coding-system
 'chinese-gbk 4 ?Z
 "Chinese GBK encoding for GBK characters mainly used
on Chinses PCs."

 '(ccl-decode-chinese-gbk . ccl-encode-chinese-gbk)
 '((safe-charsets
    ascii
    chinese-cns11643-5
    chinese-cns11643-6
    chinese-cns11643-7)
   (valid-codes (0 . 254))))

(define-coding-system-alias 'gbk 'chinese-gbk)


(set-language-info-alist
 "Chinese-GBK" '((coding-system chinese-gbk chinese-iso-7bit)
                 (coding-priority chinese-gbk iso-2022-cn chinese-iso-8bit)
                 (input-method . "chinese-py-ucdos")
                 (sample-text . "Chinese GBK ÄãºÃ")
                 (documentation . "Support for Chinese GBK character set."))
 '("Chinese"))


(provide 'chinese-gbk)
;;; chinese-gbk.el ends here
