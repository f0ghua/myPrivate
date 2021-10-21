
(use-package smart-compile
  :pin melpa
  :ensure t
  :config
  (add-to-list 'smart-compile-alist
			   '("\\.tex\\'" .
				 (call-interactively 'TeX-command-run-all)))
  (add-to-list 'smart-compile-alist
			   '("\\.org\\'" . "pandoc -o %n.pdf --template eisvogel --listings --pdf-engine \"xelatex\" -V CJKmainfont=\"Microsoft YaHei\"  %f"))
  )


;; Because typing "M-x compile" all the time is annoying
(global-set-key (kbd "<f12>") 'smart-compile)

(provide 'init-export)
