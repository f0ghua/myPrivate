;;----------------------------------------------------------------------------
;; UI setting
;;----------------------------------------------------------------------------
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq indicate-empty-lines t)
(setq show-trailing-whitespace t)
(show-paren-mode t)
(tool-bar-mode -1)
(set-scroll-bar-mode nil)
(menu-bar-mode -1)
(column-number-mode t)
(blink-cursor-mode -1)
(setq visible-cursor nil)
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;; define this value to nil when doing elpa-mirror
(defvar my:use-chinese-font t)
;; Set font size. Font size is set to my:font-size/10
(defvar my:font-size 90)

(require 'cl-lib) ;; for cl-loop

(when my:use-chinese-font
  (defun qiang-font-existsp (font)
    (if (null (x-list-fonts font))
        nil
      t))

  (defvar zh-font-list '("PingFangSC-Regular" "Hiragino Sans GB" "Microsoft Yahei" "Source Han Sans Normal" "STHeiti"))
  (defvar en-font-list '("DejaVu Sans Mono" "Monaco" "Consolas" "Monospace" "Courier New"))

  (defun qiang-make-font-string (font-name font-size)
    (if (and (stringp font-size)
             (equal ":" (string (elt font-size 0))))
        (format "%s%s" font-name font-size)
      (format "%s %s" font-name font-size)))

  (defun qiang-set-font (english-fonts
                         english-font-size
                         chinese-fonts
                         &optional chinese-font-scale)

    (setq chinese-font-scale (or chinese-font-scale 1.2))

    (setq face-font-rescale-alist
          (cl-loop for x in zh-font-list
                   collect (cons x chinese-font-scale)))

    "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-scale to nil, it will follow english-font-size"

    (require 'cl)                         ; for find if
    (let ((en-font (qiang-make-font-string
                    (find-if #'qiang-font-existsp english-fonts)
                    english-font-size))
          (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts))))

      ;; Set the default English font
      (message "Set English Font to %s" en-font)
      (set-face-attribute 'default nil :font en-font)

      ;; Set Chinese font
      ;; Do not use 'unicode charset, it will cause the English font setting invalid
      (message "Set Chinese Font to %s" zh-font)
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font)
                          charset zh-font))))

  (qiang-set-font en-font-list (/ my:font-size 10) zh-font-list)
)

;; Set default font
;; (cond
;;  ((string-equal system-type "gnu/linux")
;;   (set-face-attribute 'default nil
;;                       :family "Sarasa Mono SC"
;;                       :height 135
;;                       :weight 'normal
;;                       :width 'normal))
;;  ((string-equal system-type "darwin")
;;   (set-face-attribute 'default nil
;;                       :family "SF Mono"
;;                       :height 160
;;                       :weight 'normal
;;                       :width 'normal))
;;  ((string-equal system-type "windows-nt")
;;   (set-face-attribute 'default nil
;;                       :family "Microsoft Yahei Mono"
;;                       :height 90
;;                       :weight 'normal
;;                       :width 'normal))
;;  )

;; disable bold
(defadvice set-face-attribute
    (before no-bold (face frame &rest args) activate)
  (setq args
        (mapcar (lambda(x) (if (eq x 'bold) 'normal x))
                args)))

;; (use-package doom-modeline
;;   :pin melpa
;;   :ensure t
;;   :config
;;   (set-face-foreground 'doom-modeline-buffer-modified "sandybrown")
;;   (setq doom-modeline-buffer-modification-icon nil)
;;   (setq doom-modeline-project-detection 'project)
;;   (setq doom-modeline-buffer-file-name-style 'truncate-all)
;;   (setq doom-modeline-enable-word-count t)
;;   (doom-modeline-mode 1)
;;   )

;; (use-package rainbow-delimiters
;;   :pin melpa
;;   :ensure t
;;   :hook (prog-mode-hook . rainbow-delimiters-mode)
;;   )

(use-package zenburn-theme
  :pin melpa
  :ensure t
  :config
  ;; use variable-pitch fonts for some headings and titles
  ;; (setq zenburn-use-variable-pitch t)
  ;; scale headings in org-mode
  (setq zenburn-scale-org-headlines t)
  ;; scale headings in outline-mode
  (setq zenburn-scale-outline-headlines t)
  (load-theme 'zenburn t)
  )

;; (load-theme 'leuven)

(set-face-foreground 'line-number "darkgrey")

;; (use-package display-fill-column-indicator
;;   :pin manual
;;   :custom
;;   (display-fill-column-indicator-column 100)
;;   (display-fill-column-indicator-character ?\u2502)
;;   ;; :init
;;   ;; (global-display-fill-column-indicator-mode t)
;;   )

(use-package hl-todo
  :pin melpa
  :ensure t
  :config
  (setq hl-todo-keyword-faces
		'(("TODO" . "#FF0000")
          ("FIXME" . "#FF0000")))
  :init
  (global-hl-todo-mode t)
  )

(provide 'init-ui)
