;; https://github.com/dkogan/xcscope.el
;;
;; All keybindings use the “C-c s” prefix:
;;
;; C-c s a	Set initial directory.
;; C-c s A	Unset initial directory.
;;
;; C-c s s	Find symbol.
;; C-c s d	Find global definition.
;; C-c s g	Find global definition (alternate binding).
;; C-c s G	Find global definition without prompting.
;; C-c s c	Find functions calling a function.
;;
;; On linux, install gnu global with apt-get install global
;;
(use-package xcscope
  :pin melpa
  :ensure t
  :config
  (setq cscope-program "gtags-cscope")
  (require 'xcscope)
  (cscope-setup)
  )

(provide 'init-xcscope)
