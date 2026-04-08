;;; pb-web.el --- Browser embedding helpers for Emacs -*- lexical-binding: t; -*-

(require 'browse-url)

(defgroup pb-web nil
  "Browser integration helpers."
  :group 'multimedia)

(defun pb-web--xwidget-available-p ()
  (and (featurep 'xwidget-internal)
       (fboundp 'xwidget-webkit-browse-url)))

(defun pb-web--eaf-available-p ()
  (fboundp 'eaf-open-browser))

(defun pb-web-status ()
  "Show available browser embedding options."
  (interactive)
  (message "pb-web: xwidgets=%s eaf=%s browse-url=%s"
           (if (pb-web--xwidget-available-p) "yes" "no")
           (if (pb-web--eaf-available-p) "yes" "no")
           (if (fboundp 'browse-url) "yes" "no")))

(defun pb-web-browse-url (url)
  "Open URL using xwidgets if available, else EAF, else normal browser."
  (interactive "sURL: ")
  (cond
   ((pb-web--xwidget-available-p)
    (xwidget-webkit-browse-url url))
   ((pb-web--eaf-available-p)
    (eaf-open-browser url))
   (t
    (browse-url url))))

(defun pb-web-open-local-file (file)
  "Open a local HTML file via pb-web-browse-url."
  (interactive "fLocal HTML file: ")
  (pb-web-browse-url (concat "file://" (expand-file-name file))))

(provide 'pb-web)
;;; pb-web.el ends here
