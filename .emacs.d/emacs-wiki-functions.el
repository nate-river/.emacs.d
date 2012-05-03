;; evaluate this buffer to make it work

(defun my-publishing-header ()
    (if (file-exists-p "adds/header.wiki")
        (insert-file "adds/header.wiki")
      "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\">
<html>
  <head>
    <title><lisp>(emacs-wiki-page-title)</lisp></title>
    <meta name=\"generator\" content=\"emacs-wiki.el\">
    <meta http-equiv=\"<lisp>emacs-wiki-meta-http-equiv</lisp>\"
	  content=\"<lisp>emacs-wiki-meta-content</lisp>\">
    <link rev=\"made\" href=\"<lisp>emacs-wiki-maintainer</lisp>\">
    <link rel=\"home\" href=\"<lisp>(emacs-wiki-published-name
				     emacs-wiki-home-page)</lisp>\">
    <link rel=\"index\" href=\"<lisp>(emacs-wiki-published-name
				      emacs-wiki-index-page)</lisp>\">
    <lisp>emacs-wiki-style-sheet</lisp>
  </head>
  <body>
    <h1><lisp>(emacs-wiki-page-title)</lisp></h1>
    <!-- Page published by Emacs Wiki begins here -->\n"))

(setq emacs-wiki-publishing-header "<lisp>(my-publishing-header)</lisp>")


(defun my-publishing-footer ()
    (if (file-exists-p "adds/footer.wiki")
        (insert-file "adds/footer.wiki")
  "
    <!-- Page published by Emacs Wiki ends here -->
    <div class=\"navfoot\">
      <hr>
      <table width=\"100%\" border=\"0\" summary=\"Footer navigation\">
	<tr>
	  <td width=\"33%\" align=\"left\">
	    <lisp>
	      (if buffer-file-name
		  (concat
		   \"<span class=\\\"footdate\\\">最后更新：\"
		   (format-time-string emacs-wiki-footer-date-format
		    (nth 5 (file-attributes buffer-file-name)))
		   (and emacs-wiki-serving-p
			(emacs-wiki-editable-p (emacs-wiki-page-name))
			(concat
			 \" / \"
			 (emacs-wiki-link-href
			  (concat \"editwiki?\" (emacs-wiki-page-name))
			  \"Edit\")))
		   \"</span>\"))
	    </lisp>
	  </td>
	  <td width=\"34%\" align=\"center\">
	    <span class=\"foothome\">
	      <lisp>
		(concat
		 (and (emacs-wiki-page-file emacs-wiki-home-page t)
		      (not (emacs-wiki-private-p emacs-wiki-home-page))
		      (concat
		       (emacs-wiki-link-href emacs-wiki-home-page \"回主页\")
		       \" / \"))
		 (emacs-wiki-link-href emacs-wiki-index-page \"索引\")
		 (and (emacs-wiki-page-file \"ChangeLog\" t)
		      (not (emacs-wiki-private-p \"ChangeLog\"))
		      (concat
		       \" / \"
		       (emacs-wiki-link-href \"ChangeLog\" \"Modifications\"))))
	      </lisp>
	    </span>
	  </td>
	  <td width=\"33%\" align=\"right\">
	    <lisp>
	      (if emacs-wiki-serving-p
		  (concat
		   \"<span class=\\\"footfeed\\\">\"
		   (emacs-wiki-link-href \"searchwiki?get\" \"Search\")
		   (and buffer-file-name
			(concat
			 \" / \"
			 (emacs-wiki-link-href
			  (concat \"searchwiki?q=\" (emacs-wiki-page-name))
			  \"Referrers\")))
		   \"</span>\"))
	    </lisp>
	  </td>
	</tr>
      </table>
    </div>
  </body>
</html>\n"))

(setq emacs-wiki-publishing-footer "<lisp>(my-publishing-footer)</lisp>")

(defsubst emacs-wiki-link-href-menu (name)
  "Return an item for the menu with NAME. Use .menu stylesheet class for menu item. "
  (concat "<p><a class=\"menu\" href=\"" (emacs-wiki-published-name name) "\">" name "</a></p>"))


  
