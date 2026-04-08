;;; pb-menu.el --- PaperBanana-style SVG menu demos -*- lexical-binding: t; -*-

(require 'svg)
(require 'subr-x)

(defgroup pb-menu nil
  "PaperBanana-style buffer UI demos."
  :group 'multimedia)

(defun pb-menu--require-svg ()
  (unless (image-type-available-p 'svg)
    (error "This Emacs build does not appear to support SVG images")))

(defun pb-menu--insert-svg (svg)
  (insert-image (svg-image svg :ascent 'center))
  (insert "\n"))

(defun pb-menu--card-svg (title subtitle &optional width height)
  (let* ((width (or width 760))
         (height (or height 120))
         (svg (svg-create width height :stroke-width 2)))
    (svg-rectangle svg 8 8 (- width 16) (- height 16)
                   :rx 18 :ry 18
                   :fill "#fdf6e3"
                   :stroke "#586e75")
    (svg-rectangle svg 24 22 72 72
                   :rx 10 :ry 10
                   :fill "#eee8d5"
                   :stroke "#93a1a1")
    (svg-text svg "PB"
              :x 42 :y 68
              :font-size 30
              :font-weight "bold"
              :fill "#073642")
    (svg-text svg title
              :x 120 :y 52
              :font-size 26
              :font-weight "bold"
              :fill "#073642")
    (svg-text svg subtitle
              :x 120 :y 84
              :font-size 15
              :fill "#586e75")
    svg))

(defun pb-menu--badge-svg (label &optional fill)
  (let* ((fill (or fill "#268bd2"))
         (char-width 9)
         (width (+ 24 (* char-width (length label))))
         (svg (svg-create width 36 :stroke-width 1.5)))
    (svg-rectangle svg 1 1 (- width 2) 34
                   :rx 14 :ry 14
                   :fill fill
                   :stroke "#1c6ea4")
    (svg-text svg label
              :x 14 :y 23
              :font-size 15
              :font-weight "bold"
              :fill "white")
    svg))

(defun pb-menu--dropcap-svg (letter title subtitle)
  (let* ((svg (svg-create 900 180 :stroke-width 2)))
    (svg-rectangle svg 8 8 884 164
                   :rx 18 :ry 18
                   :fill "#faf3dd"
                   :stroke "#6c584c")
    (svg-rectangle svg 24 24 110 130
                   :rx 8 :ry 8
                   :fill "#ddbea9"
                   :stroke "#6c584c")
    (svg-text svg letter
              :x 48 :y 118
              :font-size 92
              :font-weight "bold"
              :fill "#5b3a29")
    (svg-text svg title
              :x 160 :y 76
              :font-size 30
              :font-weight "bold"
              :fill "#3d2b1f")
    (svg-text svg subtitle
              :x 160 :y 116
              :font-size 16
              :fill "#6c584c")
    svg))

(defun pb-menu-demo ()
  "Open a buffer containing PaperBanana-style demo cards."
  (interactive)
  (pb-menu--require-svg)
  (let ((buf (get-buffer-create "*PB Menu Demo*"))
        (inhibit-read-only t))
    (with-current-buffer buf
      (erase-buffer)
      (special-mode)
      (setq-local line-spacing 0.25)
      (insert "PaperBanana-style menu demo\n\n")
      (pb-menu--insert-svg
       (pb-menu--card-svg
        "Presentations"
        "SVG cards, visual menus, headings, arrows, and callouts"))
      (insert "  ")
      (insert-image (svg-image (pb-menu--badge-svg "Slides" "#2aa198") :ascent 'center))
      (insert "  ")
      (insert-image (svg-image (pb-menu--badge-svg "Menus" "#859900") :ascent 'center))
      (insert "  ")
      (insert-image (svg-image (pb-menu--badge-svg "Status UI" "#b58900") :ascent 'center))
      (insert "\n\n")
      (pb-menu--insert-svg
       (pb-menu--card-svg
        "Charts"
        "Tiny charts rendered as inline SVG inside ordinary buffers"))
      (pb-menu--insert-svg
       (pb-menu--card-svg
        "Browser / WASM"
        "Try xwidgets or EAF for embedded HTML, JavaScript, and WASM apps"))
      (goto-char (point-min)))
    (pop-to-buffer buf)))

(defun pb-menu-illuminated-demo ()
  "Open a decorative illuminated-title demo buffer."
  (interactive)
  (pb-menu--require-svg)
  (let ((buf (get-buffer-create "*PB Illuminated Demo*"))
        (inhibit-read-only t))
    (with-current-buffer buf
      (erase-buffer)
      (special-mode)
      (insert-image
       (svg-image
        (pb-menu--dropcap-svg
         "P"
         "PaperBanana Presentation Aesthetic"
         "Decorative title cards, drop caps, and high-contrast callouts")
        :ascent 'center))
      (insert "\n\nThis buffer demonstrates a manuscript-like title treatment using inline SVG.\n")
      (insert "You can expand this into menu systems, title slides, or section dividers.\n")
      (goto-char (point-min)))
    (pop-to-buffer buf)))

(provide 'pb-menu)
;;; pb-menu.el ends here
