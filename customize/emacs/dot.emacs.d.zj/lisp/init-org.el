;; (use-package htmlize
;;   :pin melpa
;;   :ensure t
;;   :defer t
;;   )

;; https://emacs.stackexchange.com/questions/17710/use-package-with-config-to-set-variables
(use-package org
  :pin org
  :ensure org-plus-contrib
  :bind (("<f9> t l" . org-toggle-link-display)
		 ("<f9> t f" . org-footnote-new)
		 ("<f9> t i" . org-toggle-inline-images)
		 )
  :init
  (setq org-log-done t)
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width nil)
  ;;(setq org-image-actual-width 500)
  ;; set auto linewrap
  ;; https://superuser.com/questions/299886/linewrap-in-org-mode-of-emacs/299897
  (setq org-startup-truncated nil)
  ;; set org mode src highlighting by default
  (setq org-src-fontify-natively t)
  ;; set maximum indentation for description lists
  (setq org-list-description-max-indent 5)
  ;; prevent demoting heading also shifting text inside sections
  (setq org-adapt-indentation nil)
  (setq org-src-strip-leading-and-trailing-blank-lines t)
  (setq org-src-preserve-indentation t)
  (setq org-src-tab-acts-natively t)

  :config
  ;; GTD setting
  (require 'org-inlinetask)

  ;; to be defined later
  ;; (setq org-todo-keywords
  ;;       '((sequence "TODO(t)" "BLOCK(b)" "|" "DONE(d)" "CANCELD(d)")))
  ;; (setq org-agenda-files '("~/.emacs.d/gtd.org"))

  ;; Support converting org to confluence format
  (require 'ox-confluence)

  ;; (require 'org-tempo)

  ;; (use-package ob-go
  ;;   :pin melpa
  ;;   :ensure t
  ;;   )

  ;; programming languages
  ;; (org-babel-do-load-languages
  ;;  'org-babel-load-languages
  ;;  '(
  ;;    (emacs-lisp . t)
  ;;    (css . t)
  ;;    (js . t)
  ;;    (org . t)
  ;;    (python . t)
  ;;    (sed . t)
  ;;    (sql . t)
  ;;    (R . t)
  ;;    (go . t)
  ;;    )
  ;;  )

  ;; (use-package org-superstar
  ;;   :pin melpa
  ;;   :ensure t
  ;;   :init
  ;;   (setq org-superstar-configure-like-org-bullets t)
  ;;   (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
  ;;   )

  ;; (use-package org-bullets
  ;; 	:pin melpa
  ;; 	:ensure t
  ;; 	:init
  ;; 	(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;; 	)

  ;; (use-package toc-org
  ;;   :pin melpa
  ;;   :ensure t
  ;;   :init
  ;;   (add-hook 'org-mode-hook 'toc-org-mode)
  ;;   )

  ;; To make table which include chinese align as english words
  (require 'valign)
  (add-hook 'org-mode-hook #'valign-mode)
  )

;; prevent from random code in agenda time section when done
(add-hook 'org-mode-hook
(lambda ()
(set (make-local-variable 'system-time-locale) "C")))

;; auto insert space between chinese and english
(require 'pangu-spacing)
(global-pangu-spacing-mode 1)
(add-hook 'org-mode-hook
          '(lambda ()
             (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)))

;; To support drag/drop images and files. It seems that we need a emacs build
;; with imagemagick in order to resize inline image.
;;
;; C-c C-x C-v toggle inline image show/hide
;;
;; (use-package org-download
;;   :pin melpa
;;   :ensure t
;;   :after org
;;   :defer nil
;;   :custom
;;   (org-download-method 'directory)
;;   (org-download-image-dir "images")
;;   (org-download-heading-lvl nil)
;;   (org-download-timestamp "%Y%m%d-%H%M%S_")
;;   ;; (org-image-actual-width 500)
;;   ;; (org-download-screenshot-method imagemagick/convert)
;;   (org-image-actual-width nil)
;;   (org-download-image-attr-list
;;    '(
;; 	 "#+ATTR_ORG: :width 500"
;; 	 ;; "#+ATTR_HTML: :width 80% :align center"
;; 	 )
;;    )

;;   ;; (when (eq system-type 'windows-nt)
;;   ;; 	(org-download-screenshot-method "i_view64.exe /capture=4 /convert=\"%s\""))
;;   :config
;;   ;; (defun org-download-file-format-default (filename)
;;   ;; 	        (concat (file-name-sans-extension filename)
;;   ;;               "_"
;;   ;; 				(md5 (my::file-contents_head128 filename))
;;   ;; 				".png"
;;   ;; 				))
;;   ;; (defvar org-download-file-format-function #'org-download-file-format-default)
;;   (setq org-download-display-inline-images 'posframe)
;;   (setq org-download-screenshot-method "d:/xPortable/Tools/scrtool/scrtool.exe %s")
;;   (require 'org-download)
;;   :bind
;;   ("C-M-y" .  org-download-screenshot)
;;   )

;; (defun my-org-download-method (link)
;;   (let ((filename
;;          (file-name-nondirectory
;;           (car (url-path-and-query
;;                 (url-generic-parse-url link)))))
;;         (dirname (file-name-sans-extension (buffer-name)) ))
;;     ;; if directory not exist, create it
;;     (unless (file-exists-p dirname)
;;       (make-directory dirname))
;;     ;; return the path to save the download files
;;     (expand-file-name filename dirname)))

;; (setq-local org-download-method 'my-org-download-method)


;; capture file use my own tool
;; well 128 is not enough, so I increase it to 512 bytes
(defun my::file-contents_head128 (filename)
  "Return the contents of FILENAME."
  (with-temp-buffer
    (insert-file-contents filename nil 0 512)
    (buffer-string)))

;;
;; for image files, copy the original one to same directory as org file, rename
;; it to <org file name>_hash.<ext>, then add inline file link
;;
;; for other type files, copy to sub directory files/ , then add link
;;
(setq org_attachment_dir (file-name-as-directory "attachment"))
(defun my::build-filepath-img (org_path)
  (concat (file-name-directory buffer-file-name)
		  org_attachment_dir
		  (file-name-base buffer-file-name)
          ".img."
		  (substring (md5 (my::file-contents_head128 org_path)) 0 8)
          "."
		  (file-name-extension org_path)
		  ))

(defun my::build-filepath-file (org_path)
  (concat (file-name-directory buffer-file-name)
		  org_attachment_dir
		  (file-name-base buffer-file-name)
          ".file."
		  (file-name-nondirectory org_path)
		  ))

(defun my::org-insert-image-maxwidth (filename max_width)
  "Insert a image according to width"
  (interactive)
  (let* ((image-dimensions (image-size (create-image filename) :pixels))
		 (width (car image-dimensions))
		 (height (cdr image-dimensions)))
	(if (> width max_width)
		(insert (format "#+ATTR_ORG: :width %d\n" max_width))
	  nil)
	(insert (format "[[file:%s]]\n" filename))))

(defun my-dnd-func (event)
  (interactive "e")
  (goto-char (nth 1 (event-start event)))
  (x-focus-frame nil)
  (let* ((payload (car (last event)))
         (org_path (car payload))
         (img-regexp "\\(png\\|jp[e]?g\\)\\>")
		 (fpath (if (string-match img-regexp org_path)
					  (my::build-filepath-img org_path)
					(my::build-filepath-file org_path)
					))
		 (fname (file-relative-name fpath (file-name-directory buffer-file-name)))
		 )

    (make-directory (file-name-directory fpath) :parents)
	(if (not (file-exists-p fpath)) (copy-file org_path fpath))
    (cond
	 ((eq 'C-drag-n-drop (car event))
	  (if (string-match img-regexp fname)
		(my::org-insert-image-maxwidth fname 500)
		(insert (format "[[file:%s]]\n" fname)))
	  )

     ;; insert image link with caption
     ;; ((and  (eq 'C-drag-n-drop (car event))
     ;;        ;(eq 'file type)
     ;;        (string-match img-regexp fname))
     ;;  (insert "#+ATTR_ORG: :width 500\n")
     ;;  (insert (concat  "#+CAPTION: " fname "\n"))
     ;;  (insert (format "[[file:%s]]\n" fname))
      ;; (org-display-inline-images t t)
	 ;; )
     ;; regular drag and drop on file
     ;; ((eq 'file type)
     ;;  (insert (format "[[file %s]]\n" fname)))
     (t
      (error "I am not equipped for dnd on %s %s" fname payload)))))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "<drag-n-drop>") 'nil)
  (define-key org-mode-map (kbd "<C-drag-n-drop>") 'my-dnd-func)
  )


(defun my::build-filepath-screenshot ()
  (concat (file-name-directory buffer-file-name)
		  org_attachment_dir
		  (file-name-base buffer-file-name)
          ".sct."
		  (format-time-string "%Y%m%d_%H%M%S")
          "."
		  ".png"
		  ))

(defun my::org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq fname
        (my::build-filepath-screenshot))

  (shell-command "d:/xPortable/Tools/scrtool/scrtool.exe")
  (shell-command (concat "powershell -command \"Add-Type -AssemblyName System.Windows.Forms;if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {$image = [System.Windows.Forms.Clipboard]::GetImage();[System.Drawing.Bitmap]$image.Save('" fname "',[System.Drawing.Imaging.ImageFormat]::Png); Write-Output 'clipboard content saved as file'} else {Write-Output 'clipboard does not contain image data'}\""))
  (my::org-insert-image-maxwidth fname 500)
  (org-display-inline-images))

(global-set-key "\C-cs" ' my::org-screenshot)

;; M+x, read-color to list the colors
(setq org-emphasis-alist
  '(("*" (bold :foreground "Orange" ))
    ("/" italic)
    ("_" underline)
    ("=" (:background "maroon" :foreground "white"))
    ("~" (:background "deep sky blue" :foreground "MidnightBlue"))
    ("+" (:strike-through t))))

(setq org-hide-emphasis-markers nil)


;; To make image scroll smooth
(use-package iscroll
  :pin melpa
  :ensure t
  :after org
  :init
  (add-hook 'org-mode-hook (lambda () (iscroll-mode 1)))
  )

;; blog
;; (use-package ox-publish
;;   :pin melpa
;;   :defer t
;;   :init
;;   (setq org-html-validation-link nil)

;;   ;; nil: do not checking and always publish all file
;;   ;; Non-nil(t): use timestamp checking, default set 't'
;;   (setq org-publish-use-timestamps-flag t)

;;   (setq org-html-postamble t
;;         org-html-postamble-format
;;         '(("en" "<p class=\"postamble\">First created: %d <br />Last updated: %C <br />Power by %c</p>")))

;;   (setq org-publish-project-alist
;;         '(
;;           ;; notes component
;;           ("site-orgs"
;;            :base-directory "~/site/org"
;;            :base-extension "org"
;;            :html-link-home "index.html"
;;            :publishing-directory "~/site-html/"
;;            :recursive t
;;            :publishing-function org-html-publish-to-html
;;            :headline-levels 5
;;            :auto-sitemap t
;;            :sitemap-filename "sitemap.org"
;;            :sitemap-title "Sitemap"
;;            )
;;           ;; static component
;;           ("site-static"
;;            :base-directory "~/site/static/"
;;            :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
;;            :publishing-directory "~/site-html/static/"
;;            :recursive t
;;            :publishing-function org-publish-attachment
;;            )
;;           ;; publish component
;;           ("site" :components ("site-orgs" "site-static"))
;;           ))
;;   )

;; TODO
;; C-S-return create a TODO task
;; C-C-t/S-<right>/S-<left> switch from task status
;; S-M-<right>/S-M-<left> increase/decrease the current layer
;; A-S-return create next item in same layer
;; C-c C-c change checkbox[ ] status
;; [\/] or [\%] to record sub task's process
;;
;; reference https://www.zmonster.me/2015/07/15/org-mode-planning.html
;;
;; set key for agenda
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-todo-keywords
      '((sequence "TODO" "|" "DOING" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "#FF4500" :weight bold))
		("DOING" . (:foreground "#33cc33" :weight bold))
		("CANCEL" . (:foreground "black" :weight bold))
        ("DONE" . (:foreground "#27AE60" :weight bold))
		))

;;file to save todo items
;; Collect all .org from my Org directory and subdirs
;; (load-library "find-lisp")
;; (setq org-agenda-files (find-lisp-find-files "d:/xDoc/mysite/pool" "\.org$"))

;; (setq org-agenda-files (quote ("~/.emacs.d/todo.org")))
(setq my::gtd-dir (expand-file-name "gtd" my::xdoc-dir))
(setq agenda-file-todo (expand-file-name "todo.org" user-emacs-directory))
(setq org-agenda-files (list
						agenda-file-todo
						(expand-file-name "daily_2021.org" my::xdoc-dir)
						;; "d:/xDoc/mysite/pool/daily_2021.org"
						))

(global-set-key (kbd "C-c c") 'org-capture)

;; (setq org-capture-templates
;; 	  '(
;; 		("i" "inbox" entry (file+headline
;; 							(expand-file-name "inbox.org" my::gtd-dir)
;; 							"inbox")
;;          "* TODO [#B] %U %i%?" :empty-lines 1)
;;         ("s" "someday" entry (file+headline
;; 							  (expand-file-name "someday.org" my::gtd-dir)
;; 							  "some day")
;;          "* TODO [#C] %U %i%?" :empty-lines 1)
;; 		("g" "GTD" entry (file+datetree
;; 						  (expand-file-name "gtd.org" my::gtd-dir))
;; 		 "* TODO [#B] %U %i%?" :empty-lines 1)
;; 		))


;; ;;set priority range from A to C with default A
;; (setq org-highest-priority ?A)
;; (setq org-lowest-priority ?C)
;; (setq org-default-priority ?A)

;; ;;set colours for priorities
;; (setq org-priority-faces '((?A . (:foreground "#F0DFAF" :weight bold))
;;                            (?B . (:foreground "LightSteelBlue"))
;;                            (?C . (:foreground "OliveDrab"))))

;; ;;open agenda in current window
;; (setq org-agenda-window-setup (quote current-window))

;;capture todo items using C-c c t
;; (define-key global-map (kbd "C-c c") 'org-capture)
;; (setq org-capture-templates
;;       '(("t" "todo" entry (file+headline "~/.emacs.d/todo.org" "Tasks")
;;          "* TODO [#A] %?")))

(provide 'init-org)
