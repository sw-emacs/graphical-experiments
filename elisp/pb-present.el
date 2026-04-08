;;; pb-present.el --- Tiny presentation demo mode for Emacs -*- lexical-binding: t; -*-

(require 'pb-menu)
(require 'pb-chart)

(defgroup pb-present nil
  "Tiny presentation mode demos."
  :group 'multimedia)

(defvar-local pb-present--slide-index 0)
(defvar pb-present--slides nil)

(defvar pb-present-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'pb-present-next)
    (define-key map (kbd "p") #'pb-present-prev)
    (define-key map (kbd "g") #'pb-present-redraw)
    (define-key map (kbd "q") #'quit-window)
    map)
  "Keymap for `pb-present-mode'.")

(define-derived-mode pb-present-mode special-mode "PB-Present"
  "Simple presentation demo mode.")

(defun pb-present--slide-1 ()
  (insert-image
   (svg-image
    (pb-menu--card-svg
     "PaperBanana in Emacs"
     "SVG cards, visual menus, and slide-like buffers"
     840 140)
    :ascent 'center))
  (insert "\n\n")
  (insert "- Inline SVG works well for title cards and menu panels.\n")
  (insert "- Buffer-local navigation is simple and keyboard-friendly.\n")
  (insert "- Export paths can later target SVG or HTML.\n"))

(defun pb-present--slide-2 ()
  (insert "Charts can be embedded directly in the presentation buffer.\n\n")
  (insert-image
   (svg-image (pb-chart--bar-svg '(4 7 5 9 8 10 6)) :ascent 'center))
  (insert "\n"))

(defun pb-present--slide-3 ()
  (insert-image
   (svg-image
    (pb-menu--dropcap-svg
     "W"
     "Web / WASM Integration"
     "Use xwidgets or EAF when you want live HTML, JS, or WASM apps")
    :ascent 'center))
  (insert "\n\n")
  (insert "Navigation keys: n = next, p = previous, g = redraw, q = quit\n"))

(setq pb-present--slides
      [pb-present--slide-1 pb-present--slide-2 pb-present--slide-3])

(defun pb-present--render-current-slide ()
  (let ((inhibit-read-only t))
    (erase-buffer)
    (setq-local line-spacing 0.3)
    (funcall (aref pb-present--slides pb-present--slide-index))
    (goto-char (point-min))))

(defun pb-present-next ()
  "Move to the next slide."
  (interactive)
  (setq pb-present--slide-index
        (min (1- (length pb-present--slides))
             (1+ pb-present--slide-index)))
  (pb-present--render-current-slide))

(defun pb-present-prev ()
  "Move to the previous slide."
  (interactive)
  (setq pb-present--slide-index (max 0 (1- pb-present--slide-index)))
  (pb-present--render-current-slide))

(defun pb-present-redraw ()
  "Redraw the current slide."
  (interactive)
  (pb-present--render-current-slide))

(defun pb-present-demo ()
  "Open a tiny presentation demo."
  (interactive)
  (let ((buf (get-buffer-create "*PB Presentation*")))
    (with-current-buffer buf
      (pb-present-mode)
      (setq pb-present--slide-index 0)
      (pb-present--render-current-slide))
    (pop-to-buffer buf)))

(provide 'pb-present)
;;; pb-present.el ends here
