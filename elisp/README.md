# PaperBanana / Graphics Demo Kit for Emacs

This zip contains a small set of Emacs Lisp files that demonstrate:

- inline SVG rendering in normal buffers
- PaperBanana-style menu cards
- tiny charts rendered as SVG
- image viewing, including animated GIFs supported by your Emacs build
- simple presentation buffers
- optional browser embedding checks for xwidgets and EAF

The code is intentionally small and hackable.

## Files

- `pb-menu.el` — PaperBanana-style menu buffer and decorative SVG cards
- `pb-chart.el` — tiny bar chart, sparkline, and scatter plot demos
- `pb-media.el` — image viewing helpers and animated status/header demo
- `pb-web.el` — browser integration helpers for xwidgets and EAF
- `pb-present.el` — simple slide/presentation mode with keyboard navigation
- `pb-demo-init.el` — convenience loader and a demo command index

## Requirements

Minimum practical requirement:

- Emacs 29+ recommended

Nice to have:

- SVG support in your Emacs build
- image support for PNG/GIF/WebP/etc.
- `gnuplot` if you want Org plotting outside these demos
- xwidgets-enabled Emacs if you want embedded WebKit
- EAF installed if you want EAF browser integration

## Quick start

1. Unzip the archive.
2. Add the directory to your `load-path`.
3. Load `pb-demo-init.el`.

Example:

```elisp
(add-to-list 'load-path "/path/to/pb-emacs-demo")
(require 'pb-demo-init)
```

Or interactively:

```elisp
M-x load-file RET /path/to/pb-emacs-demo/pb-demo-init.el RET
```

## Main commands

After loading `pb-demo-init.el`, run:

- `M-x pb-demo-help`

That opens a command reference buffer.

### PaperBanana / menu demos

- `M-x pb-menu-demo`  
  Open a buffer containing PaperBanana-style SVG menu cards.

- `M-x pb-menu-illuminated-demo`  
  Open a decorative title card with a manuscript-like drop-cap effect.

### Chart demos

- `M-x pb-chart-bar-demo`  
  Render a simple bar chart as inline SVG.

- `M-x pb-chart-sparkline-demo`  
  Render a sparkline-style SVG.

- `M-x pb-chart-scatter-demo`  
  Render a simple scatter plot SVG.

### Media / animation demos

- `M-x pb-media-open-image`  
  Prompt for an image file and display it in an Emacs buffer.

- `M-x pb-media-header-heat-start`  
  Start a simple animated header-line “heat/flame” indicator.

- `M-x pb-media-header-heat-stop`  
  Stop the animation.

### Presentation demo

- `M-x pb-present-demo`  
  Open a tiny presentation with keyboard navigation.

Inside the presentation buffer:

- `n` — next slide
- `p` — previous slide
- `g` — redraw current slide
- `q` — quit window

### Browser / embedded web demos

- `M-x pb-web-status`  
  Show whether xwidgets and EAF appear available.

- `M-x pb-web-browse-url`  
  Prompt for a URL and open it using xwidgets if available, else EAF if available, else normal browser.

- `M-x pb-web-open-local-file`  
  Prompt for a local HTML file and open it.

## Suggested evaluation sequence

### 1. Native SVG/UI pass

Run these in order:

```elisp
M-x pb-menu-demo
M-x pb-menu-illuminated-demo
M-x pb-chart-bar-demo
M-x pb-chart-sparkline-demo
M-x pb-chart-scatter-demo
```

This validates the native buffer/SVG path.

### 2. Media pass

```elisp
M-x pb-media-open-image
M-x pb-media-header-heat-start
M-x pb-media-header-heat-stop
```

Use a local SVG, PNG, or GIF file for the image test.

### 3. Presentation pass

```elisp
M-x pb-present-demo
```

Then use `n`, `p`, `g`, and `q`.

### 4. Embedded browser pass

```elisp
M-x pb-web-status
M-x pb-web-browse-url
```

If you have xwidgets-enabled Emacs, this may open inside Emacs. Otherwise it falls back cleanly.

## Notes

### SVG support

If SVG rendering fails, inspect:

```elisp
(image-type-available-p 'svg)
```

### Image support

To inspect supported image types:

```elisp
(image-type-available-p 'png)
(image-type-available-p 'gif)
(image-type-available-p 'webp)
```

### xwidgets support

To check xwidget availability:

```elisp
(featurep 'xwidget-internal)
(fboundp 'xwidget-webkit-browse-url)
```

### EAF support

This demo checks whether `eaf-open-browser` is defined. If EAF is installed and loaded, `pb-web-browse-url` can use it.

## Extending this kit

Good next steps:

- add clickable menu actions to the SVG menu cards
- add layout helpers for arrows, callouts, and swimlanes
- add Org integration so slides render from headings
- add Rust-backed SVG layout or graph-layout helpers later if desired

