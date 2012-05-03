;*=====================================================================*/
;*    serrano/emacs/flyspell/flyspell1.4h.el                           */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Fri Jul 17 13:59:52 1998                          */
;*    Last change :  Tue Dec  8 07:38:51 1998 (serrano)                */
;*    -------------------------------------------------------------    */
;*    This comment must disapear for official version. It is here to   */
;*    take benefit of my automatic time stamping.                      */
;*    -------------------------------------------------------------    */
;*    version 1.4h (unofficial)                                        */
;*    new version may be found at: http://kaolin.unice.fr/~serrano     */
;*    -------------------------------------------------------------    */
;*    Release 1.4h:                                                    */
;*       - Fix some ###autoload cookies.                               */
;*       - YATCI: yet another TeX command improvement :-(              */
;*         (many thanks to Didier Remy who actually implements it)     */
;*       - Flyspell is now able not to check words inside TeX-math     */
;*         environement. For that you have to set the custom           */
;*         flyspell-check-tex-math-command to nil and to download the  */
;*         texmathp package that you may find at:                      */
;*            http://strw.leidenuniv.nl/~dominik/Tools                 */
;*       - Fix cursor position movement when using mouse-2 to fix a    */
;*         word. The cursor position is not correctly adjusted         */
;*         according to buffer widening/shrinking.                     */
;*       - Fix a bug FLYSPELL-AUTO-CORRECT-WORD that could be confused */
;*         because of some none buffer local variables.                */
;*       - FLYSPELL-AUTO-CORRECT-WORD now display in the mini buffer   */
;*         a replacement list.                                         */
;*    Release 1.4g:                                                    */
;*       - fix an annoying feature. When the Emacs cursor is above an  */
;*         incoorect word and that mouse-2 is used to fix that word,   */
;*         the cursor is moved to the beginning of the fixed word. The */
;*         cursor shouldn't move in that situation.                    */
;*    Release 1.4f:                                                    */
;*       - Fix a bug in the ADD-MINOR-MODE expression, a quote was     */
;*         missing (thanks to Greg  Klanderman).                       */
;*       - Addition of the TeX mode predicate (thanks to               */
;*         Bruce Ravel).                                               */
;*       - Addition of an ###autoload before flyspell-mode-map.        */
;*    Release 1.4e:                                                    */
;*       - Bug fix in auto-correct. The bug used to occure when no     */
;*         more replacement were available and when the user kept      */
;*         asking for replacement.                                     */
;*    Release 1.4d:                                                    */
;*       - Bug fix in flyspell-check-changed-word-p.                   */
;*         Add Norsk dictionary in the list of dictionaries that       */
;*         consider dash as delimiter.                                 */
;*       - Adding `To' not to be checked in mail-mode-flyspell-verify. */
;*       - The binding for auto-correction is now C-, because other    */
;*         modes were already making use of ESC-TAB.                   */
;*       - When sorting corrections, the mis-spelled word is presented */
;*         last.                                                       */
;*    Release 1.4c:                                                    */
;*       - Much better management of TeX commands.                     */
;*       - Addition of the pre-pre remembering and forgetting. This    */
;*         helps flyspell to check much few words (twice least).       */
;*         Thus flyspell1.4c is much more faster than flyspell1.4b.    */
;*       - Addition of the                                             */
;*         flyspell-dictionaries-that-consider-dash-as-word-delimiter  */
;*         defcustom, as suggested by Roland Rosenfeld.                */
;*       - flyspell-mode-line-string added by SL Baur                  */
;*         <steve@xemacs.org>.                                         */
;*    Release 1.4b:                                                    */
;*       - Addition of global-flyspell-mode for automatically running  */
;*         Flyspell in many buffers.                                   */
;*       - Flyspell now uses after-change-functions, to correctly      */
;*         checks all word concern by a command (such as the           */
;*         TRANSPOSE-CHARS command).                                   */
;*    Release 1.4a:                                                    */
;*       - Release 1.4 uses only one ispell process, shared by all     */
;*         buffers running flyspell. The variable                      */
;*         flyspell-multi-language-p has been turn useless since that  */
;*         improvement. For the same reason, kill-buffer-hook is       */
;*         became useless too.                                         */
;*    Release 1.3c:                                                    */
;*       - Font-lock is not needed anymore thus the top level          */
;*         expression (require 'font-lock) has been removed (thanks to */
;*         Simon Marshall).                                            */
;*       - Addition of the `adjacent' word for the                     */
;*         `flyspell-mark-duplications-flag' user variable.            */
;*       - Report Richard Stallman improvements (deffaces + comments)  */
;*       - Old emacs version (older than emacs20, xemacs20) are not    */
;*         supported anymore.                                          */
;*    Release 1.3b:                                                    */
;*       - When a word is splitted because of the insertion of a space */
;*         or a newline, now flyspell checks the right _and_ left      */
;*         words.                                                      */
;*       - Fix a bug on % printing in flyspell-region                  */
;*       - Mark the ispell process as process-kill-without-query for   */
;*         Xemacs                                                      */
;*       - Xemacs backward-or-forward-delete-char is now a delayed     */
;*         command                                                     */
;*    Release 1.3:                                                     */
;*       - Fix some small remaining bugs.                              */
;*    Release 1.2h:                                                    */
;*       - Fix a bug on mouse-2 (yank-at-click) for gnu-emacs.         */
;*    Release 1.2g:                                                    */
;*       - Support for flyspell-generic-check-word-p (has suggested    */
;*         by Eric M.  Ludlam).                                        */
;*       - Compliance to emacs-lisp comments.                          */
;*    Release 1.2f:                                                    */
;*       - Improved TeX handling.                                      */
;*       - Improved word fetch implementation.                         */
;*       - flyspell-sort-corrections was not used inside               */
;*         flyspell-auto-correct-word.  The consequence was that auto  */
;*         corrections where not sorted even if the variable was set   */
;*         to non-nil.                                                 */
;*       - Support for flyspell-multi-language-p variable.  Setting    */
;*         this variable to nil will prevent flyspell to spawn a new   */
;*         Ispell process per buffer.                                  */
;*    Release 1.2e:                                                    */
;*       - Fix two popup bugs on Xemacs.  If no replacement words are  */
;*         proposed only the save option is available. Corrected words */
;*         were not inserted at the correct position in the buffer.    */
;*       - Addition of flyspell-region and flyspell-buffer.            */
;*    Release 1.2d:                                                    */
;*       - Make-face-... expressions are now enclosed in               */
;*         condition-case expressions.                                 */
;*       - Fix bugs when flyspell-auto-correct-binding is set to nil   */
;*         (thanks to Eli Tziperman).                                  */
;*    Release 1.2c:                                                    */
;*       - Fix the overlay keymap problem for Emacs (it was correctly  */
;*         working with Xemacs).                                       */
;*       - Thanks to Didier Remy, flyspell now uses a cache in order   */
;*         to improve efficiency and make uses of a pre-command-hook   */
;*         in order to check a word when living it.                    */
;*       - Remaned flyspell-ignore-command into                        */
;*         flyspell-delay-command.                                     */
;*       - Add the flyspell-issue-welcome (as suggested by Joshua      */
;*         Guttman).                                                   */
;*       - Ispell process are now killed when the buffer they are      */
;*         running in is deleted (thanks to Jeff Miller and Roland     */
;*         Rosenfled).                                                 */
;*       - When used on a B&W terminal flyspell used boldness instead  */
;*         of color for incorrect words.                               */
;*    Release 1.2:                                                     */
;*       - Breaks (space or newline) inside incorrect words are now    */
;*         better handled.                                             */
;*       - Flyspell sorts the proposed replacement words (thanks to    */
;*         Carsten Dominik).  See new variable                         */
;*         `flyspell-sort-corrections'.                                */
;*       - The mouse binding to correct mispelled word is now mouse-2  */
;*         on an highlighted region.  This enhancement (as well as a   */
;*         lot of code cleaning) has been acheived by Carsten Dominik. */
;*       - flyspell-mode arg is now optional.                          */
;*       - flyspell bindings are better displayed.                     */
;*       - flyspell nows is able to handle concurent and different     */
;*         dictionaries (that each buffer running flyspell uses its    */
;*         own (buffer local) Ispell process).                         */
;*       - default value for flyspell-highlight-property has been      */
;*         turned to t.                                                */
;*       - flyspell popup menus now support session and buffer         */
;*         dictionaries.                                               */
;*       - corrected words are now correctly unhighlighted (no         */
;*         highlighted characters left).                               */
;*       Note: I think emacs-19.34 has a bug on the overlay event      */
;*         handling.  When an overlay (or a text property) has uses a  */
;*         local-map, if this map does not include a key binding,      */
;*         instead of looking at the enclosing local-map emacs-19.34   */
;*         uses the global-map.  I have not tested this with emacs-20. */
;*         I have checked with Xemacs that does not contain this error.*/
;*    Release 1.1:                                                     */
;*       - Add an automatic replacement for incorrect word.            */
;*    Release 1.0:                                                     */
;*       - Add popup menu for fast correction.                         */
;*    Release 0.9:                                                     */
;*       - Add an Ispell bug workaround.  Now, in french mode, word    */
;*         starting by the '-' character does not, any longer, make    */
;*         Ispell to fall in infinite loops.                           */
;*    Release 0.8:                                                     */
;*       - Better Xemacs support                                       */
;*    Release 0.7:                                                     */
;*       - Rather than hard-coding the ignored commend I now uses a    */
;*         property field to check if a command is ignored.  The       */
;*         advantage is that user may now add its own ignored          */
;*         commands.                                                   */
;*    Release 0.6:                                                     */
;*       - Fix flyspell mode name (in modeline bar) bug.               */
;*       - Fix the bug on flyspell quitting.  Overlays are now really  */
;*         removed.                                                    */
;*    Release 0.5:                                                     */
;*       - Persistent hilightings.                                     */
;*       - Refresh of the modeline on flyspell ending                  */
;*       - Do not hilight text with properties (e.g. font lock text)   */
;*=====================================================================*/
;;; flyspell.el --- On-the-fly spell checker

;; Copyright (C) 1998 Free Software Foundation, Inc.

;; Author: Manuel Serrano <Manuel.Serrano@unice.fr>
;; Keywords: convenience

;;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; commentary:
;;
;; Flyspell is a minor Emacs mode performing on-the-fly spelling
;; checking.
;;
;; To install flyspell, add this to your ~/.emacs file:
;;
;;    (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checking" t)
;;    (autoload 'global-flyspell-mode "flyspell" "On-the-fly spelling" t)
;;                                                                  
;; To enable Flyspell minor mode, type Meta-x flyspell-mode.
;; This applies only to the current buffer.
;;                                                                  
;; Or if you want to turn Flyspell mode on in many buffers, add this to
;; you ~/.emacs file:
;;
;;    (global-flyspell-mode t)
;;                                                                  
;; Note: consider setting the variable ispell-parser to `tex' to
;; avoid TeX command checking; use `(setq ispell-parser 'tex)'.
;;                                                                  
;; Some user variables control the behavior of flyspell.  They are
;; those defined under the `User variables' comment.

;;; Code:
(require 'ispell)

;*---------------------------------------------------------------------*/
;*    Group ...                                                        */
;*---------------------------------------------------------------------*/
(defgroup flyspell nil
  "Spellchecking on the fly."
  :tag "FlySpell"
  :prefix "flyspell-"
  :group 'processes)

;*---------------------------------------------------------------------*/
;*    User configuration ...                                           */
;*---------------------------------------------------------------------*/
(defcustom flyspell-highlight-flag t
  "*How Flyspell should indicate misspelled words.
Non-nil means use highlight, nil means use minibuffer messages."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-mark-duplications-flag t
  "*Non-nil means Flyspell reports a repeated word as an error."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-sort-corrections nil
  "*Non-nil means, sort the corrections alphabetically before popping them."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-duplicate-distance -1
  "*The maximum distance for finding duplicates of unrecognized words.
This applies to the feature that when a word is not found in the dictionary,
if the same spelling occurs elsewhere in the buffer,
Flyspell uses a different face (`flyspell-duplicate-face') to highlight it.
This variable specifies how far to search to find such a duplicate.
-1 means no limit (search the whole buffer).
0 means do not search for duplicate unrecognized spellings."
  :group 'flyspell
  :type 'number)

(defcustom flyspell-delay 3
  "*The number of seconds to wait before checking, after a \"delayed\" command."
  :group 'flyspell
  :type 'number)

(defcustom flyspell-persistent-highlight t
  "*Non-nil means misspelled words remain highlighted until corrected.
If this variable is nil, only the most recently detected misspelled word
is highlighted."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-highlight-properties t
  "*Non-nil means highlight incorrect words even if a property exists for this word."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-default-delayed-commands
  '(self-insert-command
    delete-backward-char
    backward-or-forward-delete-char
    delete-char)
  "The standard list of delayed commands for Flyspell.
See `flyspell-delayed-commands'."
  :group 'flyspell
  :type '(repeat (symbol)))

(defcustom flyspell-delayed-commands nil
  "List of commands that are \"delayed\" for Flyspell mode.
After these commands, Flyspell checking is delayed for a short time,
whose length is specified by `flyspell-delay'."
  :group 'flyspell
  :type '(repeat (symbol)))

(defcustom flyspell-issue-welcome-flag t
  "*Non-nil means that Flyspell should display a welcome message when started."
  :group 'flyspell
  :type 'boolean)

(defcustom flyspell-incorrect-hook nil
  "*List of functions to be called when incorrect words are encountered.
Each function is given two arguments: the beginning and the end
of the incorrect region."
  :group 'flyspell)

(defcustom flyspell-default-dictionary "american"
  "A string that is the name of the default dictionary.
This is passed to the ispell-change-dictionary when flyspell is started.
If the variables ispell-local-dictionary or ispell-dictionary are non nil
when flyspell is started, the value of that variables is used instead
of flyspell-default-dictionary to select the default dictionary."
  :group 'flyspell
  :type 'string)

(defcustom flyspell-tex-command-regexp
  "\\(\\(begin\\|end\\) *{\\|\\(cite\\|label\\|ref\\) *{[^{}]*\\)"
  "A string that is the regular expression that matches TeX commands."
  :group 'flyspell
  :type 'string)

(defcustom flyspell-check-tex-math-command nil
  "*Non nils means check even inside TeX math environement. TeX math
environement are discovered byt eh TEXMATHP that is implemented inside
the eponyme emacs package. That package may be found at:
http://strw.leidenuniv.nl/~dominik/Tools"
  :group 'flyspell
  :type 'boolean)


(defcustom flyspell-global-modes t
  "*Modes for which Flyspell mode is automagically turned on.
Global Flyspell mode is controlled by the `global-flyspell-mode' command.
If nil, means no modes have Flyspell mode automatically turned on.
If t, all modes have it automatically turned on.
If a list, it should be a list of `major-mode' symbol names for which Flyspell
mode should be automatically turned on.  The sense of the list is negated if it
begins with `not'.  For example:
 (tex-mode mail-mode)
means that Flyspell mode is turned on for buffers in tex and mail-mode
modes only."
  :type '(choice (const :tag "none" nil)
		 (const :tag "all" t)
		 (set :menu-tag "mode specific" :tag "modes"
		      :value (not)
		      (const :tag "Except" not)
		      (repeat :inline t (symbol :tag "mode"))))
  :group 'flyspell)

(defcustom flyspell-dictionaries-that-consider-dash-as-word-delimiter
  '("francais" "deutsch8" "norsk")
  "List of dictionary names that consider `-' as word delimiter."
  :group 'flyspell
  :type '(repeat (string)))

;;;###autoload
(defcustom flyspell-mode-line-string " Fly"
  "*String displayed on the modeline when flyspell is active.
Set this to nil if you don't want a modeline indicator."
  :group 'flyspell
  :type 'string)

;*---------------------------------------------------------------------*/
;*    Mode specific options                                            */
;*    -------------------------------------------------------------    */
;*    Mode specific options enable users to disable flyspell on        */
;*    certain word depending of the emacs mode. For instance, when     */
;*    using flyspell with mail-mode add the following expression       */
;*    in your .emacs file:                                             */
;*       (add-hook 'mail-mode                                          */
;*    	     '(lambda () (setq flyspell-generic-check-word-p           */
;*    			       'mail-mode-flyspell-verify)))           */
;*---------------------------------------------------------------------*/
(defvar flyspell-generic-check-word-p nil
  "Function providing per-mode customization over which words are flyspelled.
Returns t to continue checking, nil otherwise.
Flyspell mode sets this variable to whatever is the `flyspell-mode-predicate'
property of the major mode name.")
(make-variable-buffer-local 'flyspell-generic-check-word-p)

;*--- mail mode -------------------------------------------------------*/
(put 'mail-mode 'flyspell-mode-predicate 'mail-mode-flyspell-verify)
(put 'message-mode 'flyspell-mode-predicate 'mail-mode-flyspell-verify)
(defun mail-mode-flyspell-verify ()
  "This function is used for `flyspell-generic-check-word-p' in Mail mode."
  (save-excursion
    (not (or (re-search-forward mail-header-separator nil t)
	     (re-search-backward message-signature-separator nil t)
	     (progn
	       (beginning-of-line)
	       (looking-at "[>}|]\\To:"))))))

;*--- texinfo mode ----------------------------------------------------*/
(put 'texinfo-mode 'flyspell-mode-predicate 'texinfo-mode-flyspell-verify)
(defun texinfo-mode-flyspell-verify ()
  "This function is used for `flyspell-generic-check-word-p' in Texinfo mode."
  (save-excursion
    (forward-word -1)
    (not (looking-at "@"))))

;*--- tex mode --------------------------------------------------------*/
(put 'tex-mode 'flyspell-mode-predicate 'tex-mode-flyspell-verify)
(defun tex-mode-flyspell-verify ()
  "This function is used for `flyspell-generic-check-word-p' in LaTeX mode."
  (and
   (not (save-excursion
	  (re-search-backward "^[ \t]*%%%[ \t]+Local" (point-min) t)))
   (not (save-excursion
	  (let ((this (point-marker))
		(e (progn (end-of-line) (point-marker))))
	    (beginning-of-line)
	    (if (re-search-forward "\\\\\\(cite\\|label\\|ref\\){[^}]*}" e t)
		(and (>= this (match-beginning 0))
		     (<= this (match-end 0)) )))))))

;*--- sgml mode -------------------------------------------------------*/
(put 'sgml-mode 'flyspell-mode-predicate 'sgml-mode-flyspell-verify)
(put 'html-mode 'flyspell-mode-predicate 'sgml-mode-flyspell-verify)

(defun sgml-mode-flyspell-verify ()
  "This function is used for `flyspell-generic-check-word-p' in SGML mode."
  (not (save-excursion
	 (let ((this (point-marker))
	       (s (progn (beginning-of-line) (point-marker)))
	       (e (progn (end-of-line) (point-marker))))
	   (or (progn
		 (goto-char this)
		 (and (re-search-forward  "[^<]*>" e t)
		      (= (match-beginning 0) this)))
	       (progn
		 (goto-char this)
		 (and (re-search-backward "<[^>]*" s t)
		      (= (match-end 0) this)))
	       (and (progn
		      (goto-char this)
		      (and (re-search-forward  "[^&]*;" e t)
			   (= (match-beginning 0) this)))
		    (progn
		      (goto-char this)
		      (and (re-search-backward "&[^;]*" s t)
			   (= (match-end 0) this)))))))))

;*---------------------------------------------------------------------*/
;*    Overlay compatibility                                            */
;*---------------------------------------------------------------------*/
(autoload 'make-overlay            "overlay" "Overlay compatibility kit." t)
(autoload 'overlayp                "overlay" "Overlay compatibility kit." t)
(autoload 'overlays-in             "overlay" "Overlay compatibility kit." t)
(autoload 'delete-overlay          "overlay" "Overlay compatibility kit." t)
(autoload 'overlays-at             "overlay" "Overlay compatibility kit." t)
(autoload 'overlay-put             "overlay" "Overlay compatibility kit." t)
(autoload 'overlay-get             "overlay" "Overlay compatibility kit." t)
(autoload 'previous-overlay-change "overlay" "Overlay compatibility kit." t)

;*---------------------------------------------------------------------*/
;*    Which emacs are we currently running                             */
;*---------------------------------------------------------------------*/
(defvar flyspell-emacs
  (cond
   ((string-match "XEmacs" emacs-version)
    'xemacs)
   (t
    'emacs))
  "The type of Emacs we are currently running.")

;*---------------------------------------------------------------------*/
;*    The minor mode declaration.                                      */
;*---------------------------------------------------------------------*/
(defvar flyspell-mode nil)
(make-variable-buffer-local 'flyspell-mode)

;;;###autoload
(defvar flyspell-mode-map (make-sparse-keymap))
(defvar flyspell-mouse-map (make-sparse-keymap))

;;;###autoload 
(if (fboundp 'add-minor-mode)
    (add-minor-mode 'flyspell-mode
		    flyspell-mode-line-string
		    flyspell-mode-map
		    nil
		    'flyspell-mode)
  (or (assoc 'flyspell-mode minor-mode-alist)
      (setq minor-mode-alist
	    (cons '(flyspell-mode flyspell-mode-line-string)
		  minor-mode-alist)))

  (or (assoc 'flyspell-mode minor-mode-map-alist)
      (setq minor-mode-map-alist
	    (cons (cons 'flyspell-mode flyspell-mode-map)
		  minor-mode-map-alist))))

;; mouse, keyboard bindings and misc definition
(cond
 ((eq flyspell-emacs 'xemacs)
  (define-key flyspell-mode-map [(control \,)] 'flyspell-auto-correct-word)
  (define-key flyspell-mouse-map [(button2)]
    (function flyspell-correct-word/mouse-keymap)))
 (t
  (define-key flyspell-mode-map [?\C-\,] 'flyspell-auto-correct-word)
  (define-key flyspell-mode-map [(mouse-2)]
    (function flyspell-correct-word/local-keymap))))

;; the name of the overlay property that defines the keymap
(defvar flyspell-overlay-keymap-property-name
  (if (string-match "19.*XEmacs" emacs-version)
      'keymap
    'local-map))

;; dash character machinery
(defvar flyspell-consider-dash-as-word-delimiter-flag nil
   "*Non-nil means that the `-' char is considered as a word delimiter.")
(make-variable-buffer-local 'flyspell-consider-dash-as-word-delimiter-flag)
(defvar flyspell-dash-dictionary nil)
(make-variable-buffer-local 'flyspell-dash-dictionary)
(defvar flyspell-dash-local-dictionary nil)
(make-variable-buffer-local 'flyspell-dash-local-dictionary)

;*---------------------------------------------------------------------*/
;*    Highlighting                                                     */
;*---------------------------------------------------------------------*/
(defface flyspell-incorrect-face
  '((((class color)) (:foreground "OrangeRed" :bold t :underline t))
    (t (:bold t)))
  "Face used for marking a misspelled word in Flyspell."
  :group 'flyspell)

(defface flyspell-duplicate-face
  '((((class color)) (:foreground "Gold3" :bold t :underline t))
    (t (:bold t)))
  "Face used for marking a misspelled word that appears twice in the buffer.
See also `flyspell-duplicate-distance'."
  :group 'flyspell)

(defvar flyspell-overlay nil)

;*---------------------------------------------------------------------*/
;*    flyspell-mode ...                                                */
;*---------------------------------------------------------------------*/
;;;###autoload
(defun flyspell-mode (&optional arg)
  "Minor mode performing on-the-fly spelling checking.
Ispell is automatically spawned on background for each entered words.
The default flyspell behavior is to highlight incorrect words.
With no argument, this command toggles Flyspell mode.
With a prefix argument ARG, turn Flyspell minor mode on iff ARG is positive.
  
Alternatively, you can use Global Flyspell mode to automagically turn on 
Flyspell in buffers whose major mode supports it and whose major mode is one
of `flyspell-global-modes'. For example, put in your ~/.emacs:

 (global-flyspell-mode t)

Bindings:
\\[ispell-word]: correct words (using Ispell).
\\[flyspell-auto-correct-word]: automatically correct word.
\\[flyspell-correct-word] (or mouse-2): popup correct words.

Hooks:
flyspell-mode-hook is run after flyspell is entered.

Remark:
`flyspell-mode' uses `ispell-mode'.  Thus all Ispell options are
valid.  For instance, a personal dictionary can be used by
invoking `ispell-change-dictionary'.

Consider using the `ispell-parser' to check your text.  For instance
consider adding:
\(add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))
in your .emacs file.

flyspell-region checks all words inside a region.

flyspell-buffer checks the whole buffer."
  (interactive "P")
  (let ((old-flyspell-mode flyspell-mode))
    ;; Mark the mode as on or off.
    (setq flyspell-mode (not (or (and (null arg) flyspell-mode)
				 (<= (prefix-numeric-value arg) 0))))
    ;; Do the real work.
    (unless (eq flyspell-mode old-flyspell-mode)
      (if flyspell-mode
	  (flyspell-mode-on)
	(flyspell-mode-off))
      ;; Force modeline redisplay.
      (set-buffer-modified-p (buffer-modified-p)))))

;*---------------------------------------------------------------------*/
;*    flyspell-buffers ...                                             */
;*    -------------------------------------------------------------    */
;*    For remembering buffers running flyspell                         */
;*---------------------------------------------------------------------*/
(defvar flyspell-buffers nil)
 
;*---------------------------------------------------------------------*/
;*    global-flyspell-mode ...                                         */
;*    -------------------------------------------------------------    */
;*    I have stolen this implementation from Global Font Lock mode.    */
;*    I use the exact same trick.                                      */
;*---------------------------------------------------------------------*/
;;;###autoload
(defun global-flyspell-mode (&optional arg message)
  "Toggle Global Flyspell mode.
With prefix ARG, turn Global Flyspell mode on if and only if ARG is positive.
Displays a message saying whether the mode is on or off if MESSAGE is non-nil.
Returns the new status of Global Flyspell mode (non-nil means on).

When Global Flyspell mode is enabled, Flyspell mode is automagically
turned on in a buffer if its major mode is one of `flyspell-global-modes'."
  (interactive "P\np")
  (let ((on-p (if arg
		  (> (prefix-numeric-value arg) 0)
		(not global-flyspell-mode))))
    (cond (on-p
	   (add-hook 'find-file-hooks 'turn-on-flyspell-if-enabled)
	   (add-hook 'first-change-hook 'turn-on-flyspell-if-enabled)
	   (mapcar '(lambda (buffer)
		      (with-current-buffer buffer
			(turn-on-flyspell-if-enabled)))
		   (buffer-list)))
	  (t
	   (remove-hook 'find-file-hooks 'turn-on-flyspell-if-enabled)
	   (remove-hook 'first-change-hook 'turn-on-flyspell-if-enabled)
	   (mapcar '(lambda (buffer)
		      (with-current-buffer buffer
			(when flyspell-mode
			  (flyspell-mode))))
		   (buffer-list))))
    (when message
      (message "Global Flyspell mode %s." (if on-p "enabled" "disabled")))
    (setq global-flyspell-mode on-p)))

;*---------------------------------------------------------------------*/
;*    global-flyspell-mode ...                                         */
;*---------------------------------------------------------------------*/
(defcustom global-flyspell-mode nil
  "Toggle Global Flyspell mode.
When Global Flyspell mode is enabled, Flyspell mode is automagically
turned on in a buffer if its major mode is one of `flyspell-global-modes'.
You must modify via \\[customize] for this variable to have an effect."
  :set (lambda (symbol value)
	 (global-flyspell-mode (or value 0)))
  :type 'boolean
  :group 'flyspell
  :require 'flyspell)

;*---------------------------------------------------------------------*/
;*    turn-on-flyspell-if-enabled ...                                  */
;*---------------------------------------------------------------------*/
(defun turn-on-flyspell-if-enabled ()
  ;; Gross hack warning: Delicate readers should avert eyes now.
  ;; Turn on Flyspell mode if it's supported by the major mode and enabled by
  ;; the user.
  (if (flyspell-global-mode-enabled-p (current-buffer))
      (flyspell-mode t)))

;*---------------------------------------------------------------------*/
;*    flyspell-global-mode-enabled-p ...                               */
;*---------------------------------------------------------------------*/
(defun flyspell-global-mode-enabled-p (buffer)
  "Does BUFFER need to activate Flyspell?"
  (and global-flyspell-mode
       (not (flyspell-minibuffer-p buffer))
       (or (eq flyspell-global-modes t)
	   (if (eq (car-safe flyspell-global-modes) 'not)
	       (not (memq major-mode (cdr flyspell-global-modes)))
	     (memq major-mode flyspell-global-modes)))))
	    
;*---------------------------------------------------------------------*/
;*    flyspell-minibuffer-p ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-minibuffer-p (buffer)
  "Is BUFFER a minibuffer?"
  (let ((ws (get-buffer-window-list buffer t)))
    (and (consp ws) (window-minibuffer-p (car ws)))))

;*---------------------------------------------------------------------*/
;*    flyspell-accept-buffer-local-defs ...                            */
;*---------------------------------------------------------------------*/
(defun flyspell-accept-buffer-local-defs ()
  (ispell-accept-buffer-local-defs)
  (if (not (and (eq flyspell-dash-dictionary ispell-dictionary)
		(eq flyspell-dash-local-dictionary ispell-local-dictionary)))
      ;; the dictionary as changed
      (progn
	(setq flyspell-dash-dictionary ispell-dictionary)
	(setq flyspell-dash-local-dictionary ispell-local-dictionary)
	(if (member (or ispell-local-dictionary ispell-dictionary)
		    flyspell-dictionaries-that-consider-dash-as-word-delimiter)
	    (setq flyspell-consider-dash-as-word-delimiter-flag t)
	  (setq flyspell-consider-dash-as-word-delimiter-flag nil)))))

;*---------------------------------------------------------------------*/
;*    flyspell-mode-on ...                                             */
;*---------------------------------------------------------------------*/
(defun flyspell-mode-on ()
  "Turn Flyspell mode on.  Do not use this; use `flyspell-mode' instead."
  (setq ispell-highlight-face 'flyspell-incorrect-face)
  ;; local dictionaries setup
  (ispell-change-dictionary
   (or ispell-local-dictionary flyspell-default-dictionary))
  ;; we have to force ispell to accept the local definition or
  ;; otherwise it could be too late, the local dictionary may
  ;; be forgotten!
  (flyspell-accept-buffer-local-defs)
  ;; we put the `flyspel-delayed' property on some commands
  (flyspell-delay-commands)
  ;; we bound flyspell action to post-command hook
  (make-local-hook 'post-command-hook)
  (add-hook 'post-command-hook (function flyspell-post-command-hook) t t)
  ;; we bound flyspell action to pre-command hook
  (make-local-hook 'pre-command-hook)
  (add-hook 'pre-command-hook (function flyspell-pre-command-hook) t t)
  ;; we bound flyspell action to after-change hook
  (make-local-variable 'after-change-functions)
  (setq after-change-functions
	(cons 'flyspell-after-change-function after-change-functions))
  ;; set flyspell-generic-check-word-p based on the major mode
  (let ((mode-predicate (get major-mode 'flyspell-mode-predicate)))
    (if mode-predicate
	(setq flyspell-generic-check-word-p mode-predicate)))
  ;; the welcome message
  (if flyspell-issue-welcome-flag
      (let ((binding (where-is-internal 'flyspell-auto-correct-word
					nil 'non-ascii)))
	(message
	 (if binding
	     (format "Welcome to flyspell. Use %s or Mouse-2 to correct words."
		     (key-description binding))
	   "Welcome to flyspell. Use Mouse-2 to correct words."))))
  ;; we end with the flyspell hooks
  (run-hooks 'flyspell-mode-hook))

;*---------------------------------------------------------------------*/
;*    flyspell-delay-commands ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-delay-commands ()
  "Install the standard set of Flyspell delayed commands."
  (mapcar 'flyspell-delay-command flyspell-default-delayed-commands)
  (mapcar 'flyspell-delay-command flyspell-delayed-commands))

;*---------------------------------------------------------------------*/
;*    flyspell-delay-command ...                                       */
;*---------------------------------------------------------------------*/
(defun flyspell-delay-command (command)
  "Set COMMAND to be delayed, for Flyspell.
When flyspell `post-command-hook' is invoked because a delayed command
as been used the current word is not immediatly checked.
It will be checked only after `flyspell-delay' seconds."
  (interactive "SDelay Flyspell after Command: ")
  (put command 'flyspell-delayed t))

;*---------------------------------------------------------------------*/
;*    flyspell-ignore-commands ...                                     */
;*---------------------------------------------------------------------*/
(defun flyspell-ignore-commands ()
  "This is an obsolete function, use `flyspell-delay-commands' instead."
  (flyspell-delay-commands))

;*---------------------------------------------------------------------*/
;*    flyspell-ignore-command ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-ignore-command (command)
  "This is an obsolete function, use `flyspell-delay-command' instead.
COMMAND is the name of the command to be delayed."
  (flyspell-delay-command command))

(make-obsolete 'flyspell-ignore-commands 'flyspell-delay-commands)
(make-obsolete 'flyspell-ignore-command 'flyspell-delay-command)

;*---------------------------------------------------------------------*/
;*    flyspell-word-cache ...                                          */
;*---------------------------------------------------------------------*/
(defvar flyspell-word-cache-start  nil)
(defvar flyspell-word-cache-end    nil)
(defvar flyspell-word-cache-word   nil)
(make-variable-buffer-local 'flyspell-word-cache-start)
(make-variable-buffer-local 'flyspell-word-cache-end)
(make-variable-buffer-local 'flyspell-word-cache-word)

;*---------------------------------------------------------------------*/
;*    The flyspell pre-hook, store the current position. In the        */
;*    post command hook, we will check, if the word at this position   */
;*    has to be spell checked.                                         */
;*---------------------------------------------------------------------*/
(defvar flyspell-pre-buffer     nil)
(defvar flyspell-pre-point      nil)
(defvar flyspell-pre-pre-buffer nil)
(defvar flyspell-pre-pre-point  nil)

;*---------------------------------------------------------------------*/
;*    flyspell-pre-command-hook ...                                    */
;*---------------------------------------------------------------------*/
(defun flyspell-pre-command-hook ()
  "Save the current buffer and point for Flyspell's post-command hook."
  (interactive)
  (setq flyspell-pre-buffer (current-buffer))
  (setq flyspell-pre-point  (point)))

;*---------------------------------------------------------------------*/
;*    flyspell-mode-off ...                                            */
;*---------------------------------------------------------------------*/
;;;###autoload
(defun flyspell-mode-off ()
  "Turn Flyspell mode off."
  ;; we remove the hooks
  (remove-hook 'post-command-hook (function flyspell-post-command-hook) t)
  (remove-hook 'pre-command-hook (function flyspell-pre-command-hook) t)
  (setq after-change-functions (delq 'flyspell-after-change-function
				     after-change-functions))
  ;; we remove all the flyspell hilightings
  (flyspell-delete-all-overlays)
  ;; we have to erase pre cache variables
  (setq flyspell-pre-buffer nil)
  (setq flyspell-pre-point  nil)
  ;; we mark the mode as killed
  (setq flyspell-mode nil))

;*---------------------------------------------------------------------*/
;*    flyspell-check-pre-word-p ...                                    */
;*---------------------------------------------------------------------*/
(defun flyspell-check-pre-word-p ()
  "Return non-nil if we should to check the word before point.
More precisely, it applies to the word that was before point
before the current command."
  (cond
   ((or (not (numberp flyspell-pre-point))
	(not (bufferp flyspell-pre-buffer))
	(not (buffer-live-p flyspell-pre-buffer)))
    nil)
   ((and (eq flyspell-pre-pre-point flyspell-pre-point)
	 (eq flyspell-pre-pre-buffer flyspell-pre-buffer))
    nil)
   ((or (and (= flyspell-pre-point (- (point) 1))
	     (eq (char-syntax (char-after flyspell-pre-point)) ?w))
	(= flyspell-pre-point (point))
	(= flyspell-pre-point (+ (point) 1)))
    nil)
   ((not (eq (current-buffer) flyspell-pre-buffer))
    t)
   ((not (and (numberp flyspell-word-cache-start)
	      (numberp flyspell-word-cache-end)))
    t)
   (t
    (or (< flyspell-pre-point flyspell-word-cache-start)
	(> flyspell-pre-point flyspell-word-cache-end)))))

;*---------------------------------------------------------------------*/
;*    The flyspell after-change-hook, store the change position. In    */
;*    the post command hook, we will check, if the word at this        */
;*    position has to be spell checked.                                */
;*---------------------------------------------------------------------*/
(defvar flyspell-changes nil)

;*---------------------------------------------------------------------*/
;*    flyspell-after-change-function ...                               */
;*---------------------------------------------------------------------*/
(defun flyspell-after-change-function (start stop len)
  "Save the current buffer and point for Flyspell's post-command hook."
  (interactive)
  (setq flyspell-changes (cons (cons start stop) flyspell-changes)))

;*---------------------------------------------------------------------*/
;*    flyspell-check-changed-word-p ...                                */
;*---------------------------------------------------------------------*/
(defun flyspell-check-changed-word-p (start stop)
  "Return t when the changed word has to be checked.
The answer depends of several criteria.
Mostly we check word delimiters."
  (cond
   ((not (numberp flyspell-pre-point))
    t)
   ((and (>= flyspell-pre-point start) (<= flyspell-pre-point stop))
    nil)
   ((let ((pos (point)))
      (or (>= pos start) (<= pos stop) (= pos (1+ stop))))
    nil)
   (t
    t)))
  
;*---------------------------------------------------------------------*/
;*    flyspell-check-word-p ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-check-word-p ()
  "Return t when the word at `point' has to be checked.
The answer depends of several criteria.
Mostly we check word delimiters."
  (cond
   ((<= (- (point-max) 1) (point-min))
    ;; the buffer is not filled enough
    nil)
   ((not (and (symbolp this-command) (get this-command 'flyspell-delayed)))
    ;; the current command is not delayed, that
    ;; is that we must check the word now
    t)
   ((and (> (point) (point-min))
	 (save-excursion
	   (backward-char 1)
	   (and (looking-at (flyspell-get-not-casechars))
		(or flyspell-consider-dash-as-word-delimiter-flag
		    (not (looking-at "\\-"))))))
    ;; yes because we have reached or typed a word delimiter.
    t)
   ((not (integerp flyspell-delay))
    ;; yes because the user had set up a no-delay configuration.
    t)
   (t
    (if (fboundp 'about-xemacs)
	(sit-for flyspell-delay nil)
      (sit-for flyspell-delay 0 nil)))))

;*---------------------------------------------------------------------*/
;*    flyspell-post-command-hook ...                                   */
;*    -------------------------------------------------------------    */
;*    It is possible that we check several words:                      */
;*    1- the current word is checked if the predicate                  */
;*       FLYSPELL-CHECK-WORD-P is true                                 */
;*    2- the word that used to be the current word before the          */
;*       THIS-COMMAND is checked if:                                   */
;*        a- the previous word is different from the current word      */
;*        b- the previous word as not just been checked by the         */
;*           previous FLYSPELL-POST-COMMAND-HOOK                       */
;*    3- the words changed by the THIS-COMMAND that are neither the    */
;*       previous word nor the current word                            */
;*---------------------------------------------------------------------*/
(defun flyspell-post-command-hook ()
  "The `post-command-hook' used by flyspell to check a word in-the-fly."
  (interactive)
  (if (flyspell-check-pre-word-p)
      (save-excursion
	(set-buffer flyspell-pre-buffer)
	(save-excursion
	  (goto-char flyspell-pre-point)
	  (flyspell-word))))
  (if (flyspell-check-word-p)
      (progn
	(flyspell-word)
	;; we remember which word we have just checked.
	;; this will be use next time we will check a word
	;; to compare the next current word with the word
	;; that as been registered in the pre-command-hook
	;; that is these variables are used within the predicate
	;; FLYSPELL-CHECK-PRE-WORD-P
	(setq flyspell-pre-pre-buffer (current-buffer))
	(setq flyspell-pre-pre-point  (point)))
    (progn
      (setq flyspell-pre-pre-buffer nil)
      (setq flyspell-pre-pre-point  nil)
      ;; when a word is not checked because of a delayed command
      ;; we do not disable the ispell cache.
      (if (and (symbolp this-command) (get this-command 'flyspell-delayed))
	  (setq flyspell-word-cache-end -1))))
  (while (consp flyspell-changes)
    (let ((start (car (car flyspell-changes)))
	  (stop  (cdr (car flyspell-changes))))
      (if (flyspell-check-changed-word-p start stop)
	  (save-excursion
	    (goto-char start)
	    (flyspell-word)))
      (setq flyspell-changes (cdr flyspell-changes)))))

;*---------------------------------------------------------------------*/
;*    flyspell-word ...                                                */
;*---------------------------------------------------------------------*/
(defun flyspell-word (&optional following)
  "Spell check a word."
  (interactive (list current-prefix-arg))
  (if (interactive-p)
      (setq following ispell-following-word))
  (save-excursion
    ;; use the correct dictionary
    (flyspell-accept-buffer-local-defs)	
    (let ((cursor-location (point))
	  (flyspell-word (flyspell-get-word following))
	  start end poss word)
      (if (or (eq flyspell-word nil)
 	      (and (fboundp flyspell-generic-check-word-p)
 		   (not (funcall flyspell-generic-check-word-p))))
	  t
	(progn
	  ;; destructure return flyspell-word info list.
	  (setq start (car (cdr flyspell-word))
		end (car (cdr (cdr flyspell-word)))
		word (car flyspell-word))
	  ;; before checking in the directory, we check for doublons.
	  (cond
	   ((and (or (not (eq ispell-parser 'tex))
		     (not (eq (char-after start) ?\\)))
		 flyspell-mark-duplications-flag
		 (save-excursion
		   (goto-char start)
		   (word-search-backward word
					 (- start
					    (+ 1 (- end start)))
					 t)))
	    ;; yes, this is a doublon
	    (flyspell-highlight-incorrect-region start end))
	   ((and (eq flyspell-word-cache-start start)
		 (eq flyspell-word-cache-end end)
		 (string-equal flyspell-word-cache-word word))
	    ;; this word had been already checked, we skip
	    nil)
	   ((and (eq ispell-parser 'tex)
		 (flyspell-tex-command-p flyspell-word))
	    ;; this is a correct word (because a tex command)
	    (flyspell-unhighlight-at start)
	    (if (> end start)
		(flyspell-unhighlight-at (- end 1)))
	    t)
	   (t
	    ;; we setup the cache
	    (setq flyspell-word-cache-start start)
	    (setq flyspell-word-cache-end end)
	    (setq flyspell-word-cache-word word)
	    ;; now check spelling of word.
	    (process-send-string ispell-process "%\n")
	    ;; put in verbose mode
	    (process-send-string ispell-process
				 (concat "^" word "\n"))
	    ;; we mark the ispell process so it can be killed
	    ;; when emacs is exited without query
	    (if (fboundp 'process-kill-without-query)
		(process-kill-without-query ispell-process))
	    ;; wait until ispell has processed word
	    (while (progn
		     (accept-process-output ispell-process)
		     (not (string= "" (car ispell-filter)))))
	    ;; (process-send-string ispell-process "!\n")
	    ;; back to terse mode.
	    (setq ispell-filter (cdr ispell-filter))
	    (if (consp ispell-filter)
		(setq poss (ispell-parse-output (car ispell-filter))))
	    (cond ((eq poss t)
		   ;; correct
		   (flyspell-unhighlight-at start)
		   (if (> end start)
		       (flyspell-unhighlight-at (- end 1)))
		   t)
		  ((and (stringp poss) flyspell-highlight-flag)
		   ;; correct
		   (flyspell-unhighlight-at start)
		   (if (> end start)
		       (flyspell-unhighlight-at (- end 1)))
		   t)
		  ((null poss)
		   (flyspell-unhighlight-at start)
		   (if (> end start)
		       (flyspell-unhighlight-at (- end 1))))
		  ((or (and (< flyspell-duplicate-distance 0)
			    (or (save-excursion
				  (goto-char start)
				  (word-search-backward word
							(point-min)
							t))
				(save-excursion
				  (goto-char end)
				  (word-search-forward word
						       (point-max)
						       t))))
		       (and (> flyspell-duplicate-distance 0)
			    (or (save-excursion
				  (goto-char start)
				  (word-search-backward
				   word
				   (- start
				      flyspell-duplicate-distance)
				   t))
				(save-excursion
				  (goto-char end)
				  (word-search-forward
				   word
				   (+ end
				      flyspell-duplicate-distance)
				   t)))))
		   (if flyspell-highlight-flag
		       (flyspell-highlight-duplicate-region start end)
		     (message (format "duplicate `%s'" word))))
		  (t
		   ;; incorrect highlight the location
		   (if flyspell-highlight-flag
		       (flyspell-highlight-incorrect-region start end)
		     (message (format "mispelling `%s'" word)))))
	    ;; return to original location
	    (goto-char cursor-location) 
	    (if ispell-quit (setq ispell-quit nil)))))))))

;*---------------------------------------------------------------------*/
;*    flyspell-tex-math-initialized ...                                */
;*---------------------------------------------------------------------*/
(defvar flyspell-tex-math-initialized nil)

;*---------------------------------------------------------------------*/
;*    flyspell-math-tex-command-p ...                                  */
;*    -------------------------------------------------------------    */
;*    This function uses the texmathp package to check if (point)      */
;*    is within a tex command. In order to avoid using                 */
;*    condition-case each time we use the variable                     */
;*    flyspell-tex-math-initialized to make a special case the first   */
;*    time that function is called.                                    */
;*---------------------------------------------------------------------*/
(defun flyspell-math-tex-command-p ()
  (cond
   (flyspell-check-tex-math-command
    nil)
   ((eq flyspell-tex-math-initialized t)
    (texmathp))
   ((eq flyspell-tex-math-initialized 'error)
    nil)
   (t
    (setq flyspell-tex-math-initialized t)
    (condition-case nil
	(texmathp)
      (error (progn
	       (setq flyspell-tex-math-initialized 'error)
	       nil))))))

;*---------------------------------------------------------------------*/
;*    flyspell-tex-command-p ...                                       */
;*---------------------------------------------------------------------*/
(defun flyspell-tex-command-p (word)
  "Return t if WORD is a TeX command."
  (or (save-excursion
	(let ((b  (car (cdr word))))
	  (and (re-search-backward "\\\\" (- (point) 100) t)
	       (or (= (match-end 0) b)
		   (and (goto-char (match-end 0))
			(looking-at flyspell-tex-command-regexp)
			(>= (match-end 0) b))))))
      (flyspell-math-tex-command-p)))

;*---------------------------------------------------------------------*/
;*    flyspell-casechars-cache ...                                     */
;*---------------------------------------------------------------------*/
(defvar flyspell-casechars-cache nil)
(defvar flyspell-ispell-casechars-cache nil)
(make-variable-buffer-local 'flyspell-casechars-cache)
(make-variable-buffer-local 'flyspell-ispell-casechars-cache)

;*---------------------------------------------------------------------*/
;*    flyspell-get-casechars ...                                       */
;*---------------------------------------------------------------------*/
(defun flyspell-get-casechars ()
  "This function builds a string that is the regexp of word chars.
In order to avoid one useless string construction,
this function changes the last char of the `ispell-casechars' string."
  (let ((ispell-casechars (ispell-get-casechars)))
    (cond
     ((eq ispell-parser 'tex)
      (setq flyspell-ispell-casechars-cache ispell-casechars)
      (setq flyspell-casechars-cache
	    (concat (substring ispell-casechars
			       0
			       (- (length ispell-casechars) 1))
		    "]"))
      flyspell-casechars-cache)
     (t
      (setq flyspell-ispell-casechars-cache ispell-casechars)
      (setq flyspell-casechars-cache ispell-casechars)
      flyspell-casechars-cache))))
	
;*---------------------------------------------------------------------*/
;*    flyspell-get-not-casechars-cache ...                             */
;*---------------------------------------------------------------------*/
(defvar flyspell-not-casechars-cache nil)
(defvar flyspell-ispell-not-casechars-cache nil)
(make-variable-buffer-local 'flyspell-not-casechars-cache)
(make-variable-buffer-local 'flyspell-ispell-not-casechars-cache)

;*---------------------------------------------------------------------*/
;*    flyspell-get-not-casechars ...                                   */
;*---------------------------------------------------------------------*/
(defun flyspell-get-not-casechars ()
  "This function builds a string that is the regexp of non-word chars."
  (let ((ispell-not-casechars (ispell-get-not-casechars)))
    (cond
     ((eq ispell-parser 'tex)
      (setq flyspell-ispell-not-casechars-cache ispell-not-casechars)
      (setq flyspell-not-casechars-cache
	    (concat (substring ispell-not-casechars
			       0
			       (- (length ispell-not-casechars) 1))
		    "]"))
      flyspell-not-casechars-cache)
     (t
      (setq flyspell-ispell-not-casechars-cache ispell-not-casechars)
      (setq flyspell-not-casechars-cache ispell-not-casechars)
      flyspell-not-casechars-cache))))

;*---------------------------------------------------------------------*/
;*    flyspell-get-word ...                                            */
;*---------------------------------------------------------------------*/
(defun flyspell-get-word (following)
  "Return the word for spell-checking according to Ispell syntax.
If argument FOLLOWING is non-nil or if `ispell-following-word'
is non-nil when called interactively, then the following word
\(rather than preceding\) is checked when the cursor is not over a word.
Optional second argument contains otherchars that can be included in word
many times.

Word syntax described by `ispell-dictionary-alist' (which see)."
  (let* ((flyspell-casechars (flyspell-get-casechars))
	 (flyspell-not-casechars (flyspell-get-not-casechars))
	 (ispell-otherchars (ispell-get-otherchars))
	 (ispell-many-otherchars-p (ispell-get-many-otherchars-p))
	 (word-regexp (concat flyspell-casechars
			      "+\\("
			      ispell-otherchars
			      "?"
			      flyspell-casechars
			      "+\\)"
			      (if ispell-many-otherchars-p
				  "*" "?")))
	 did-it-once
	 start end word)
    ;; find the word
    (if (not (looking-at flyspell-casechars))
	(if following
	    (re-search-forward flyspell-casechars (point-max) t)
	  (re-search-backward flyspell-casechars (point-min) t)))
    ;; move to front of word
    (re-search-backward flyspell-not-casechars (point-min) 'start)
    (let ((pos nil))
      (while (and (looking-at ispell-otherchars)
		  (not (bobp))
		  (or (not did-it-once)
		      ispell-many-otherchars-p)
		  (not (eq pos (point))))
	(setq pos (point))
	(setq did-it-once t)
	(backward-char 1)
	(if (looking-at flyspell-casechars)
	    (re-search-backward flyspell-not-casechars (point-min) 'move)
	  (backward-char -1))))
    ;; Now mark the word and save to string.
    (if (eq (re-search-forward word-regexp (point-max) t) nil)
	nil
      (progn
	(setq start (match-beginning 0)
	      end (point)
	      word (buffer-substring start end))
	(list word start end)))))

;*---------------------------------------------------------------------*/
;*    flyspell-region ...                                              */
;*---------------------------------------------------------------------*/
(defun flyspell-region (beg end)
  "Flyspell text between BEG and END."
  (interactive "r")
  (save-excursion
  (if (> beg end)
      (let ((old beg))
	(setq beg end)
	(setq end old)))
    (goto-char beg)
    (let ((count 0))
      (while (< (point) end)
	(if (= count 100)
	    (progn
	      (message "Spell Checking...%d%%"
		       (* 100 (/ (float (- (point) beg)) (- end beg))))
	      (setq count 0))
	  (setq count (+ 1 count)))
	(flyspell-word)
	(let ((cur (point)))
	  (forward-word 1)
	  (if (and (< (point) end) (> (point) (+ cur 1)))
	      (backward-char 1)))))
    (backward-char 1)
    (message "Spell Checking...done")
    (flyspell-word)))

;*---------------------------------------------------------------------*/
;*    flyspell-buffer ...                                              */
;*---------------------------------------------------------------------*/
(defun flyspell-buffer ()
  "Flyspell whole buffer."
  (interactive)
  (flyspell-region (point-min) (point-max)))

;*---------------------------------------------------------------------*/
;*    flyspell-overlay-p ...                                           */
;*---------------------------------------------------------------------*/
(defun flyspell-overlay-p (o)
  "A predicate that return true iff O is an overlay used by flyspell."
  (and (overlayp o) (overlay-get o 'flyspell-overlay)))

;*---------------------------------------------------------------------*/
;*    flyspell-delete-all-overlays ...                                 */
;*    -------------------------------------------------------------    */
;*    Remove all the overlays introduced by flyspell.                  */
;*---------------------------------------------------------------------*/
(defun flyspell-delete-all-overlays ()
  "Delete all the overlays used by flyspell."
  (let ((l (overlays-in (point-min) (point-max))))
    (while (consp l)
      (progn
	(if (flyspell-overlay-p (car l))
	    (delete-overlay (car l)))
	(setq l (cdr l))))))

;*---------------------------------------------------------------------*/
;*    flyspell-unhighlight-at ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-unhighlight-at (pos)
  "Remove the flyspell overlay that are located at POS."
  (if flyspell-persistent-highlight
      (let ((overlays (overlays-at pos)))
	(while (consp overlays)
	  (if (flyspell-overlay-p (car overlays))
	      (delete-overlay (car overlays)))
	  (setq overlays (cdr overlays))))
    (delete-overlay flyspell-overlay)))

;*---------------------------------------------------------------------*/
;*    flyspell-properties-at-p ...                                     */
;*    -------------------------------------------------------------    */
;*    Is there an highlight properties at position pos?                */
;*---------------------------------------------------------------------*/
(defun flyspell-properties-at-p (pos)
  "Return t if there is a text property at POS, not counting `local-map'.
If variable `flyspell-highlight-properties' is set to nil,
text with properties are not checked.  This function is used to discover
if the character at POS has any other property."
  (let ((prop (text-properties-at pos))
	(keep t))
    (while (and keep (consp prop))
      (if (and (eq (car prop) 'local-map) (consp (cdr prop)))
	  (setq prop (cdr (cdr prop)))
	(setq keep nil)))
    (consp prop)))

;*---------------------------------------------------------------------*/
;*    make-flyspell-overlay ...                                        */
;*---------------------------------------------------------------------*/
(defun make-flyspell-overlay (beg end face mouse-face)
  "Allocate an overlay to highlight an incorrect word.
BEG and END specify the range in the buffer of that word.
FACE and MOUSE-FACE specify the `face' and `mouse-face' properties
for the overlay."
  (let ((flyspell-overlay (make-overlay beg end)))
    (overlay-put flyspell-overlay 'face face)
    (overlay-put flyspell-overlay 'mouse-face mouse-face)
    (overlay-put flyspell-overlay 'flyspell-overlay t)
    (if (eq flyspell-emacs 'xemacs)
	(overlay-put flyspell-overlay
		     flyspell-overlay-keymap-property-name
		     flyspell-mouse-map))))
    
;*---------------------------------------------------------------------*/
;*    flyspell-highlight-incorrect-region ...                          */
;*---------------------------------------------------------------------*/
(defun flyspell-highlight-incorrect-region (beg end)
  "Set up an overlay on a misspelled word, in the buffer from BEG to END."
  (run-hook-with-args 'flyspell-incorrect-hook beg end)
  (if (or flyspell-highlight-properties (not (flyspell-properties-at-p beg)))
      (progn
	;; we cleanup current overlay at the same position
	(if (and (not flyspell-persistent-highlight)
		 (overlayp flyspell-overlay))
	    (delete-overlay flyspell-overlay)
	  (let ((overlays (overlays-at beg)))
	    (while (consp overlays)
	      (if (flyspell-overlay-p (car overlays))
		  (delete-overlay (car overlays)))
	      (setq overlays (cdr overlays)))))
	;; now we can use a new overlay
	(setq flyspell-overlay
	      (make-flyspell-overlay beg end
				     'flyspell-incorrect-face 'highlight)))))

;*---------------------------------------------------------------------*/
;*    flyspell-highlight-duplicate-region ...                          */
;*---------------------------------------------------------------------*/
(defun flyspell-highlight-duplicate-region (beg end)
  "Set up an overlay on a duplicated word, in the buffer from BEG to END."
  (if (or flyspell-highlight-properties (not (flyspell-properties-at-p beg)))
      (progn
	;; we cleanup current overlay at the same position
	(if (and (not flyspell-persistent-highlight)
		 (overlayp flyspell-overlay))
	    (delete-overlay flyspell-overlay)
	  (let ((overlays (overlays-at beg)))
	    (while (consp overlays)
	      (if (flyspell-overlay-p (car overlays))
		  (delete-overlay (car overlays)))
	      (setq overlays (cdr overlays)))))
	;; now we can use a new overlay
	(setq flyspell-overlay
	      (make-flyspell-overlay beg end
				     'flyspell-duplicate-face 'highlight)))))

;*---------------------------------------------------------------------*/
;*    flyspell-auto-correct-cache ...                                  */
;*---------------------------------------------------------------------*/
(defvar flyspell-auto-correct-pos nil)
(defvar flyspell-auto-correct-region nil)
(defvar flyspell-auto-correct-ring nil)
(defvar flyspell-auto-correct-word nil)
(make-variable-buffer-local 'flyspell-auto-correct-pos)
(make-variable-buffer-local 'flyspell-auto-correct-region)
(make-variable-buffer-local 'flyspell-auto-correct-ring)
(make-variable-buffer-local 'flyspell-auto-correct-word)

;*---------------------------------------------------------------------*/
;*    flyspell-check-previous-highlighted-word ...                     */
;*---------------------------------------------------------------------*/
(defun flyspell-check-previous-highlighted-word (&optional arg)
  "Correct the closer mispelled word.
This function scans a mis-spelled word before the cursor. If it finds one
it proposes replacement for that word. With prefix arg, count that many
misspelled words backwards."
  (interactive)
  (let ((pos1 (point))
	(pos  (point))
	(arg  (if (or (not (numberp arg)) (< arg 1)) 1 arg))
	ov ovs)
    (if (catch 'exit
	  (while (and (setq pos (previous-overlay-change pos))
		      (not (= pos pos1)))
	    (setq pos1 pos)
	    (if (> pos (point-min))
		(progn
		  (setq ovs (overlays-at (1- pos)))
		  (while (consp ovs)
		    (setq ov (car ovs))
		    (setq ovs (cdr ovs))
		    (if (and (overlay-get ov 'flyspell-overlay)
			     (= 0 (setq arg (1- arg))))
			(throw 'exit t)))))))
	(save-excursion
	  (goto-char pos)
	  (ispell-word))
      (error "No word to correct before point."))))

;*---------------------------------------------------------------------*/
;*    flyspell-display-next-corrections ...                            */
;*---------------------------------------------------------------------*/
(defun flyspell-display-next-corrections (corrections)
  (let ((string "Corrections:")
	(l corrections)
	(pos '()))
    (while (< (length string) 80)
      (if (equal (car l) flyspell-auto-correct-word)
	  (setq pos (cons (+ 1 (length string)) pos)))
      (setq string (concat string " " (car l)))
      (setq l (cdr l)))
    (while (consp pos)
      (let ((num (car pos)))
	(put-text-property num
			   (+ num (length flyspell-auto-correct-word))
			   'face
			   'flyspell-incorrect-face
			   string))
      (setq pos (cdr pos)))
    (if (fboundp 'display-message)
	(display-message 'no-log string)
      (message string))))

;*---------------------------------------------------------------------*/
;*    flyspell-auto-correct-word ...                                   */
;*---------------------------------------------------------------------*/
(defun flyspell-auto-correct-word ()
  "Correct the current word.
This command proposes various successive corrections for the current word."
  (interactive)
  (let ((pos     (point))
	(old-max (point-max)))
    ;; use the correct dictionary
    (flyspell-accept-buffer-local-defs)
    (if (and (eq flyspell-auto-correct-pos pos)
	     (consp flyspell-auto-correct-region))
	;; we have already been using the function at the same location
	(let ((start (car flyspell-auto-correct-region))
	      (len   (cdr flyspell-auto-correct-region)))
	  (delete-region start (+ start len))
	  (setq flyspell-auto-correct-ring (cdr flyspell-auto-correct-ring))
	  (let* ((word (car flyspell-auto-correct-ring))
		 (len  (length word)))
	    (rplacd flyspell-auto-correct-region len)
	    (goto-char start)
	    (insert word)
	    (flyspell-word)
	    (flyspell-display-next-corrections flyspell-auto-correct-ring))
	  (flyspell-ajust-cursor-point pos (point) old-max)
	  (setq flyspell-auto-correct-pos (point)))
      ;; fetch the word to be checked
      (let ((word (flyspell-get-word nil))
	    start end poss)
	;; destructure return word info list.
	(setq start (car (cdr word))
	      end (car (cdr (cdr word)))
	      word (car word))
	(setq flyspell-auto-correct-word word)
	;; now check spelling of word.
	(process-send-string ispell-process "%\n") ;put in verbose mode
	(process-send-string ispell-process (concat "^" word "\n"))
	;; wait until ispell has processed word
	(while (progn
		 (accept-process-output ispell-process)
		 (not (string= "" (car ispell-filter)))))
	(setq ispell-filter (cdr ispell-filter))
	(if (consp ispell-filter)
	    (setq poss (ispell-parse-output (car ispell-filter))))
	(cond ((or (eq poss t) (stringp poss))
	       ;; don't correct word
	       t)
	      ((null poss)
	       ;; ispell error
	       (error "Ispell: error in Ispell process"))
	      (t
	       ;; the word is incorrect, we have to propose a replacement
	       (let ((replacements (if flyspell-sort-corrections
				       (sort (car (cdr (cdr poss))) 'string<)
				     (car (cdr (cdr poss))))))
		 (setq flyspell-auto-correct-region nil)
		 (if (consp replacements)
		     (progn
		       (let ((replace (car replacements)))
			 (setq word replace)
			 (if (not (equal word (car poss)))
			     (progn
			       ;; the save the current replacements
			       (setq flyspell-auto-correct-region
				     (cons start (length word)))
			       (let ((l replacements))
				 (while (consp (cdr l))
				   (setq l (cdr l)))
				 (rplacd l (cons (car poss) replacements)))
			       (setq flyspell-auto-correct-ring
				     (cdr replacements))
			       (delete-region start end)
			       (insert word)
			       (flyspell-word)
			       (flyspell-display-next-corrections
				(cons word flyspell-auto-correct-ring))
			       (flyspell-ajust-cursor-point pos
							    (point)
							    old-max)))))))))
	(setq flyspell-auto-correct-pos (point))
	(ispell-pdict-save t)))))

;*---------------------------------------------------------------------*/
;*    flyspell-correct-word ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-correct-word (event)
  "Check spelling of word under or before the cursor.
If the word is not found in dictionary, display possible corrections
in a popup menu allowing you to choose one.

Word syntax described by `ispell-dictionary-alist' (which see).

This will check or reload the dictionary.  Use \\[ispell-change-dictionary]
or \\[ispell-region] to update the Ispell process."
  (interactive "e")
  (if (eq flyspell-emacs 'xemacs)
      (flyspell-correct-word/mouse-keymap event)
      (flyspell-correct-word/local-keymap event)))
    
;*---------------------------------------------------------------------*/
;*    flyspell-correct-word/local-keymap ...                           */
;*---------------------------------------------------------------------*/
(defun flyspell-correct-word/local-keymap (event)
  "emacs 19.xx seems to be buggous. Overlay keymap does not seems
to work correctly with local map. That is, if a key is not
defined for the overlay keymap, the current local map, is not
checked. The binding is resolved with the global map. The
consequence is that we can not use overlay map with flyspell."
  (interactive "e")
  (save-window-excursion
    (let ((save (point)))
      (mouse-set-point event)
      ;; we look for a flyspell overlay here
      (let ((overlays (overlays-at (point)))
	    (overlay  nil))
	(while (consp overlays)
	  (if (flyspell-overlay-p (car overlays))
	      (progn
		(setq overlay (car overlays))
		(setq overlays nil))
	    (setq overlays (cdr overlays))))
	;; we return to the correct location
	(goto-char save)
	;; we check to see if button2 has been used overlay a
	;; flyspell overlay
	(if overlay
	    ;; yes, so we use the flyspell function
	    (flyspell-correct-word/mouse-keymap event)
	  ;; no so we have to use the non flyspell binding
	  (let ((flyspell-mode nil))
	    (if (key-binding (this-command-keys))
		(command-execute (key-binding (this-command-keys))))))))))
  
;*---------------------------------------------------------------------*/
;*    flyspell-correct-word/mouse-keymap ...                           */
;*---------------------------------------------------------------------*/
(defun flyspell-correct-word/mouse-keymap (event)
  "Pop up a menu of possible corrections for a misspelled word.
The word checked is the word at the mouse position."
  (interactive "e")
  ;; use the correct dictionary
  (flyspell-accept-buffer-local-defs)
  ;; retain cursor location (I don't know why but save-excursion here fails).
  (let ((save (point)))
    (mouse-set-point event)
    (let ((cursor-location (point))
	  (word (flyspell-get-word nil))
	  start end poss replace)
      ;; destructure return word info list.
      (setq start (car (cdr word))
	    end (car (cdr (cdr word)))
	    word (car word))
      ;; now check spelling of word.
      (process-send-string ispell-process "%\n") ;put in verbose mode
      (process-send-string ispell-process (concat "^" word "\n"))
      ;; wait until ispell has processed word
      (while (progn
	       (accept-process-output ispell-process)
	       (not (string= "" (car ispell-filter)))))
      (setq ispell-filter (cdr ispell-filter))
      (if (consp ispell-filter)
	  (setq poss (ispell-parse-output (car ispell-filter))))
      (cond ((or (eq poss t) (stringp poss))
	     ;; don't correct word
	     t)
	    ((null poss)
	     ;; ispell error
	     (error "Ispell: error in Ispell process"))
	    ((string-match "GNU" (emacs-version))
	     ;; the word is incorrect, we have to propose a replacement
	     (setq replace (flyspell-emacs-popup event poss word))
	     (cond ((eq replace 'ignore)
		    (goto-char save)
		    nil)
		   ((eq replace 'save)
		    (goto-char save)
		    (process-send-string ispell-process (concat "*" word "\n"))
		    (flyspell-unhighlight-at cursor-location)
		    (setq ispell-pdict-modified-p '(t)))
		   ((or (eq replace 'buffer) (eq replace 'session))
		    (process-send-string ispell-process (concat "@" word "\n"))
		    (if (null ispell-pdict-modified-p)
			(setq ispell-pdict-modified-p
			      (list ispell-pdict-modified-p)))
		    (flyspell-unhighlight-at cursor-location)
		    (goto-char save)
		    (if (eq replace 'buffer)
			(ispell-add-per-file-word-list word)))
		   (replace
		    (setq word (if (atom replace) replace (car replace))
			  cursor-location (+ (- (length word) (- end start))
					     cursor-location))
		    (if (not (equal word (car poss)))
			(let ((old-max (point-max)))
			  (delete-region start end)
			  (insert word)
			  (flyspell-ajust-cursor-point save
						       cursor-location
						       old-max))))
		   (t
		    (goto-char save)
		    nil)))
	    ((string-match "XEmacs" (emacs-version))
	     (flyspell-xemacs-popup
	      event poss word cursor-location start end save)
	     (goto-char save)))
      (ispell-pdict-save t))))

;*---------------------------------------------------------------------*/
;*    flyspell-xemacs-correct ...                                      */
;*---------------------------------------------------------------------*/
(defun flyspell-xemacs-correct (replace poss word cursor-location start end save)
  "The xemacs popup menu callback."
  (cond ((eq replace 'ignore)
	 nil)
	((eq replace 'save)
	 (process-send-string ispell-process (concat "*" word "\n"))
	 (flyspell-unhighlight-at cursor-location)
	 (setq ispell-pdict-modified-p '(t)))
	((or (eq replace 'buffer) (eq replace 'session))
	 (process-send-string ispell-process (concat "@" word "\n"))
	 (flyspell-unhighlight-at cursor-location)
	 (if (null ispell-pdict-modified-p)
	     (setq ispell-pdict-modified-p
		   (list ispell-pdict-modified-p)))
	 (if (eq replace 'buffer)
	     (ispell-add-per-file-word-list word)))
	(replace
	 (let ((old-max (point-max)))
	   (setq word (if (atom replace) replace (car replace))
		 cursor-location (+ (- (length word) (- end start))
				    cursor-location))
	   (if (not (equal word (car poss)))
	       (progn
		 (delete-region start end)
		 (goto-char start)
		 (insert word)))
	   (flyspell-ajust-cursor-point save cursor-location old-max)))))

;*---------------------------------------------------------------------*/
;*    flyspell-ajust-cursor-point ...                                  */
;*---------------------------------------------------------------------*/
(defun flyspell-ajust-cursor-point (save cursor-location old-max)
  (if (>= save cursor-location)
      (let ((new-pos (+ save (- (point-max) old-max))))
	(goto-char (cond
		    ((< new-pos (point-min))
		     (point-min))
		    ((> new-pos (point-max))
		     (point-max))
		    (t new-pos))))
    (goto-char save)))

;*---------------------------------------------------------------------*/
;*    flyspell-emacs-popup ...                                         */
;*---------------------------------------------------------------------*/
(defun flyspell-emacs-popup (event poss word)
  "The Emacs popup menu."
  (if (not event)
      (let* ((mouse-pos  (mouse-position))
	     (mouse-pos  (if (nth 1 mouse-pos)
			     mouse-pos
			   (set-mouse-position (car mouse-pos)
				 	       (/ (frame-width) 2) 2)
			   (unfocus-frame)
			   (mouse-position))))
	(setq event (list (list (car (cdr mouse-pos))
				(1+ (cdr (cdr mouse-pos))))
			  (car mouse-pos)))))
  (let* ((corrects   (if flyspell-sort-corrections
			 (sort (car (cdr (cdr poss))) 'string<)
		       (car (cdr (cdr poss)))))
	 (cor-menu   (if (consp corrects)
			 (mapcar (lambda (correct)
				   (list correct correct))
				 corrects)
		       '()))
	 (affix      (car (cdr (cdr (cdr poss)))))
	 (base-menu  (let ((save (if (consp affix)
				     (list
				      (list (concat "Save affix: " (car affix))
					    'save)
				      '("Accept (session)" accept)
				      '("Accept (buffer)" buffer))
				   '(("Save word" save)
				     ("Accept (session)" session)
				     ("Accept (buffer)" buffer)))))
		       (if (consp cor-menu)
			   (append cor-menu (cons "" save))
			 save)))
	 (menu       (cons "flyspell correction menu" base-menu)))
    (car (x-popup-menu event
		       (list (format "%s [%s]" word (or ispell-local-dictionary
							ispell-dictionary))
			     menu)))))

;*---------------------------------------------------------------------*/
;*    flyspell-xemacs-popup ...                                        */
;*---------------------------------------------------------------------*/
(defun flyspell-xemacs-popup (event poss word cursor-location start end save)
  "The xemacs popup menu."
  (let* ((corrects   (if flyspell-sort-corrections
			 (sort (car (cdr (cdr poss))) 'string<)
		       (car (cdr (cdr poss)))))
	 (cor-menu   (if (consp corrects)
			 (mapcar (lambda (correct)
				   (vector correct
					   (list 'flyspell-xemacs-correct
						 correct
						 (list 'quote poss)
						 word
						 cursor-location
						 start
						 end
						 save)
					   t))
				 corrects)
		       '()))
	 (affix      (car (cdr (cdr (cdr poss)))))
	 (menu       (let ((save (if (consp affix)
				     (vector
				      (concat "Save affix: " (car affix))
				      (list 'flyspell-xemacs-correct
					    ''save
					    (list 'quote poss)
					    word
					    cursor-location
					    start
					    end
					    save)
				      t)
				   (vector
				    "Save word"
				    (list 'flyspell-xemacs-correct
					  ''save
					  (list 'quote poss)
					  word
					  cursor-location
					  start
					  end
					  save)
				    t)))
			   (session (vector "Accept (session)"
					    (list 'flyspell-xemacs-correct
						  ''session
						  (list 'quote poss)
						  word
						  cursor-location
						  start
						  end
						  save)
					    t))
			   (buffer  (vector "Accept (buffer)"
					    (list 'flyspell-xemacs-correct
						  ''buffer
						  (list 'quote poss)
						  word
						  cursor-location
						  start
						  end
						  save)
					    t)))
		       (if (consp cor-menu)
			   (append cor-menu (list "-" save session buffer))
			 (list save session buffer)))))
    (popup-menu (cons (format "%s [%s]" word (or ispell-local-dictionary
						 ispell-dictionary))
		      menu))))

(provide 'flyspell)
;;; flyspell.el ends here
