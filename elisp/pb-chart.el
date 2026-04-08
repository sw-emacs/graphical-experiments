;;; pb-chart.el --- Tiny SVG chart demos for Emacs -*- lexical-binding: t; -*-

(require 'svg)
(require 'cl-lib)

(defgroup pb-chart nil
  "Tiny SVG chart demos."
  :group 'multimedia)

(defun pb-chart--require-svg ()
  (unless (image-type-available-p 'svg)
    (error "This Emacs build does not appear to support SVG images")))

(defun pb-chart--normalize-values (values max-height)
  (let ((maxv (max 1.0 (float (apply #'max values)))))
    (mapcar (lambda (v) (* max-height (/ (float v) maxv))) values)))

(defun pb-chart--insert-svg-buffer (buffer-name svg caption)
  (let ((buf (get-buffer-create buffer-name))
        (inhibit-read-only t))
    (with-current-buffer buf
      (erase-buffer)
      (special-mode)
      (insert-image (svg-image svg :ascent 'center))
      (insert "\n\n" caption "\n")
      (goto-char (point-min)))
    (pop-to-buffer buf)))

(defun pb-chart--bar-svg (values)
  (let* ((width 760)
         (height 260)
         (left 44)
         (bottom 220)
         (bar-width 58)
         (gap 24)
         (scaled (pb-chart--normalize-values values 150))
         (svg (svg-create width height :stroke-width 2)))
    (svg-rectangle svg 0 0 width height :fill "white")
    (svg-line svg left 30 left bottom :stroke "#657b83")
    (svg-line svg left bottom 720 bottom :stroke "#657b83")
    (cl-loop for h in scaled
             for i from 0 do
             (let* ((x (+ left 24 (* i (+ bar-width gap))))
                    (y (- bottom h)))
               (svg-rectangle svg x y bar-width h
                              :rx 8 :ry 8
                              :fill "#268bd2"
                              :stroke "#1c6ea4")
               (svg-text svg (number-to-string (nth i values))
                         :x (+ x 14) :y (+ bottom 22)
                         :font-size 14
                         :fill "#586e75")))
    (svg-text svg "Bar Chart Demo" :x 44 :y 22 :font-size 22 :font-weight "bold" :fill "#073642")
    svg))

(defun pb-chart--sparkline-svg (values)
  (let* ((width 760)
         (height 180)
         (left 20)
         (top 20)
         (plot-width 700)
         (plot-height 110)
         (maxv (max 1.0 (float (apply #'max values))))
         (minv (float (apply #'min values)))
         (range (max 1.0 (- maxv minv)))
         (step (/ (float plot-width) (max 1 (- (length values) 1))))
         (svg (svg-create width height :stroke-width 2)))
    (svg-rectangle svg 0 0 width height :fill "white")
    (svg-text svg "Sparkline Demo" :x 20 :y 18 :font-size 22 :font-weight "bold" :fill "#073642")
    (cl-loop for v in values
             for i from 0
             for x = (+ left (* i step))
             for y = (+ top (- plot-height (* plot-height (/ (- (float v) minv) range))))
             for prev-x = nil then x
             for prev-y = nil then y
             do
             (when (and prev-x prev-y)
               (svg-line svg prev-x prev-y x y :stroke "#2aa198"))
             (svg-circle svg x y 3 :fill "#cb4b16" :stroke "#cb4b16"))
    svg))

(defun pb-chart--scatter-svg (points)
  (let* ((width 760)
         (height 260)
         (left 54)
         (bottom 220)
         (plot-width 650)
         (plot-height 160)
         (max-x (max 1.0 (float (apply #'max (mapcar #'car points)))))
         (max-y (max 1.0 (float (apply #'max (mapcar #'cadr points)))))
         (svg (svg-create width height :stroke-width 2)))
    (svg-rectangle svg 0 0 width height :fill "white")
    (svg-line svg left 30 left bottom :stroke "#657b83")
    (svg-line svg left bottom (+ left plot-width) bottom :stroke "#657b83")
    (svg-text svg "Scatter Plot Demo" :x 54 :y 22 :font-size 22 :font-weight "bold" :fill "#073642")
    (dolist (pt points)
      (let* ((x (+ left (* plot-width (/ (float (car pt)) max-x))))
             (y (- bottom (* plot-height (/ (float (cadr pt)) max-y)))))
        (svg-circle svg x y 6 :fill "#6c71c4" :stroke "#4b4ea3")))
    svg))

(defun pb-chart-bar-demo ()
  "Render a demo bar chart into a buffer."
  (interactive)
  (pb-chart--require-svg)
  (pb-chart--insert-svg-buffer
   "*PB Bar Chart*"
   (pb-chart--bar-svg '(5 9 3 8 10 6 7))
   "A simple SVG bar chart rendered inline in an ordinary Emacs buffer."))

(defun pb-chart-sparkline-demo ()
  "Render a demo sparkline into a buffer."
  (interactive)
  (pb-chart--require-svg)
  (pb-chart--insert-svg-buffer
   "*PB Sparkline*"
   (pb-chart--sparkline-svg '(2 3 5 4 7 9 8 10 9 12 11 13 15 14))
   "A sparkline-style chart that fits well in dashboards or presentation notes."))

(defun pb-chart-scatter-demo ()
  "Render a demo scatter plot into a buffer."
  (interactive)
  (pb-chart--require-svg)
  (pb-chart--insert-svg-buffer
   "*PB Scatter Plot*"
   (pb-chart--scatter-svg '((1 3) (2 5) (3 2) (4 8) (5 7) (6 10) (7 9)))
   "A basic scatter plot rendered as SVG."))

(provide 'pb-chart)
;;; pb-chart.el ends here
