;;; xf.el --- dynamically create x-fixed-font-alist of ISO Latin fonts

;;; Copyright (C) 1994 Piotr Filip Sawicki

;; Author: Piotr Filip Sawicki (<EMAIL: PROTECTED>)
;; Organization: Institute of Informatics at University of Warsaw, Poland
;; Maintainter: PFS
;; Keywords: none

;;; This file is NOT a part of GNU Emacs.

;;; This package is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 2, or
;;; (at your option) any later version.

;;; The package is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;; Commentary:

;; This code creates dynamically x-fixed-font-alist of all ISO Latin fonts.

;; Upon loading the package queries the server (this operation takes
;; enormously long time) two times for monospaced "m" and "c"
;; (cell-based?) fonts and records the list in the variable
;; xf-latin-fonts. Then the function xf-load-fonts creates sorted
;; lists of all fonts divided by encoding type and family. Surplus
;; fonts that differ by resolution and average char width (I had no
;; choice, there are too many fonts) are removed.

;; Since some fonts of strange size will never be used anyway, you can
;; remove too big or too small fonts. By default, all fonts smaller
;; than 10 or bigger than 24 points are removed (see variables below).

;; You should call xf-load-fonts by yourself; it can be used only
;; once, as the code at the end sets xf-latin-fonts to nil.

;; Previously this code created a three-level font list, on the top
;; level split according to encoding, but that kind of structure could
;; not not be handled by x-popup-menu. The drawback of current
;; approach is that you can find yourself with the long list of
;; entries starting with useless in this case "Latin1" prefix.

;; To maintain backward compatibility, the very first font on the very
;; first sublist is the default font (surprisingly).

;; To make use of this code, put in your .emacs the following two lines:
;;	(load-file "<the full path to this file on your system>")
;;	(xf-load-fonts)

;;; Code:

(defvar xf-latin-fonts
  (and (eq window-system-version 11)
       (append (x-list-fonts "*-m-*-iso8859-*")
	       (x-list-fonts "*-c-*-iso8859-*")))
  "List of all appropriate Latin fonts.")

(defvar xf-x-font-family "-[^-]+-\([^-]+\)-")
(defvar xf-x-font-encoding "-iso8859-\(.*\)")
(defvar xf-x-font-fixed "-\(fixed\|clean\)-")
(defvar xf-x-font-size "-\(sans\|gs\|\)-\([0-9]+\)-")
(defvar xf-temp-font-list nil)

(defvar xf-font-too-big "25"
  "Remove all fonts bigger than or equal to this size.")
(defvar xf-font-too-small "10"
  "Remove all fonts smaller than this size.
If the size is one digit long, prepend a space.")

(defun xf-substr (str reg &optional num)
  "Cut the match out of string."
  (if (not num) (setq num 1))
  (if (not (string-match reg str)) nil
    (substring str (match-beginning num) (match-end num))))

(defun xf-strip-list (font-list)
  "Removes from the list all fonts that have the same or too big/small size.
Also adds dividing lines between fonts of the different size."
  (let ((font-new `())
	(last-font "")
	(last-size "")
	this-font this-size)
    (while font-list
      (setq this-font (car (car font-list)))
      (and (not (string= last-font this-font))
	   (string< xf-font-too-small this-font)
	   (string< this-font xf-font-too-big)
	   (setq this-size (xf-substr (car (cdr (car font-list)))
				     xf-x-font-size 2)
		 font-new (cons (car font-list)
				(cond
				 ((string= this-size last-size) font-new)
				 ((string= last-size "") font-new)
				 (t (cons `("") font-new))))
		 last-font this-font
		 last-size this-size))
      (setq font-list (cdr font-list)))
    font-new))

(defun xf-comp-font-list (l r)
  "Used for font sorting: compare by encoding and family (reversed order)."
  (let* ((l-f (car (cdr l))) (r-f (car (cdr r)))
	 (l-latin1 (string-match "-iso8859-1" l-f))
	 (r-latin1 (string-match "-iso8859-1" r-f)))
    (cond
     ((and l-latin1 (not r-latin1)) nil)
     ((and (not l-latin1) r-latin1) t)	
     ((string< (xf-substr r-f xf-x-font-family)
	       (xf-substr l-f xf-x-font-family))))))

; call this function yourself

(defun xf-load-fonts ()
  (interactive)
  (if xf-latin-fonts
      (let ((font-list xf-latin-fonts)
	    (font-sub `())
	    font-found font-enc font-fam font-new font-size)
	; first construct linear list, then sort, divide, and sub-sort again
	; also, downcase all font names, to avoid troubles later
	(while font-list
	  (setq font-found (downcase (car font-list))
		font-sub 
		(cons
		 (list (concat
			(cond
			 ((string-match
			   "-\(sans\|gs\)-\([0-9]+\)-"
			   font-found)
			  (concat
			   (progn
			     (setq font-size (substring font-found
							(match-beginning 2)
							(match-end 2)))
			     (if (< (string-to-number font-size) 10)
				 (concat " " font-size)
			       font-size))
			   " "
			   (substring font-found
				      (match-beginning 1)
				      (match-end 1))))
			 ((string-match "--\([0-9]+\)-" font-found)
			  (concat
			   (progn
			     (setq font-size (substring font-found
							(match-beginning 1)
							(match-end 1)))
			     (if (< (string-to-number font-size) 10)
				 (concat " " font-size)
			       font-size))))
			 (t "??"))
			(progn
			  (string-match
			   "-\([^-]+\)-\(sans\|gs\|\)-\([0-9]+\)-"
			   font-found)
			  (if (string= (substring font-found
						  (match-beginning 1)
						  (match-end 1))
				       "normal")
			      ""
			    (concat " "
				    (substring font-found
					       (match-beginning 1)
					       (match-end 1)))))
			(if (string-match "-medium-" font-found)
			    ""
			  (concat
			   " "
			   (substring font-found
				      (+ 1 (string-match
					    x-font-regexp-weight font-found))
				      (- (match-end 0) 1))))
			(if (string-match "-[oi]-" font-found) " slant" ""))
		       font-found)
		 font-sub)
		font-list (cdr font-list)))
	(setq font-list (sort font-sub `xf-comp-font-list)
	      font-found (car (cdr (car font-list)))
	      font-enc (xf-substr font-found xf-x-font-encoding)
	      font-fam (xf-substr font-found xf-x-font-family)
	      font-sub `()
	      f