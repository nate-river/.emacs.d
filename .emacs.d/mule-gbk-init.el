;; -*-emacs-lisp-*-
;;
;; Emacs startup file for the Debian GNU/Linux mule-gbk package
;;
;; Originally contributed by Nils Naumann <naumann@unileoben.ac.at>
;; Modified by Dirk Eddelbuettel <edd@debian.org>
;; Adapted for dh-make by Jim Van Zandt <jrv@vanzandt.mv.com>
;; Modified by Su Yong <ysu@mail.ustc.edu.cn>

;; The mule-gbk package follows the Debian/GNU Linux 'emacsen' policy and
;; byte-compiles its elisp files for each 'emacs flavor' (emacs21).  
;; The compiled code is then
;; installed in a subdirectory of the respective site-lisp directory.
;; We have to add this to the load-path:
(setq load-path (cons (concat "/usr/share/"
                              (symbol-name debian-emacs-flavor)
			      "/site-lisp/mule-gbk") load-path))


(load-file (concat "/usr/share/" (symbol-name debian-emacs-flavor) "/site-lisp/mule-gbk/chinese-gbk.elc"))
(load-file (concat "/usr/share/" (symbol-name debian-emacs-flavor) "/site-lisp/mule-gbk/characters-gbk.elc"))
(load-file (concat "/usr/share/" (symbol-name debian-emacs-flavor) "/site-lisp/mule-gbk/fontset-gbk.elc"))