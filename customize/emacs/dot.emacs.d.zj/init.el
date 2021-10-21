
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
		("melpa" . "https://melpa.org/packages/")
		("melpa-stable" . "http://stable.melpa.org/packages/")
		("org" . "https://orgmode.org/elpa/")))

;; use http proxy
;; (setq url-proxy-services
;;      '(("http" . "127.0.0.1:1088")
;;        ("https" . "127.0.0.1:1088")))

;; in china
(setq package-archives
      '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
		("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
		("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
		("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

;; use following line to replace for no internet environment
;; (setq package-archives
;;       '(("gnu" . "~/.emacs.d/myelpa/")
;; 		("melpa" .  "~/.emacs.d/myelpa/")
;; 		("melpa-stable" . "~/.emacs.d/myelpa/")
;; 		("org" . "~/.emacs.d/myelpa/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-verbose t)
  (setq use-package-always-pin t)
  (setq use-package-compute-statistics t)
  (setq use-package-hook-name-suffix nil)
  )

(eval-when-compile
  (require 'use-package))

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(add-to-list 'load-path
             (expand-file-name "lisp"
                               user-emacs-directory))
(add-to-list 'load-path
             (expand-file-name "site-lisp"
                               user-emacs-directory))

(setq my::xdoc-dir "d:/xDoc/mysite/pool")

;;
;; set PATH env
;;
(defun wttr/prepend-to-exec-path (path)
  "prepand the path to the emacs intenral `exec-path' and \"PATH\" env variable.
Return the updated `exec-path'"
  (setenv "PATH" (concat (expand-file-name path)
                         path-separator
                         (getenv "PATH")))
  (setq exec-path
        (cons (expand-file-name path)
              exec-path)))

;; update exec path
(mapc #'wttr/prepend-to-exec-path
	  (reverse
	   '(
		 "d:/xPortable/iview458_x64"
		 )))

(require 'init-base)
(require 'init-keybinding)
(require 'init-ui)
(require 'init-edit)
;; (require 'init-env)
;; (require 'init-flycheck)
;; (require 'init-lsp-lang)
;; (require 'init-markdown)
;; (require 'init-nginx)
;; (require 'init-db)
;; (require 'init-docker)
;; (require 'init-web)
;; (require 'init-yaml)
;; (require 'init-plantuml)
(require 'init-org)
(require 'init-export)
;;(require 'init-tex)
;(require 'init-latex)

;; variables configured via the interactive 'customize' interface
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
