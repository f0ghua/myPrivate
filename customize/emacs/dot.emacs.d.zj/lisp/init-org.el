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
  (setq org-image-actual-width 500)
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
  (setq org-todo-keywords
        '((sequence "TODO(t)" "BLOCK(b)" "|" "DONE(d)" "CANCELD(d)")))
  (setq org-agenda-files '("~/site/org/gtd"))

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

  ;; (require 'valign)
  ;; (add-hook 'org-mode-hook #'valign-mode)
  )

;; To support drag/drop images and files. It seems that we need a emacs build
;; with imagemagick in order to resize inline image.
;;
;; C-c C-x C-v toggle inline image show/hide
;;
(use-package org-download
  :pin melpa
  :ensure t
  :after org
  :defer nil
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  ;; (org-image-actual-width 500)
  ;; (org-image-actual-width nil)
  ;; (org-download-screenshot-method imagemagick/convert)
  :bind
  ("C-M-y" . org-download-screenshot)
  :config
  (require 'org-download))

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

(provide 'init-org)
