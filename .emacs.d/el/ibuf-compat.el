;;; ibuffer-compat.el --- ibuffer compatibility with other Emacsen

;; Copyright (C) 2000, 2001 Free Software Foundation, Inc.

;; Author: Colin Walters <walters@verbum.org>
;; Created: 2 Dec 2001
;; Version: 1.0
;; X-RCS: $Id: ibuf-compat.el,v 1.5 2002/01/23 20:53:41 walters dead $
;; URL: http://cvs.verbum.org/ibuffer
;; Keywords: buffer, convenience

;; This file is not currently part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program ; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(eval-when-compile
  ;; From Emacs 21
  (defvar show-trailing-whitespace)
  (require 'cl))

;; Needed for Emacs 20
(unless (fboundp 'popup-menu)
  (require 'lmenu))

;; XEmacs compatibility
(unless (fboundp 'make-overlay)
  (require 'overlay))

(unless (fboundp 'defsubst)
  (defalias 'defsubst 'defun))

(cond
 ;; Emacs 21
 ((fboundp 'replace-regexp-in-string)
  nil)
 ;; XEmacs
 ((fboundp 'replace-in-string)
  (defun replace-regexp-in-string (text rep string)
    (replace-in-string string text rep)))
 ;; Emacs 20 or less
 (t
  (defun replace-regexp-in-string (regexp rep string)
    "Replace all matches for TEXT with REP in STRING.
This function was modified from the Emacs 21 sources: which see for
the original source and full documentation."
    (let (fixedcase
	  (literal t)
	  subexp
	  (l (length string))
	  (start 0)
	  matches str mb me)
      (save-match-data
	(while (and (< start l) (string-match regexp string start))
	  (setq mb (match-beginning 0)
		me (match-end 0))
	  (when (= me mb) (setq me (min l (1+ mb))))
	  (string-match regexp (setq str (substring string mb me)))
	  (setq matches
		(cons (replace-match (if (stringp rep)
					 rep
				       (funcall rep (match-string 0 str)))
				     fixedcase literal str subexp)
		      (cons (substring string start mb)	; unmatched prefix
			    matches)))
	  (setq start me))
	(setq matches (cons (substring string start l) matches)) ; leftover
	(apply #'concat (nreverse matches)))))))

;; XEmacs, Emacs 20 compatibility
(eval-and-compile
  (if (fboundp 'propertize)
      (defalias 'ibuffer-propertize 'propertize)
    (defun ibuffer-propertize (string &rest properties)
      (let ((str (copy-sequence string)))
	(add-text-properties 0 (length str)
			     properties
			     str)
	str))))

;; XEmacs compatibility stuff
(unless (fboundp 'line-beginning-position)
  (defun line-beginning-position ()
    (save-excursion
      (beginning-of-line)
      (point))))

(unless (fboundp 'line-end-position)
  (defun line-end-position ()
    (save-excursion
      (end-of-line)
      (point))))

(unless (fboundp 'window-buffer-height)
  (defalias 'window-buffer-height 'window-displayed-height))

(if (fboundp 'fit-window-to-buffer)
    (defun shrink-window-to-buffer ()
      ;; `fit-window-to-buffer', new in Emacs 21, is much better.
      (fit-window-to-buffer nil (window-height)))
  (defalias 'shrink-window-to-buffer 'shrink-window-if-larger-than-buffer))

;; Emacs 20/XEmacs compatibility
(eval-and-compile
  (cond ((fboundp 'make-temp-file)
	 nil)
	((and (boundp 'temporary-file-directory)
	      (stringp temporary-file-directory))
	 (defun make-temp-file (prefix)
	   "Create a temporary file.  DO NOT USE THIS FUNCTION.
This function does not create files atomically, and is thus insecure."
	   (let ((name (concat temporary-file-directory (make-temp-name prefix))))
	     (while (file-exists-p name)
	       (setq name (concat temporary-file-directory (make-temp-name prefix))))
	     (append-to-file (point-min) (point-min) name)
	     name)))
	((featurep 'xemacs)
	 (defun make-temp-file (prefix)
	   "Create a temporary file.  DO NOT USE THIS FUNCTION.
This function does not create files atomically, and is thus insecure."
	   (let ((name (expand-file-name (make-temp-name prefix) (temp-directory))))
	     (while (file-exists-p name)
	       (setq name (expand-file-name (make-temp-name prefix) (temp-directory))))
	     (append-to-file (point-min) (point-min) name)
	     name)))
	(t
	 (error "Couldn't create a suitable definition of `make-temp-file'."))))

;; (require 'easymenu)
;; (easy-menu-define
;;   ibuffer-mode-view-menu ibuffer-mode-map ""
;;   '("View"
;;     ["View this buffer" ibuffer-visit-buffer]
;;     ["View (other window)" ibuffer-visit-buffer-other-window]
;;     ["View (other frame)" ibuffer-visit-buffer-other-frame]
;;     ["Update" ibuffer-update
;;      :help "Regenerate the list of buffers"]
;;     ["Switch display format" ibuffer-switch-format
;;      :help "Toggle between available values of `ibuffer-formats'"]
;;     ["Toggle Auto Mode" ibuffer-auto-mode
;;      :help "Attempt to automatically update the Ibuffer buffer"]
;;     "--"
;;     ("Sort"
;;      ["Switch sorting mode" ibuffer-toggle-sorting-mode
;;       :help "Switch between the various sorting criteria"]
;;      ["Reverse sorting order" ibuffer-invert-sorting]
;;      ["Sort by view time" ibuffer-do-sort-by-recency
;;       :help "Sort by the last time the buffer was displayed"]
;;      ["Sort lexicographically" ibuffer-do-sort-by-alphabetic
;;       :help "Sort by the alphabetic order of buffer name"]
;;      ["Sort by buffer size" ibuffer-do-sort-by-size
;;       :help "Sort by the size of the buffer"]
;;      ["Sort by major mode" ibuffer-do-sort-by-major-mode
;;       :help "Sort by the alphabetic order of the buffer's major mode"])
;;     ("Limit"
;;      ["Disable all limiting" ibuffer-limit-disable]
;;      ["Add limit by major mode..." ibuffer-limit-by-mode
;;       :help "Show only buffers in a major mode"]
;;      ["Add limit by buffer name..." ibuffer-limit-by-name
;;       :help "Show only buffers whose name matches a regexp"]
;;      ["Add limit by filename..." ibuffer-limit-by-filename
;;       :help "Show only buffers whose filename matches a regexp"]
;;      ["Add limit by size less than..." ibuffer-limit-by-size-lt
;;       :help "Show only buffers of size less than..."]
;;      ["Add limit by size greater than..." ibuffer-limit-by-size-gt
;;       :help "Show only buffers of size greater than..."]
;;      ["Add limit by content (regexp)..." ibuffer-limit-by-content
;;       :help "Show only buffers containing a regexp"]
;;      ["Add limit by Lisp predicate..." ibuffer-limit-by-predicate
;;       :help "Show only buffers for which a predicate is true"]
;;      ["Remove top limit" ibuffer-pop-limit]
;;      ["OR top two limits" ibuffer-or-limit
;;       :help "Create a new limit which is the logical OR of the top two limits"]
;;      ["Negate top limit" ibuffer-negate-limit]
;;      ["Decompose top limit" ibuffer-decompose-limit
;;       :help "Break down a complex limit like OR or NOT"]
;;      ["Swap top two limits" ibuffer-exchange-limits]
;;      ["Save current limits permanently..." ibuffer-save-limits
;;       :help "Use a mnemnonic name to store current limit stack"]
;;      ["Restore permanently saved limits..." ibuffer-switch-to-saved-limits
;;       :help "Replace current limits with a saved stack"]
;;      ["Add to permanently saved limits..." ibuffer-add-saved-limits
;;       :help "Include current limits in an already saved stack"]
;;      ["Delete permanently saved limits..." ibuffer-delete-saved-limits
;;       :help "Remove stack of limits from saved list"])
;;     "--"
;;     ["Diff with file" ibuffer-diff-with-file
;;      :help "View the differences between this buffer and its file"]
;;     ["Customize Ibuffer" (customize-group 'ibuffer)
;;      :help "Use Custom to customize Ibuffer"]))

;; (easy-menu-define
;;     ibuffer-mode-mark-menu ibuffer-mode-map ""
;;     '("Mark"
;;       ["Toggle marks" ibuffer-toggle-marks
;;        :help "Unmark marked buffers, and mark unmarked buffers"]
;;       ["Mark" ibuffer-mark-forward
;;        :help "Mark the buffer at point"]
;;       ["Unmark" ibuffer-unmark-forward
;;        :help "Unmark the buffer at point"]
;;       ["Mark by mode..." ibuffer-mark-by-mode
;;        :help "Mark all buffers in a particular major mode"]
;;       ["Mark modified buffers" ibuffer-mark-modified-buffers
;;        :help "Mark all buffers which have been modified"]
;;       ["Mark unsaved buffers" ibuffer-mark-unsaved-buffers
;;        :help "Mark all buffers which have a file and are modified"]
;;       ["Mark read-only buffers" ibuffer-mark-read-only-buffers
;;        :help "Mark all buffers which are read-only"]
;;       ["Mark special buffers" ibuffer-mark-special-buffers
;;        :help "Mark all buffers whose name begins with a *"]
;;       ["Mark dired buffers" ibuffer-mark-dired-buffers
;;        :help "Mark buffers in dired-mode"]
;;       ["Mark dissociated buffers" ibuffer-mark-dissociated-buffers
;;        :help "Mark buffers with a non-existent associated file"]
;;       ["Mark help buffers" ibuffer-mark-help-buffers
;;        :help "Mark buffers in help-mode"]
;;       ["Mark old buffers" ibuffer-mark-old-buffers
;;        :help "Mark buffers which have not been viewed recently"]
;;       ["Unmark All" ibuffer-unmark-all]
;;       "--"
;;       "Regexp"
;;       ["Mark by buffer name..." ibuffer-mark-by-name-regexp
;;        :help "Mark buffers whose name matches a regexp"]
;;       ["Mark by major mode..." ibuffer-mark-by-mode-regexp
;;        :help "Mark buffers whose major mode name matches a regexp"]
;;       ["Mark by file name..." ibuffer-mark-by-file-name-regexp
;;        :help "Mark buffers whose file name matches a regexp"]))

;; (easy-menu-define
;;   ibuffer-mode-operate-menu ibuffer-mode-map ""
;;   ("Operate"
;;     ["View" ibuffer-do-view]
;;     ["View (separate frame)" ibuffer-do-view-other-frame]
;;     ["Save" ibuffer-do-save]
;;     ["Replace (regexp)..." ibuffer-do-replace-regexp
;;      :help "Replace text inside marked buffers"]
;;     ["Query Replace..." ibuffer-do-query-replace
;;      :help "Replace text in marked buffers, asking each time"]
;;     ["Query Replace (regexp)..." ibuffer-do-query-replace-regexp
;;      :help "Replace text in marked buffers by regexp, asking each time"]
;;     ["Print" ibuffer-do-print]
;;     ["Toggle modification flag" ibuffer-do-toggle-modified]
;;     ["Revert" ibuffer-do-revert
;;      :help "Revert marked buffers to their associated file"]
;;     ["Rename Uniquely" ibuffer-do-rename-uniquely
;;      :help "Rename marked buffers to a new, unique name"]
;;     ["Kill" ibuffer-do-delete]
;;     ["List lines matching..." ibuffer-do-occur
;;      :help "View all lines in marked buffers matching a regexp"]
;;     ["Pipe to shell command..." ibuffer-do-shell-command-pipe
;;      :help "For each marked buffer, send its contents to a shell command"]
;;     ["Pipe to shell command (replace)..." ibuffer-do-shell-command-pipe-replace
;;      :help "For each marked buffer, replace its contents with output of shell command"]
;;     ["Shell command on buffer's file..." ibuffer-do-shell-command-file
;;      :help "For each marked buffer, run a shell command with its file as argument"]
;;     ["Eval..." ibuffer-do-eval
;;      :help "Evaluate a Lisp form in each marked buffer"]
;;     ["Eval (viewing buffer)..." ibuffer-do-view-and-eval
;;      :help "Evaluate a Lisp form in each marked buffer while viewing it"])

(provide 'ibuf-compat)

;;; ibuf-compat.el ends here
