;;; sawmill.el --- Sawmill mode.
;; Copyright 1999,2000 by Dave Pearson <davep@davep.org>
;; $Revision: 1.1 $

;; sawmill.el is free software distributed under the terms of the GNU
;; General Public Licence, version 2. For details see the file COPYING.

;;; Commentary:
;;
;; sawmill.el is an emacs mode for writing code for the sawmill window
;; manager <URL:http://sawmill.sourceforge.net/>. As well as providing a
;; programming mode it also allows for direct interaction with the running
;; window manager.

;;; THANKS:
;;
;; John Harper <john@dcs.warwick.ac.uk> for help regarding sawmill and rep.
;;
;; Stefan Monnier for finding the font-lock (or lack of) with derived modes
;; problem and providing a fix for GNU Emacs.
;;
;; Jan Vroonhof for his invaluable pointers regarding XEmacs.

;;; BUGS:
;;
;; o The handling of the apropos buffer totally breaks down under XEmacs.
;;
;; o I can't figure out how to delete a menu in GNU emacs.

;;; INSTALLATION:
;;
;; o Drop sawmill.el somwehere into your `load-path'. Try your site-lisp
;;   directory for example (you might also want to byte-compile the file).
;;
;; o Add autoloads for the various sawmill functions to ~/.emacs. At the
;;   very last you want to do something like:
;;
;;   (autoload 'sawmill-mode "sawmill" "sawmill-mode" t)
;;
;; o Add the following to ~/.emacs to ensure that sawmill mode is used when
;;   you go to edit sawmill code:
;;
;;   (setq auto-mode-alist (cons '("\\.sawmillrc$" . sawmill-mode) auto-mode-alist)
;;         auto-mode-alist (cons '("\\.jl$" . sawmill-mode) auto-mode-alist))

;;; Code:

;; Things we need:
(eval-when-compile
  (require 'cl)
  (require 'info))
(require 'thingatpt)
(require 'font-lock)
(require 'pp)
(require 'easymenu)
(require 'inf-lisp)

;; Shut the compiler up.
(eval-when-compile

  ;; Keep everyone quiet.
  (defvar sawmill-mode-map)
  (defvar sawmill-mode-menu)
  
  ;; Things to keep XEmacs quiet.
  (unless (boundp 'font-lock-defaults-alist)
    (defvar font-lock-defaults-alist))
  
  ;; Things to keep GNU Emacs quiet.
  (unless (boundp 'delete-menu-item)
    (defun delete-menu-item (path)
      nil)))

;; Attempt to handle older/other emacs.
(eval-and-compile
  ;; If customize isn't available just use defvar instead.
  (unless (fboundp 'defgroup)
    (defmacro defgroup  (&rest rest) nil)
    (defmacro defcustom (symbol init docstring &rest rest)
      `(defvar ,symbol ,init ,docstring))))

;; Customize options.

(defgroup sawmill nil
  "Mode for editing the configuration of and interacting with the sawmill
window manager."
  :group 'languages
  :prefix "sawmill-")

