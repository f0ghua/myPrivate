;;----------------------------------------------------------------------------
;; edit
;;----------------------------------------------------------------------------

;; GNU coding standards requests a width of 79 characters, while most
;; people use a width of 80. Emacs default use a value of 70.
;;
;; https://www.gnu.org/prep/standards/standards.html#Formatting
;; Auto-wrap at 80 characters
(setq-default fill-column 80)
(setq-default auto-fill-function 'do-auto-fill)
(turn-on-auto-fill)
;; Disable auto-fill-mode in programming mode
(add-hook 'prog-mode-hook (lambda () (auto-fill-mode -1)))

;; make 'rg' seaching chinese work in windows system
(when (eq system-type 'windows-nt)
  (set-default 'process-coding-system-alist
               '(("[pP][lL][iI][nN][kK]" gbk-dos . gbk-dos)
                 ("[cC][mM][dD][pP][rR][oO][xX][yY]" utf-8-dos . gbk-dos)
                 ("[rR][gG]" utf-8-dos . gbk-dos))))

(use-package undo-tree
  :pin gnu
  :ensure t
  :bind ("C-x u" . undo-tree-visualize)
  )

(use-package ivy
  :pin melpa
  :ensure t
  :bind (("<f9> b" . ivy-switch-buffer)
		 ("C-x C-b" . ivy-switch-buffer))
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d-%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode 1)
  )

(use-package swiper
  :pin melpa
  :ensure t
  :bind (("M-s ." . swiper-isearch-thing-at-point)))

(use-package counsel
  :pin melpa
  :ensure t
  :bind (("M-s [" . counsel-rg)
		 ("M-s ]" . counsel-git)
		 ("<f9> x" . counsel-M-x)
		 ("M-y" . counsel-yank-pop)
		 ("<f9> f" . counsel-find-file)
		 ("C-x C-f" . counsel-find-file)
		 )
  :config
  (setq counsel-ag-base-command "ag --vimgrep -i %s")
  (setq counsel-rg-base-command
		"rg -i -M 120 --no-heading --line-number --color never %s .")
  )

(provide 'init-edit)