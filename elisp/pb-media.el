;;; pb-media.el --- Image and animation demos for Emacs -*- lexical-binding: t; -*-

(defgroup pb-media nil
  "Media demos for Emacs buffers."
  :group 'multimedia)

(defvar pb-media--header-phase 0)
(defvar pb-media--header-timer nil)

(defun pb-media-open-image (file)
  "Open FILE as an image in a dedicated buffer.
This works well for SVG, PNG, GIF, and other formats supported by your Emacs build."
  (interactive "fImage file: ")
  (let ((buf (get-buffer-create "*PB Media*"))
        (inhibit-read-only t))
    (with-current-buffer buf
      (erase-buffer)
      (insert-image (create-image file))
      (insert "\n\n")
      (insert (format "File: %s\n" file))
      (image-mode))
    (pop-to-buffer buf)))

(defun pb-media--heat-frame ()
  (let* ((frames ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" "▇" "▆" "▅" "▄" "▃" "▂"])
         (i (mod pb-media--header-phase (length frames))))
    (setq pb-media--header-phase (1+ pb-media--header-phase))
    (format " PB Heat %s%s%s "
            (aref frames i)
            (aref frames (mod (+ i 4) (length frames)))
            (aref frames (mod (+ i 8) (length frames))))))

(defun pb-media-header-heat-start ()
  "Start a simple animated header-line indicator."
  (interactive)
  (pb-media-header-heat-stop)
  (setq pb-media--header-timer
        (run-at-time 0 0.15
                     (lambda ()
                       (setq-default header-line-format
                                     '((:eval (propertize (pb-media--heat-frame)
                                                          'face 'mode-line-emphasis))))
                       (force-mode-line-update t))))
  (message "PB header heat animation started"))

(defun pb-media-header-heat-stop ()
  "Stop the animated header-line indicator."
  (interactive)
  (when pb-media--header-timer
    (cancel-timer pb-media--header-timer)
    (setq pb-media--header-timer nil))
  (setq-default header-line-format nil)
  (force-mode-line-update t)
  (message "PB header heat animation stopped"))

(provide 'pb-media)
;;; pb-media.el ends here