(defcustom sawmill-client "sawmill-client"
  "*Command for interacting with the window manager."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-exec-parameter "-e"
  "*Parameter for `sawmill-client' that tells it to eval a form and exit."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-interactive-parameter "-"
  "*Interactive mode parameter for `sawmill-client'."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-result-buffer "*sawmill*"
  "*Name of the long result display buffer."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-help-buffer "*sawmill-help*"
  "*Name of the sawmill help buffer."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-apropos-buffer "*sawmill-apropos*"
  "*Name of the sawmill apropos buffer."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-scratch-buffer "*sawmill-scratch*"
  "*Name of the sawmill scratch buffer."
  :type  'string
  :group 'sawmill)

(defcustom sawmill-buffer-symbol-lists t
  "*Buffer the lists of function and variable names?"
  :type  'boolean
  :group 'sawmill)

(defcustom sawmill-apropos-searches-info-files t
  "*Search info files for apropos \"one-liner\" help?

This variable controls the action of the sawmill apropos functions. When nil
the apropos functions won't go looking in the sawmill info files for a
one-line doc-string to display in the apropos buffer if the symbol doesn't
have a doc-string. This will make apropos calls a lot faster."
  :type  'boolean
  :group 'sawmill)

(defcustom sawmill-mode-hook nil
  "*List of hooks to execute on entry to sawmill-mode."
  :type  'hook
  :group 'sawmill)

(defcustom sawmill-info-files '(("sawmill" "Function Index" "Variable Index")
                                ("librep"  "Function Index" "Variable Index"))
  "*List of info files to search when looking for info documentation.

This is a list of lists. Each entry in the list is of the format:

  (INFO-FILE FUNCTION-INDEX VARIABLE-INDEX)"
  :type  '(repeat (list    :tag "Info file information"
                   (string :tag "Info file name")
                   (string :tag "Function index name")
                   (string :tag "Variable index name")))
  :group 'sawmill)

;; Non customising variables.

(defvar sawmill-function-list nil
  "List of sawmill functions.")

(defvar sawmill-variable-list nil
  "List of sawmill variables.")

(defvar sawmill-function-p '(lambda (s)
                             (and
                              (boundp s)
                              (or
                               (functionp (symbol-value s))
                               (macrop (symbol-value s))
                               (special-form-p (symbol-value s)))))
  "Closure to pass to sawmill-client for testing if a symbol is a function.")

(defvar sawmill-variable-p `(lambda (s)
                             (and (boundp s)
                              (not (,sawmill-function-p s))))
  "Closure to pass to sawmill-client for testing if a symbol is a variable.")

(defvar sawmill-read-expression-map nil
  "Minibuffer keymap used for reading sawmill lisp expressions.")

(defvar sawmill-interaction-mode-map nil
  "Keymap for use with `sawmill-interaction'.")

(defvar sawmill-read-expression-history nil
  "History list for `sawmill-eval-expression'.")

(defvar sawmill-describe-symbol
  '(lambda (s)
    (if (boundp s)
        (cond ((special-form-p   (symbol-value s)) "Special form")
              ((macrop           (symbol-value s)) "Macro")
              ((subrp            (symbol-value s)) "Built-in function")
              ((commandp         (symbol-value s)) "Command")
              ((functionp        (symbol-value s)) "Function")
              ((const-variable-p               s)  "Constant")
              (t                                   "Variable"))
      "Symbol"))
  "Closure to pass to sawmill-client that will describe a symbol's binding.")

;; Main code:

(define-derived-mode sawmill-mode emacs-lisp-mode "Sawmill"
  "Major mode for editing sawmill files and for interacting with sawmill.

Special commands:

\\{sawmill-mode-map}"
  ;; `define-derived-mode' in both GNU Emacs and XEmacs doesn't appear to
  ;; derive the font-lock settings. So, depending on the editor in use we
  ;; need to drag those settings down to us in different ways (hmm)....
  (if (boundp 'running-xemacs)
      ;; XEmacs appears to do something like this...
      (put 'sawmill-mode 'font-lock-defaults (get 'emacs-lisp-mode 'font-lock-defaults))
    ;; ...with GNU Emacs we need to pull it from `font-lock-defaults-alist'.
    (unless font-lock-defaults
      ;; If `font-lock-defaults-alist' is bound...
      (when (boundp 'font-lock-defaults-alist)
        (set (make-local-variable 'font-lock-defaults)
             (cdr (assoc 'emacs-lisp-mode font-lock-defaults-alist))))))
  ;; Menu stuff.
  (if (boundp 'running-xemacs)
      ;; XEmacs.
      (progn
        ;; For some odd reason `delete-menu-item' doesn't seem to always work.
        ;; Anyone know why?
        (delete-menu-item '("Emacs-Lisp"))
        ;; XEmacs seems to require that you add the menu yourself.
        (easy-menu-add sawmill-mode-menu))
    ;; What about GNU Emacs? How do I delete a menu?
    ))

(defun sawmill-eval (sexp &optional target-buffer)
  "Pass SEXP to sawmill for evaluation.

SEXP can either be a list or a string.

If passed the result of the evaluation is inserted into TARGET-BUFFER."
  (call-process sawmill-client nil target-buffer nil sawmill-exec-parameter
                (if (stringp sexp) sexp (format "%S" sexp))))

(defun sawmill-string-readable-p (sexp)
  "Can string SEXP be safely `read'?"
  (not (string-match "#<\\w+" sexp)))

(defun sawmill-buffer-readable-p (&optional buffer)
  "Can the content of BUFFER be safely `read'?"
  (sawmill-string-readable-p
   (with-current-buffer (or buffer (current-buffer))
     (buffer-string))))

(defun sawmill-eval-noread (sexp)
  "Eval SEXP and return the result without `read'ing it."
  (with-temp-buffer
    (sawmill-eval sexp t)
    (buffer-substring-no-properties (point-min) (1- (point-max)))))

(defun sawmill-eval-read (sexp)
  "Eval SEXP and return the result of `read'ing the result.

SEXP can either be a list or a string."
  (let ((result (sawmill-eval-noread sexp)))
    (if (sawmill-string-readable-p result)
        (read result)
      result)))

;;;###autoload
(defun sawmill-eval-region (start end &optional target-buffer)
  "Evaluate the region bounded by START and END.

TARGET-BUFFER is the optional target for the return value of the
evaluation."
  (interactive "r")
  (sawmill-eval (buffer-substring-no-properties start end) target-buffer))

;;;###autoload
(defun sawmill-eval-buffer ()
  "Evaluate the whole buffer."
  (interactive)
  (sawmill-eval-region (point-min) (point-max) nil))

;;;###autoload
(defun sawmill-eval-defun (insert-value)
  "Evaluate the top level form at or near `point'.

INSERT-VALUE is a prefix parameter, if it is non-NIL the value of the
expression is inserted into the buffer after the form."
  (interactive "P")
  (save-restriction
    (save-excursion
      (narrow-to-defun)
      (setf (point) (point-max))
      (let ((result (sawmill-eval-last-sexp nil)))
        (if insert-value
            (let ((standard-output (current-buffer)))
              (setf (point) (point-min))
              (end-of-defun)
              (unless (bolp)
                (terpri))
              (princ result)
              (terpri))
          (sawmill-output result))))))

(defun sawmill-eval-expression (sexp &optional insert-value)
  "Evaluate SEXP and display the value in the minibuffer.

If the optional parameter INSERT-VALUE is supplied as a non-NIL value the
value of SEXP will be inserted into the current buffer."
  (interactive
   (list
    (read-from-minibuffer "Eval: " nil sawmill-read-expression-map t 'sawmill-read-expression-history)
    current-prefix-arg))
  (let ((result (sawmill-eval-noread sexp)))
    (if insert-value
        (let ((standard-output (current-buffer)))
          (princ result))
      (sawmill-output result))))

(defun sawmill-output (output)
  "Display output either in mini-buffer or a seperate buffer.

If the output is empty then the string \"No output\" is displayed.

If the output is one line long and the length of the line is less than the
`frame-width' then it is displayed using `message'.

If the output has multiple lines or is longer than `frame-width' then a new
buffer is opened and the text is displayed there. The name of the buffer is
set by the variable `sawmill-result-buffer'"
  (with-temp-buffer
    (let ((temp-buffer (current-buffer)))
      (insert output)
      (let ((lines (count-lines (point-min) (point-max))))
        (cond
          ((zerop lines)                ; Nothing to display.
           (message "No output"))
          ((and (= 1 lines)             ; If there is only one line
                (< (- (point-max)       ; and it isn't too wide for
                      (point-min))      ; the display.
                   (frame-width)))
           (setf (point) (point-min))
           (replace-string "\n" "")     ; Strip any trailing EOLs.
           (when (get-buffer-window sawmill-result-buffer)
             ;; The long result buffer is visible, delete it.
             (delete-window (get-buffer-window sawmill-result-buffer)))
           (message "%s" (buffer-string)))
          (t                            ; Too large for message area, use a buffer.
           (with-output-to-temp-buffer sawmill-result-buffer
             (with-current-buffer sawmill-result-buffer
               (if (sawmill-string-readable-p output)
                   (pp (read output) (current-buffer))
                 (setf (buffer-string) (format "%s" (with-current-buffer temp-buffer
                                                      (buffer-string)))))
               (shrink-window-if-larger-than-buffer (display-buffer (current-buffer)))))))))))

(defun sawmill-eval-last-sexp (to-buffer)
  "Version of `eval-last-sexp' that interacts with sawmill."
  (interactive "P")
  (let ((home-buffer (current-buffer)))
    (with-temp-buffer
      (let ((temp-buffer (current-buffer)))
        (with-current-buffer home-buffer
          (sawmill-eval-region (save-excursion
                                 (backward-sexp)
                                 (point))
                               (point)
                               temp-buffer)
          (funcall (if to-buffer
                       #'insert
                     #'sawmill-output)
                   (with-current-buffer temp-buffer (buffer-string))))))))

(defun sawmill-eval-print-last-sexp ()
  (interactive)
  (insert "\n")
  (sawmill-eval-last-sexp t))

(defmacro sawmill-code (&rest body)
  "Pass BODY to sawmill for evaluation."
  `(sawmill-eval-read (cons 'progn (quote ,body))))

(defun sawmill-load-symbols (&optional force)
  "Loads the names of the sawmill functions and variables."
  (unless (and (not (or force (not sawmill-buffer-symbol-lists)))
               sawmill-function-list sawmill-variable-list)
    (setq sawmill-function-list nil
          sawmill-variable-list nil)
    (flet ((sawmill-fun-p (sym) (second sym))
           (sawmill-var-p (sym) (third sym)))
      (loop for sym in (sawmill-eval-read
                        `(mapcar (lambda (sym)
                                   (list
                                    (symbol-name sym)
                                    (or (macrop sym) (,sawmill-function-p sym))
                                    (,sawmill-variable-p sym)))
                          (apropos ".")))
            if (sawmill-fun-p sym) do (push (list (car sym)) sawmill-function-list)
            if (sawmill-var-p sym) do (push (list (car sym)) sawmill-variable-list)))))

