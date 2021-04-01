
;; Set font size. Font size is set to my:font-size/10
(defvar my:font-size 90)
(defvar my:line-font-size 90)

;; Set my:byte-compile-init to t if you want to compile the init file.
;; This will improve startup time by ~2-3 times, but makes getting certain
;; packages to load correctly more difficult. Most of the packages work
;; correctly with a byte-compiled init file.
(defvar my:byte-compile-init nil)

;; Specify the search backend. Must be either:
;; - ivy https://github.com/abo-abo/swiper
;; - selectrum https://github.com/raxod502/selectrum emacs26 is needed
(defvar my:search-backend "ivy")

;; Set my:use-prescient to t if you want to use prescient for sorting
;;
;; https://github.com/raxod502/prescient.el
(defvar my:use-prescient t)

;; A list of modes for which to disable whitespace mode
(defvar my:ws-disable-modes '(magit-mode help-mode buffer-menu-mode))

;; Choose ycmd or lsp for C/C++ completion. lsp or ycmd
(defvar my:cxx-completer "ycmd")

;; Set to t if you want to use ycmd-goto in C/C++/Rust mode
(defvar my:use-ycmd-goto nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I don't care to see the splash screen
(setq inhibit-splash-screen t)

;; Hide the scroll bar
(scroll-bar-mode -1)
;; Make mode bar small
(set-face-attribute 'mode-line nil  :height my:line-font-size)
;; Set the header bar font
(set-face-attribute 'header-line nil  :height my:line-font-size)
;; Set default window size and position
;; (setq default-frame-alist
;;       '((top . 0) (left . 0) ;; position
;;         (width . 110) (height . 70) ;; size
;;         ))

;; Enable line numbers on the LHS
(global-linum-mode t)

;; Set the font to size 9 (90/10).
;; (set-face-attribute 'default nil :height my:font-size)

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set packages to install
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
;;                          ("melpa" . "https://melpa.org/packages/")
;;                          ("gnu" . "http://elpa.gnu.org/packages/")))

(setq package-archives
      '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
	("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
        ("org"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
        ))

;; use following line to replace for no internet environment
;; (setq package-archives
;;       '(("myelpa" . "~/.emacs.d/myelpa/")
;;         ("org" . "~/.emacs.d/myelpa/")
;;         ))

;; Disable package initialize after us.  We either initialize it
;; anyway in case of interpreted .emacs, or we don't want slow
;; initizlization in case of byte-compiled .emacs.elc.
(setq package-enable-at-startup nil)
;; Disable magically opening remote files during init
(defvar file-name-handler-alist-old file-name-handler-alist)
(setq file-name-handler-alist nil)
;; Ask package.el to not add (package-initialize) to .emacs.
(setq package--init-file-ensured t)
;; set use-package-verbose to t for interpreted .emacs,
;; and to nil for byte-compiled .emacs.elc
(eval-and-compile
  (setq use-package-verbose (not (bound-and-true-p byte-compile-current-file))))
;; Add the macro generated list of package.el loadpaths to load-path.
(mapc #'(lambda (add) (add-to-list 'load-path add))
      (eval-when-compile
        (require 'package)
        (package-initialize)
        ;; Install use-package if not installed yet.
        (unless (package-installed-p 'use-package)
          (package-refresh-contents)
          (package-install 'use-package))
        ;; (require 'use-package)
        (let ((package-user-dir-real (file-truename package-user-dir)))
          ;; The reverse is necessary, because outside we mapc
          ;; add-to-list element-by-element, which reverses.
          (nreverse
           (apply #'nconc
                  ;; Only keep package.el provided loadpaths.
                  (mapcar #'(lambda (path)
                              (if (string-prefix-p package-user-dir-real path)
                                  (list path)
                                nil))
                          load-path))))))

;; setup use-package
(eval-when-compile
  (require 'use-package))
(use-package bind-key
  :ensure t)
;; so we can (require 'use-package) even in compiled emacs to e.g. read docs
(use-package use-package
  :commands use-package-autoload-keymap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; async - library for async/thread processing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package async
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org - make sure use the one from elpa instead of built-in
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :ensure org
  :pin org)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Support converting org to confluence format
(require 'ox-confluence)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-package-update
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Auto update packages once a week
;; (use-package auto-package-update
;;   :ensure t
;;   :commands (auto-package-update-maybe)
;;   :config
;;   (setq auto-package-update-delete-old-versions t)
;;   (setq auto-package-update-hide-results t)
;;   (auto-package-update-maybe)
;;   (add-hook 'auto-package-update-before-hook
;;           (lambda () (message "I will update packages now")))
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; By default Emacs triggers garbage collection at ~0.8MB which makes
;; startup really slow. Since most systems have at least 64MB of memory,
;; we increase it during initialization.
(setq gc-cons-threshold 128000000)
(add-hook 'after-init-hook
          #'(lambda ()
              ;; restore after startup
              (setq gc-cons-threshold 8000000
                    file-name-handler-alist file-name-handler-alist-old
                    )))

;; Extra plugins and config files are stored here
(if (not (file-directory-p "~/.emacs.d/plugins/"))
    (make-directory "~/.emacs.d/plugins/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-theme 'zenburn t)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode t)
;; Overwrite region selected
(delete-selection-mode t)
;; Show column numbers by default
(setq column-number-mode t)

;; Prevent emacs from creating a bckup file filename~
(setq make-backup-files nil)
;; Settings for searching
(setq-default case-fold-search t ;case insensitive searches by default
              search-highlight t) ;hilit matches when searching
;; Highlight the line we are currently on
(global-hl-line-mode t)
;; Disable the toolbar at the top since it's useless
(if (functionp 'tool-bar-mode) (tool-bar-mode -1))

;; Auto-wrap at 80 characters
(setq-default auto-fill-function 'do-auto-fill)
(setq-default fill-column 80)
(turn-on-auto-fill)
;; Disable auto-fill-mode in programming mode
(add-hook 'prog-mode-hook (lambda () (auto-fill-mode -1)))

;; We don't want to type yes and no all the time so, do y and n
(defalias 'yes-or-no-p 'y-or-n-p)
;; Disable the horrid auto-save
(setq auto-save-default nil)

;; Disable the menu bar since we don't use it, especially not in the
;; terminal
(when (and (not (eq system-type 'darwin)) (fboundp 'menu-bar-mode))
  (menu-bar-mode -1))

;; Don't ring the bell
(setq ring-bell-function 'ignore)

;; Highlight some keywords in prog-mode
(add-hook 'prog-mode-hook
          (lambda ()
            ;; Highlighting in cmake-mode this way interferes with
            ;; cmake-font-lock, which is something I don't yet understand.
            (when (not (derived-mode-p 'cmake-mode))
              (font-lock-add-keywords
               nil
               '(("\\<\\(FIXME\\|TODO\\|BUG\\|DONE\\)"
                  1 font-lock-warning-face t))))))

(add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)
(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'prog-mode)
    (delete-trailing-whitespace)))

;; Prevent from new line indent when press RET
(setq electric-indent-mode nil) ; globally

;; set org mode src highlighting by default
(setq org-src-fontify-natively t)

(defun fill-region-paragraphs (b e &optional justify)
  "Fill region between b and e like `fill-paragraph' for each paragraph in region
instead of `fill-region' which is implied by the original version of `fill-paragraph'.
Justify when called with prefix arg."
  (interactive "r\nP")
  (save-excursion
    (goto-char b)
    (while (< (point) e)
      (fill-paragraph justify)
      (forward-paragraph)
      )))
(global-set-key (kbd "C-c f") 'fill-region-paragraphs)

;; Global Keyboard Shortcuts
;; Set help to C-?
(global-set-key (kbd "<f11>") 'beginning-of-buffer)
(global-set-key (kbd "C-x C-b") 'ivy-switch-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Automatically compile and save ~/.emacs.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (when my:byte-compile-init
;;   (defun byte-compile-init-files (file)
;;     "Automatically compile FILE."
;;     (interactive)
;;     (save-restriction
;;       ;; Suppress the warning when you setq an undefined variable.
;;       (if (>= emacs-major-version 23)
;;           (setq byte-compile-warnings '(not free-vars obsolete))
;;         (setq byte-compile-warnings
;;               '(unresolved
;;                 callargs
;;                 redefine
;;                 obsolete
;;                 noruntime
;;                 cl-warnings
;;                 interactive-only)))
;;       (byte-compile-file (expand-file-name file))))

;;   ;; Add a post-save hook that checks if ~/.emacs.el exists and if the file
;;   ;; name of the current buffer is ~/.emacs.el or the symbolically linked
;;   ;; file.
;;   (add-hook
;;    'after-save-hook
;;    (function
;;     (lambda ()
;;       (when (and (string= (file-truename "~/.emacs.el")
;;                           (file-truename (buffer-file-name)))
;;                  (file-exists-p "~/.emacs.el"))
;;         (byte-compile-init-files "~/.emacs.el")))))

;;   ;; Byte-compile again to ~/.emacs.elc if it is outdated. We use file-truename
;;   ;; to follow symbolic links so that ~/.emacs.el can be symbolically linked to
;;   ;; the location where the .emacs.el is stored.
;;   (when (file-newer-than-file-p
;;          (file-truename "~/.emacs.el")
;;          (file-truename "~/.emacs.elc"))
;;     (byte-compile-init-files "~/.emacs.el")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Select search backend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar my:use-ivy nil)
(defvar my:use-selectrum nil)
(if (string-match "ivy" my:search-backend)
    (setq my:use-ivy t)
  (if (string-match "selectrum" my:search-backend)
      (setq my:use-selectrum t)
    (warn "my:search-backend must be to 'ivy' or 'selectrum'")
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ivy config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when my:use-ivy
  (use-package ivy
    :ensure t
    :diminish ivy-mode
    :commands (ivy-mode)
    :config
    (when my:byte-compile-init
      (require 'ivy))
    (ivy-mode t)
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    (setq ivy-wrap t)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    ;; Show #/total when scrolling buffers
    (setq ivy-count-format "%d/%d ")
    )

  ;; Using prescient for sorting results with ivy:
  ;; https://github.com/raxod502/prescient.el
  (when my:use-prescient
    (use-package ivy-prescient
      :ensure t
      :after (counsel)
      :config
      (ivy-prescient-mode t)
      (prescient-persist-mode t)
      )
    )

  (use-package swiper
    :ensure t
    )

  (use-package counsel
    :ensure t
    :bind (("M-x" . counsel-M-x)
           ("C-x C-f" . counsel-find-file)
           ("<f1> f" . counsel-describe-function)
           ("<f1> v" . counsel-describe-variable)
           ("<f1> l" . counsel-find-library)
           ("C-c i" . counsel-info-lookup-symbol)
           ("C-c u" . counsel-unicode-char)
           ("C-c C-s" . buffer-dependent-swiper)
           ("C-c C-r" . buffer-dependent-swiper)
           ("C-c g" . counsel-git-grep)
           ("C-c j" . counsel-git)
           ("C-c k" . counsel-ag)
           ("C-c r" . counsel-rg)
           ("C-x l" . counsel-locate)
           :map minibuffer-local-map
           ("C-r" . counsel-minibuffer-add)
           )
    :config
    (if (executable-find "rg")
        ;; use ripgrep instead of grep because it's way faster
        (setq counsel-grep-base-command
              "rg -i -M 120 --no-heading --line-number --color never %s %s"
              counsel-rg-base-command
              "rg -i -M 120 --no-heading --line-number --color never %s .")
      (warn "\nWARNING: Could not find the ripgrep executable. It "
            "is recommended you install ripgrep."))

    ;; Switch whether we use swiper or counsel-grep depending on the major mode.
    ;; This is because for certain themes font highlighting is very expensive
    ;; in some modes (e.g. C++ mode)
    (defun buffer-dependent-swiper (&optional initial-input)
      (interactive)
      (if (or (not buffer-file-name)
              (ignore-errors
                (file-remote-p (buffer-file-name)))
              (if (or (eq major-mode 'org-mode)
                      (eq major-mode 'c++-mode))
                  (<= (buffer-size) 50000)
                ;; The value 300000 is the default number of characters
                ;; before falling back to counsel-grep from swiper.
                (<= (buffer-size) 300000)))
          (swiper initial-input)
        (progn
          (when (file-writable-p buffer-file-name)
            (save-buffer))
          (counsel-grep initial-input))))
    )

  (use-package counsel-projectile
    :ensure t
    :after (:all counsel projectile)
    :bind (("C-x M-f" . counsel-projectile-find-file-dwim))
    :init
    (eval-when-compile
      ;; Silence missing function warnings
      (declare-function counsel-projectile-mode "counsel-projectile.el"))
    :config
    (counsel-projectile-mode))

  ;; Use universal ctags to build the tags database for the project.
  ;; When you first want to build a TAGS database run 'touch TAGS'
  ;; in the root directory of your project.
  (use-package counsel-etags
    :ensure t
    :init
    (eval-when-compile
      ;; Silence missing function warnings
      (declare-function counsel-etags-virtual-update-tags "counsel-etags.el")
      (declare-function counsel-etags-guess-program "counsel-etags.el")
      (declare-function counsel-etags-locate-tags-file "counsel-etags.el"))
    :bind (
           ("M-." . counsel-etags-find-tag-at-point)
           ("M-t" . counsel-etags-grep-symbol-at-point))
    :config
    ;; Ignore files above 800kb
    (setq counsel-etags-max-file-size 800)
    ;; Ignore build directories for tagging
    (add-to-list 'counsel-etags-ignore-directories '"build*")
    (add-to-list 'counsel-etags-ignore-directories '".vscode")
    (add-to-list 'counsel-etags-ignore-filenames '".clang-format")
    ;; Don't ask before rereading the TAGS files if they have changed
    (setq tags-revert-without-query t)
    ;; Don't warn when TAGS files are large
    (setq large-file-warning-threshold nil)
    ;; How many seconds to wait before rerunning tags for auto-update
    (setq counsel-etags-update-interval 180)
    ;; Set up auto-update
    (add-hook
     'prog-mode-hook
     (lambda () (add-hook 'after-save-hook
                          (lambda ()
                            (counsel-etags-virtual-update-tags)))))

    ;; The function provided by counsel-etags is broken (at least on Linux)
    ;; and doesn't correctly exclude directories, leading to an excessive
    ;; amount of incorrect tags. The issue seems to be that the trailing '/'
    ;; in e.g. '*dirname/*' causes 'find' to not correctly exclude all files
    ;; in that directory, only files in sub-directories of the dir set to be
    ;; ignore.
    (defun my-scan-dir (src-dir &optional force)
      "Create tags file from SRC-DIR. \
     If FORCE is t, the commmand is executed without \
     checking the timer."
      (let* ((find-pg (or
                       counsel-etags-find-program
                       (counsel-etags-guess-program "find")))
             (ctags-pg (or
                        counsel-etags-tags-program
                        (format "%s -e -L" (counsel-etags-guess-program
                                            "ctags"))))
             (default-directory src-dir)
             ;; run find&ctags to create TAGS
             (cmd (format
                   "%s . \\( %s \\) -prune -o -type f -not -size +%sk %s | %s -"
                   find-pg
                   (mapconcat
                    (lambda (p)
                      (format "-iwholename \"*%s*\"" p))
                    counsel-etags-ignore-directories " -or ")
                   counsel-etags-max-file-size
                   (mapconcat (lambda (n)
                                (format "-not -name \"%s\"" n))
                              counsel-etags-ignore-filenames " ")
                   ctags-pg))
             (tags-file (concat (file-name-as-directory src-dir) "TAGS"))
             (doit (or force (not (file-exists-p tags-file)))))
        ;; always update cli options
        (when doit
          (message "%s at %s" cmd default-directory)
          (async-shell-command cmd)
          (visit-tags-table tags-file t))))

    (setq counsel-etags-update-tags-backend
          (lambda ()
            (interactive)
            (let* ((tags-file (counsel-etags-locate-tags-file)))
              (when tags-file
                (my-scan-dir (file-name-directory tags-file) t)
                (run-hook-with-args
                 'counsel-etags-after-update-tags-hook tags-file)
                (unless counsel-etags-quiet-when-updating-tags
                  (message "%s is updated!" tags-file))))))
    )

  (use-package flyspell-correct-ivy
    :ensure t
    :after (:all flyspell ivy))

  ;; (use-package lsp-ivy
  ;;   :ensure t
  ;;   :diminish
  ;;   :after (:all lsp-mode ivy))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Selectrum config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when my:use-selectrum
  (use-package selectrum
    :ensure t
    :config
    (selectrum-mode t)
    (when my:use-prescient
      (use-package selectrum-prescient
        :ensure t
        :config
        (selectrum-prescient-mode t)
        (prescient-persist-mode t)))
    )

  (use-package ctrlf
    :ensure t
    :bind (("C-s" . ctrlf-forward-fuzzy-regexp)
           ("C-r" . ctrlf-backward-fuzzy-regexp)
           )
    :config
    (ctrlf-mode t)
    ;; It seems sometimes the ctrlf-mode-bindings are reloaded overriding our
    ;; bindings above. To ensure this isn't an issue, we set everything to
    ;; use fuzzy-regexp
    (setq ctrlf-mode-bindings
          '(("C-s"   . ctrlf-forward-fuzzy-regexp)
            ("C-r"   . ctrlf-backward-fuzzy-regexp)))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up GNU Global Tags (ggtags)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (executable-find "global")
  (use-package ggtags
    :ensure t
    :diminish ggtags-mode
    :defer t
    :commands (ggtags-mode)
    :init
    ;; More complicated hook logic so we don't interfere with LSP
    ;; or ycmd-goto
    (when (and (not (and (string-equal my:cxx-completer "lsp")
                         my:use-lsp-goto))
               (not (and (string-equal my:cxx-completer "ycmd")
                         my:use-ycmd-goto)))
      (add-hook 'c-mode-common-hook
                (lambda ()
                  (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                    (ggtags-mode t)))))
    :config
    ;; Don't try to update GTAGS on each save;
    ;; makes the system sluggish for huge projects.
    (setq ggtags-update-on-save t)
    ;; Don't auto-highlight tag at point.. makes the system really sluggish!
    (setq ggtags-highlight-tag nil)
    ;; Enabling nearness requires global 6.5+
    (setq ggtags-sort-by-nearness t)
    (setq ggtags-navigation-mode-lighter nil)
    (setq ggtags-mode-line-project-name nil)
    (setq ggtags-oversize-limit (* 30 1024 1024)) ; 30 MB
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python mode settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq-default python-indent 4)
;; (setq-default python-indent-offset 4)
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (setq tab-width 4)))
;; (setq-default pdb-command-name "python -m pdb")
;; (use-package elpy
;;   :ensure t
;;   :commands (elpy-enable)
;;   :after python
;;   :config
;;   (elpy-enable)
;;   )

;; (use-package yapfify
;;   :ensure t
;;   :hook (python-mode . yapf-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clang-format
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format can be triggered using C-c C-f
;; Create clang-format file using google style
;; clang-format -style=google -dump-config > .clang-format
(use-package clang-format
  :ensure t
  :bind (("C-c C-f" . clang-format-region))
  )

;; Change tab key behavior to insert spaces instead
(setq-default indent-tabs-mode nil)

;; Set the number of spaces that the tab key inserts (usually 2 or 4)
(setq c-basic-offset 4)
;; Set the size that a tab CHARACTER is interpreted as
;; (unnecessary if there are no tab characters in the file!)
(setq tab-width 4)

;; We want to be able to see if there is a tab character vs a space.
;; global-whitespace-mode allows us to do just that.
;; Set whitespace mode to only show tabs, not newlines/spaces.
(use-package whitespace
  :ensure t
  :diminish global-whitespace-mode
  :diminish whitespace-mode
  :init
  (eval-when-compile
      ;; Silence missing function warnings
      (declare-function global-whitespace-mode "whitespace.el"))
  :config
  (setq whitespace-style '(face lines-tail trailing tabs tab-mark))
  )

;; Turn on whitespace mode globally except in magit-mode
(define-global-minor-mode my-global-whitespace-mode whitespace-mode
  (lambda ()
    (let* ((allow-ws-mode t))
      (progn
        (dolist (element my:ws-disable-modes)
          (when (derived-mode-p element)
            (setq allow-ws-mode nil)
            )
          )
        (when allow-ws-mode
          (whitespace-mode t))))
    ))
(my-global-whitespace-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: lsp (language server protocol mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A code completion, syntax checker, etc. engine that uses the LSP to
;; talk to completion servers.
;; https://github.com/emacs-lsp/lsp-mode
;; (use-package lsp-mode
;;   :ensure t
;;   :hook (;; Python on Linux/mac OS is pyls (python language server)
;;          (python-mode . lsp)
;;          ;; Rust RLS (Rust Language Server) https://github.com/rust-lang/rls
;;          (rust-mode . lsp)
;;          ;; Bash uses bash-language-server
;;          ;; https://github.com/mads-hartmann/bash-language-server
;;          (shell-mode . lsp)
;;          )
;;   :init
;;   ;; Disable yasnippet. We re-enable when yasnippet is loaded.
;;   (defvar lsp-enable-snippet nil)
;;   (use-package lsp-ui
;;     :ensure t
;;     :after lsp-mode
;;     :hook (lsp-mode . lsp-ui-mode)
;;     :config
;;     ;; Use find references and definitions key bindings instead of CTags.
;;     (defun set-local-keybinds-lsp-ui ()
;;       "Sets keybindings for lsp mode"
;;       (interactive)
;;       (local-set-key (kbd "M-.") 'lsp-ui-peek-find-definitions)
;;       (local-set-key (kbd "M-?") 'lsp-ui-peek-find-references)
;;       )
;;     (add-hook 'c-mode-common-hook 'set-local-keybinds-lsp-ui)
;;     (add-hook 'python-mode-hook 'set-local-keybinds-lsp-ui)
;;     (add-hook 'rust-mode-hook 'set-local-keybinds-lsp-ui)
;;     (add-hook 'shell-mode-hook 'set-local-keybinds-lsp-ui)
;;     )

;;   ;; Use as C++ completer if desired. We use the clangd backend.
;;   (when (string-equal my:cxx-completer "lsp")
;;     (add-hook 'c-mode-common-hook #'lsp)
;;     ;;
;;     (add-hook 'lsp-mode-hook
;;               '(lambda ()
;;                  (when my:use-lsp-goto
;;                    (local-set-key (kbd "M-.") 'lsp-find-definition)))))

;;   :config
;;   (when my:byte-compile-init
;;       (dolist (lsp-file my:lsp-explicit-load-files)
;;         (require lsp-file)))
;;   ;; Set GC threshold to 25MB since LSP mode is very memory hungry and
;;   ;; produces a lot of garbage
;;   (setq gc-cons-threshold 25000000)

;;   ;; Increase the amount of data which Emacs reads from the process. The emacs
;;   ;; default is too low 4k considering that the some of the language server
;;   ;; responses are in 800k - 3M range. Set to 1MB
;;   (setq read-process-output-max (* 1024 1024))

;;   ;; Extra flags passed to clangd. See 'clangd --help' for info
;;   (defvar lsp-clients-clangd-args '("--clang-tidy"
;;                                     "--fallback-style=google"
;;                                     "-j=4"
;;                                     "--enable-config"
;;                                     "--suggest-missing-includes"
;;                                     "--pch-storage=memory"))
;;   (setq lsp-enable-on-type-formatting nil)
;;   ;; (setq lsp-before-save-edits nil)
;;   ;; Use flycheck instead of flymake
;;   (setq lsp-prefer-flymake nil)
;;   ;; Change prefix to C-c y (like ycmd)
;;   (define-key lsp-mode-map (kbd "C-c y") lsp-command-map)

;;   ;; Set keybindings
;;   (local-set-key (kbd "C-c y n") 'lsp-rename)
;;   (local-set-key (kbd "C-c y o") 'lsp-restart-workspace)
;;   (local-set-key (kbd "C-c y c") 'lsp-disconnect)
;;   (local-set-key (kbd "C-c y f") 'lsp-format-region)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up code completion with company
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :ensure t
  :diminish company-mode
  :hook (prog-mode . global-company-mode)
  :commands (company-mode company-indent-or-complete-common)
  :init
  (setq company-minimum-prefix-length 2
        company-tooltip-limit 14
        company-tooltip-align-annotations t
        company-require-match 'never
        company-global-modes '(not erc-mode message-mode help-mode gud-mode)

        ;; These auto-complete the current selection when
        ;; `company-auto-complete-chars' is typed. This is too magical. We
        ;; already have the much more explicit RET and TAB.
        company-auto-complete nil
        company-auto-complete-chars nil

        ;; Only search the current buffer for `company-dabbrev' (a backend that
        ;; suggests text your open buffers). This prevents Company from causing
        ;; lag once you have a lot of buffers open.
        company-dabbrev-other-buffers nil

        ;; Make `company-dabbrev' fully case-sensitive, to improve UX with
        ;; domain-specific words with particular casing.
        company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil)

  :config
  (defvar my:company-explicit-load-files '(company company-capf))
  (when my:byte-compile-init
    (dolist (company-file my:company-explicit-load-files)
      (require company-file)))
  ;; Zero delay when pressing tab
  (setq company-idle-delay 0)
  ;; remove backends for packages that are dead
  (setq company-backends (delete 'company-eclim company-backends))
  (setq company-backends (delete 'company-clang company-backends))
  (setq company-backends (delete 'company-xcode company-backends))
  )

;; Use prescient for sorting results with company:
;; https://github.com/raxod502/prescient.el
(when my:use-prescient
  (use-package company-prescient
    :ensure t
    :after company
    :config
    (company-prescient-mode t)
    (prescient-persist-mode t)
    )
  )

;; On windows, counsel-rg not works without following settings
(ivy-prescient-mode 1) ;; First, ivy-prescient-re-builder is assigned for counsel-rg.
(setf (alist-get 'counsel-rg ivy-re-builders-alist) #'ivy--regex-plus) ;; Second, overwrite ivy-prescient-re-builder by ivy--regex-plus


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto added by emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends (quote (ascii html icalendar latex odt confluence)))
 '(package-selected-packages
   (quote
    (org-bullets zenburn-theme org xcscope zzz-to-char yasnippet-snippets yapfify yaml-mode ws-butler writegood-mode winum which-key web-mode vlf visual-regexp-steroids use-package-hydra undo-tree string-inflection spacemacs-theme sourcerer-theme smart-hungry-delete skewer-mode rust-mode rg realgud rainbow-delimiters powerline origami multiple-cursors modern-cpp-font-lock lua-mode json-mode jetbrains-darcula-theme ivy-prescient hydra hungry-delete google-c-style gitignore-mode git-timemachine ggtags forge flyspell-correct-ivy flycheck-ycmd flycheck-rust flycheck-pyflakes evil-dvorak evil-collection esup elpy ein edit-server doom-themes diminish diff-hl cuda-mode ctrlf counsel-projectile counsel-etags company-ycmd company-prescient cmake-font-lock clang-format beacon autopair auto-package-update auctex async all-the-icons))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
