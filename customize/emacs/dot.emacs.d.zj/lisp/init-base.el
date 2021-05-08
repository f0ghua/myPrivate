;;------------------------------------------------------------------------------
;; basic setting (non-package setting)
;;------------------------------------------------------------------------------
;; encode
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)
(set-terminal-coding-system  'utf-8)
(set-keyboard-coding-system  'utf-8)
;; comment the following line, so that copy/paste from other encoding can work
;; (set-selection-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; recognize the encoding by following order
;; defined first is used last, so utf-8 is the priority 1 choose.
(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
;; (prefer-coding-system 'gb18030)
;; utf-16 is same as unicode on windows, it can be subdivided into utf-16le,
;; utf-16be, utf-16le-with-signature and so on.
(prefer-coding-system 'utf-16)
;; New file use utf-8 mode, end character depends on platform On windows, it's
;; utf-8-dos; on linux, utf-8-unix
(prefer-coding-system 'utf-8)

;; make 'rg' seaching chinese work in windows system
(when (eq system-type 'windows-nt)
  (set-default 'process-coding-system-alist
               '(("[pP][lL][iI][nN][kK]" gbk-dos . gbk-dos)
                 ("[cC][mM][dD][pP][rR][oO][xX][yY]" utf-8-dos . gbk-dos)
                 ("[rR][gG]" utf-8-dos . gbk-dos))))

(setq confirm-kill-emacs  'y-or-n-p
      auto-save-default    nil
      mouse-yank-at-point  t
      make-backup-files    nil
      indent-tabs-mode     nil
      create-lockfiles     nil)


(add-hook 'text-mode-hook
          '(lambda ()
             (setq indent-tabs-mode nil)
             (setq tab-width 4)))
(setq indent-line-function (quote insert-tab))

(setq-default tab-width 4)
(fset 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode nil)
(electric-indent-mode 1)
;; (electric-quote-mode 1)

(save-place-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq visible-bell nil)
(setq ring-bell-function 'ignore)

(global-auto-revert-mode t)

(provide 'init-base)