(defun sawmill-documentation (symbol &optional is-variable)
  "Get the documentation for SYMBOL."
  (sawmill-eval-read `(documentation (quote ,symbol) ,is-variable)))

(defun sawmill-funcall-at-point ()
  "Try and work out the function being called at or near `point'."
  (let ((list (thing-at-point 'list)))
    (when list
      (let ((fun (symbol-name (car (read list)))))
        (when (assoc fun sawmill-function-list)
          fun)))))

(defun sawmill-variable-at-point ()
  "Try and work out the variable being called at or near `point'."
  (let ((sym (thing-at-point 'symbol)))
    (when sym
      (let ((var (symbol-name (read sym))))
        (when (assoc var sawmill-variable-list)
          var)))))

(defun sawmill-describe-ask (default description lookups)
  "Ask the user for a symbol.

The symbol will be described as DESCRIPTION with a completing read using
LOOKUPS for the completion. DEFAULT should be a function that returns a
default value for the read."
  (sawmill-load-symbols)
  (intern (completing-read (format "Sawmill %s: " description)
                           (symbol-value lookups)
                           nil
                           nil
                           (funcall default))))

(defun sawmill-describe-ask-function ()
  "Ask for a function name."
  (sawmill-describe-ask #'sawmill-funcall-at-point "function" 'sawmill-function-list))

(defun sawmill-describe-ask-variable ()
  "Ask for a variable name."
  (sawmill-describe-ask #'sawmill-variable-at-point "variable" 'sawmill-variable-list))

(defun sawmill-info-function-index (info-file)
  "Return the name of the function index from INFO-FILE.

This function is used to pull information from the entries found in the
variable `sawmill-info-files'."
  (cadr info-file))

(defun sawmill-info-variable-index (info-file)
  "Return the name of the variable index from INFO-FILE.

This function is used to pull information from the entries found in the
variable `sawmill-info-files'."
  (car (cddr info-file)))

(defun sawmill-info-index-function (is-variable)
  "Return the a function for accessing the info file list."
  (if is-variable #'sawmill-info-variable-index #'sawmill-info-function-index))

(defun sawmill-describe-show (symbol &optional is-variable)
  "Show the sawmill description for SYMBOL."
  (with-output-to-temp-buffer sawmill-help-buffer
    (princ (format "`%s' is a %s" symbol
                   (sawmill-eval-read `(,sawmill-describe-symbol (quote ,symbol)))))
    (when is-variable
      (princ "\n\nValue:\n\n")
      (pp (sawmill-eval-read symbol)))
    (princ "\n\nDocumentation:\n\n")
    (let ((doc (or (sawmill-documentation symbol is-variable)
                   (sawmill-search-and-grab-info (sawmill-info-index-function is-variable) symbol))))
      (if doc
          (princ doc)
        (princ (format "%s is undocumented" symbol))))
    (let ((plist (sawmill-eval-read `(symbol-plist (quote ,symbol)))))
      (when (and plist (listp plist))
        (princ "\n\nProperty list for symbol:\n")
        (loop for prop on plist by #'cddr
              do (princ (format "\n%s: %S" (car prop) (cadr prop))))))))

;;;###autoload
(defun sawmill-describe-function (function)
  "Display the doc-string for FUNCTION."
  (interactive (list (sawmill-describe-ask-function)))
  (sawmill-describe-show function))

;;;###autoload
(defun sawmill-describe-variable (variable)
  "Display the doc-string for VARIABLE."
  (interactive (list (sawmill-describe-ask-variable)))
  (sawmill-describe-show variable t))

(defun sawmill-find-info-entry (info-file node symbol)
  "Try to find SYMBOL in NODE of INFO-FILE.

If the symbol isn't found the Info buffer is killed and the function returns
nil, otherwise the Info buffer is left as the `current-buffer'."
  (condition-case nil
      (progn
        (require 'info)
        (Info-find-node info-file node)
        (Info-menu (format "%s" symbol))
        t)
    (error
     (kill-buffer (current-buffer))
     nil)))

(defun sawmill-jump-to-info-documentaiton (symbol)
  "Jump to the documentation for SYMBOL in an info buffer.

Returns NIL if the documentation could not be found. Note that the
`current-buffer' must be the info buffer you are searching."
  (prog1
      (search-forward-regexp (format "^ - .*: %s" symbol) nil t)
    (beginning-of-line)))

(defun sawmill-extract-info-entry (symbol)
  "Extract the info documentation for SYMBOL as a string."
  (when (sawmill-jump-to-info-documentaiton symbol)
    ;; For some odd reason, in XEmacs, the `current-buffer' inside
    ;; `with-output-to-string' is the string output buffer, not your
    ;; `current-buffer' before the call to `with-output-to-string'. Bizarre!
    ;; GNU emacs does the right thing.
    ;;
    ;; Anyway, to get round this odd behaviour you'll see lots of pointless
    ;; calls to `with-current-buffer' <sigh>.
    (let ((info-buffer (current-buffer)))
      (with-output-to-string nil
        (princ (with-current-buffer info-buffer
                 (buffer-substring-no-properties
                  (+ (point) 3)             ; Strip the leading " - ".
                  (save-excursion
                    (end-of-line)
                    (point)))))
        (terpri)
        (terpri)
        (with-current-buffer info-buffer
          (forward-line))
        (loop while (with-current-buffer info-buffer
                      (or (looking-at "^     ")
                          (looking-at "^ +$")))
              do (let ((eol (with-current-buffer info-buffer
                              (save-excursion
                                (end-of-line)
                                (point)))))
                   (princ (with-current-buffer info-buffer
                            (buffer-substring-no-properties
                             (min (+ (point) 5) eol) ; Strip the leading white space.
                             eol))))
              (terpri)
              (with-current-buffer info-buffer
                (forward-line)))))))

(defun sawmill-search-and-grab-info (index-function symbol)
  "Look for SYMBOL in all the sawmill info files, return the docs.

INDEX-FUNCTION is used to decide which index name will be searched. The
function is used to access the lists in `sawmill-info-files'."
  (save-excursion
    (loop for info-file in sawmill-info-files
          if (sawmill-find-info-entry (car info-file) (funcall index-function info-file) symbol)
          return (prog1 (sawmill-extract-info-entry symbol) (kill-buffer (current-buffer)))
          finally return nil)))

(defun sawmill-search-info-files (index-function symbol)
  "Look for SYMBOL in all the sawmill info files.

INDEX-FUNCTION is used to decide which index name will be searched. The
function is used to access the lists in `sawmill-info-files'."
  (loop for info-file in sawmill-info-files
        if (sawmill-find-info-entry (car info-file) (funcall index-function info-file) symbol) return t
        finally (error "No info documentation found for %s" symbol)))

(defun sawmill-search-info-files-for-function (function)
  "Search for info documentation for FUNCTION."
  (sawmill-search-info-files #'sawmill-info-function-index function))

(defun sawmill-search-info-files-for-variable (variable)
  "Search for info documentation for VARIABLE."
  (sawmill-search-info-files #'sawmill-info-variable-index variable))

;;;###autoload
(defun sawmill-info-function (function)
  "Display the Info documentation for FUNCTION."
  (interactive (list (sawmill-describe-ask-function)))
  (sawmill-search-info-files-for-function function)
  (sawmill-jump-to-info-documentaiton function))

;;;###autoload
(defun sawmill-info-variable (variable)
  "Display the Info documentation for VARIABLE."
  (interactive (list (sawmill-describe-ask-variable)))
  (sawmill-search-info-files-for-variable variable)
  (sawmill-jump-to-info-documentaiton variable))

;; `sawmill-apropos' support functions/macros. I would have used `flet'
;; within sawmill-apropos for this but GNU Emacs kept barfing over it while
;; moaning about too many bound variables. Oh for a CL based emacs.....

(defmacro sawmill-apropos-symbol (sym)
  "`sawmill-apropos' support macro."
  `(nth 0 ,sym))

(defmacro sawmill-apropos-symbol-name (sym)
  "`sawmill-apropos' support macro."
  `(symbol-name (sawmill-apropos-symbol ,sym)))

(defmacro sawmill-apropos-description (sym)
  "`sawmill-apropos' support macro."
  `(nth 1 ,sym))

(defmacro sawmill-apropos-variable-p (sym)
  "`sawmill-apropos' support macro."
  `(nth 2 ,sym))

(defmacro sawmill-apropos-doc-string (sym)
  "`sawmill-apropos' support macro."
  `(nth 3 ,sym))

(defun sawmill-doc-string-first-line (doc-string)
  "Given doc string DOC-STRING return the first line.

If the doc-string is NIL (no documentation) then \"Undocumented\" is
returned."
  (if doc-string
      (with-temp-buffer
        (insert doc-string)
        (setf (point) (point-min))
        (end-of-line)
        (buffer-substring-no-properties (point-min) (point)))
    "Undocumented"))

(defun sawmill-remove-info-one-liner-intro (doc-string)
  "Remove the leading symbol type text from an info derived doc-string."
  (when doc-string
    (with-temp-buffer
      (insert doc-string)
      (setf (point) (point-min))
      (if (search-forward-regexp ": +" nil t)
          (buffer-substring-no-properties (point) (point-max))
        doc-string))))

(defun sawmill-apropos-insert-link (sym)
  "Insert a documentation link for SYM into the apropos buffer."
  (let ((start (point)))
    (insert (sawmill-apropos-symbol-name sym))
    (put-text-property start (point) 'face 'bold))
  (insert "\n  ")
  (let ((start (point)))
    (insert (sawmill-apropos-description sym))
    (insert ":")
    (put-text-property start (point) 'mouse-face 'highlight)
    (let ((local-map (make-sparse-keymap))
          (desc      `(lambda ()
                       (interactive)
                       (,(if (sawmill-apropos-variable-p sym)
                             #'sawmill-describe-variable #'sawmill-describe-function)
                        (quote ,(sawmill-apropos-symbol sym))))))
      (define-key local-map [mouse-2] desc)
      (define-key local-map [return] desc)
      (put-text-property (- start 2) (point) 'local-map local-map)))
  (insert " ")
  (insert (sawmill-doc-string-first-line (or (sawmill-apropos-doc-string sym)
                                             (and sawmill-apropos-searches-info-files
                                                  (sawmill-remove-info-one-liner-intro
                                                   (sawmill-search-and-grab-info
                                                    (sawmill-info-index-function 
                                                     (sawmill-apropos-variable-p sym))
                                                    (sawmill-apropos-symbol sym)))))))
  (insert "\n"))

;;;###autoload
(defun sawmill-apropos (regexp)
  "Show all bound sawmill symbols whose names match REGEXP."
  (interactive "sSawmill Apropos (regexp): ")
  (let ((hits (sort (sawmill-eval-read
                     `(mapcar
                       (lambda (s)
                         (list s
                               (,sawmill-describe-symbol s)
                               (,sawmill-variable-p s)
                               (documentation s (,sawmill-variable-p s))))
                       (apropos ,regexp)))
                    (lambda (symX symY)
                      (string< (sawmill-apropos-symbol-name symX)
                               (sawmill-apropos-symbol-name symY))))))
    (if (not (zerop (length hits)))
        (with-output-to-temp-buffer sawmill-apropos-buffer
          (with-current-buffer sawmill-apropos-buffer
            (setf (buffer-string) "")
            (loop for sym in hits do (sawmill-apropos-insert-link sym))))
      (message "No apropos matches for `%s'" regexp))))

;;;###autoload
(defun sawmill-complete-symbol ()
  "Attempt to complete the symbol at `point'."
  (interactive)
  (let ((sym (thing-at-point 'symbol)))
    (when sym
      (let* ((sym (symbol-name (read sym)))
             (completion (sawmill-eval-read
                          `(complete-string ,sym (mapcar symbol-name (apropos "."))))))
        (if completion
            (if (equal completion sym)
                (let ((sym-list (sawmill-eval-read `(mapcar symbol-name (apropos ,(format "^%s" sym))))))
                  (when (> (length sym-list) 1)
                    (with-output-to-temp-buffer "*Completions*"
                      (display-completion-list
                       (sawmill-eval-read `(mapcar symbol-name (apropos ,(format "^%s" sym))))))))
              (let ((bounds (bounds-of-thing-at-point 'symbol)))
                (delete-region (car bounds) (cdr bounds))
                (insert completion)))
          (error "No completion for `%s'" sym))))))

;;;###autoload
(defun sawmill-info ()
  "View the sawmill info file."
  (interactive)
  (info "sawmill"))

;;;###autoload
(defun sawmill-rep-info ()
  "View the librep info file."
  (interactive)
  (info "librep"))

;;;###autoload
(defun sawmill-console ()
  "Run the sawmill client as an inferior lisp."
  (interactive)
  (run-lisp (format "%s %s" sawmill-client sawmill-interactive-parameter)))

(defun sawmill-interaction-mode ()
  "Extend `sawmill-mode' for use with `sawmill-interaction'."
  (sawmill-mode)
  (setq major-mode 'sawmill-interaction-mode
        mode-name  "sawmill interaction")
  (use-local-map sawmill-interaction-mode-map))

;;;###autoload
(defun sawmill-interaction ()
  "Create a sawmill interaction buffer."
  (interactive)
  (let ((new-buffer (not (get-buffer sawmill-scratch-buffer))))
    (switch-to-buffer (get-buffer-create sawmill-scratch-buffer))
    (when new-buffer
      (insert ";; This buffer is for interacting with the sawmill window manager.\n\n")))
  (sawmill-interaction-mode))

;; Define the sawmill-mode keymap.
(define-key sawmill-mode-map [(control x) (control e)]             #'sawmill-eval-last-sexp)
(define-key sawmill-mode-map [(meta control x)]                    #'sawmill-eval-defun)
(define-key sawmill-mode-map [(meta :)]                            #'sawmill-eval-expression)
(define-key sawmill-mode-map [(control c) (control h) ?a]          #'sawmill-apropos)
(define-key sawmill-mode-map [(control c) (control h) ?f]          #'sawmill-describe-function)
(define-key sawmill-mode-map [(control c) (control h) (control f)] #'sawmill-info-function)
(define-key sawmill-mode-map [(control c) (control h) ?v]          #'sawmill-describe-variable)
(define-key sawmill-mode-map [(control c) (control h) (control v)] #'sawmill-info-variable)
(define-key sawmill-mode-map [(meta tab)]                          #'sawmill-complete-symbol)
(define-key sawmill-mode-map [(control c) (control h) ?i]          #'sawmill-info)

;; Define the minibuffer keymap.
(unless sawmill-read-expression-map
  (setq sawmill-read-expression-map (make-sparse-keymap))
  (set-keymap-parent sawmill-read-expression-map minibuffer-local-map)
  (define-key sawmill-read-expression-map [(meta tab)] #'sawmill-complete-symbol))

;; Define the sawmill-interaction keymap.
(unless sawmill-interaction-mode-map
  (setq sawmill-interaction-mode-map (make-sparse-keymap))
  (set-keymap-parent sawmill-interaction-mode-map sawmill-mode-map)
  (define-key sawmill-interaction-mode-map [(control j)] #'sawmill-eval-print-last-sexp))

;;; Menus

;; GNU Emacs/XEmacs difference crap.
(defun sawmill-region-active-p ()
  "Is there an active region?"
  (if (boundp 'running-xemacs)
      (funcall (symbol-function 'region-exists-p))
    (symbol-value 'mark-active)))
  
(easy-menu-define sawmill-mode-menu sawmill-mode-map "sawmill commands"
  '("Sawmill"
    ["Indent Line"                     lisp-indent-line          t]
    ["Indent Region"                   indent-region             (sawmill-region-active-p)]
    ["Comment Out Region"              comment-region            (sawmill-region-active-p)]
    "----"
    ["Evaluate Last S-expression"      sawmill-eval-last-sexp    t]
    ["Evaluate Top Level Form"         sawmill-eval-defun        t]
    ["Evaluate Region"                 sawmill-eval-region       (sawmill-region-active-p)]
    ["Evaluate Buffer"                 sawmill-eval-buffer       t]
    ["Evaluate Expression"             sawmill-eval-expression   t]
    "----"
    ["Describe Sawmill Variable"       sawmill-describe-variable t]
    ["Describe Sawmill Function"       sawmill-describe-function t]
    ["Info on Variable"                sawmill-info-variable     t]
    ["Info on Function"                sawmill-info-function     t]
    ["Apropos"                         sawmill-apropos           t]
    "----"
    ["Open Sawmill Interaction Buffer" sawmill-interaction       t]
    ["Open Sawmill Console"            sawmill-console           t]
    "----"
    ["Read Sawmill Documentation"      sawmill-info              t]
    ["Read librep Documentation"       sawmill-rep-info          t]))

(provide 'sawmill)

;;; sawmill.el ends here
