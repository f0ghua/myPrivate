;; C-c C-e l o
;;
;; # -*- coding: utf-8 -*-
;; #+LATEX_COMPILER:xelatex
;; #+LATEX_CLASS:org-article
;; #+OPTIONS: toc:nil
;
;; To prevent from table overflow
;;
;; #+ATTR_LATEX: :environment longtable :align l|lp{3cm}r|l
;; | ..... | ..... |
;; | ..... | ..... |

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
	   '("~/bin"
		 "d:/expandDrive/c/texlive/2021/bin/win32/"
		 )))

;;org-export latex
(setq org-alphabetical-lists t)
  ;;(setq org-latex-to-pdf-process (list "latexmk -pdf %f"))
;;(require 'ox-bibtex)

;; -shell-escape is used for minted
;; -8bit is used to prevent from showing TAB as ^^
(setq org-latex-pdf-process
	'("xelatex -8bit -shell-escape -interaction nonstopmode %f"
	  "bibtex %b"
	  "xelatex -8bit -shell-escape -interaction nonstopmode %f"
	  "xelatex -8bit -shell-escape -interaction nonstopmode %f"
	  "rm -fr %b.out %b.log %b.tex %b.brf %b.bbl auto"
	  ))

(setq org-latex-compiler "xelatex")
(require 'ox-latex)

(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)
(setq org-latex-minted-options
      '(
		("breaklines=true")
        ("breakanywhere=true")
		;; ("bgcolor=LightGray")
		("linenos=true")
		;; ("mathescape=true")
		;; ("numbersep=5pt")
		;; ("gobble=2")
		("frame=lines")
		;; ("framesep=2mm")
		;; ("baselinestretch=1.2")
		))

(add-to-list 'org-latex-classes
	       '("org-dissertation"
		 "\\documentclass[UTF8,twoside,a4paper,12pt,openright]{ctexrep}
                \\setcounter{secnumdepth}{4}
                \\usepackage[linkcolor=blue,citecolor=blue,backref=page]{hyperref}
                \\hypersetup{hidelinks}
                \\usepackage{xeCJK}
                \\usepackage{fontspec}
                \\setCJKmainfont{SimSun}
                \\setCJKmonofont{SimSun}
                \\setCJKfamilyfont{kaiti}{KaiTi}
                \\newcommand{\\KaiTi}{\\CJKfamily{kaiti}}
                \\setmainfont{Times New Roman}
                \\usepackage[namelimits]{amsmath}
                \\usepackage{amssymb}
                \\usepackage{mathrsfs}
                \\usepackage{minted}
                \\newcommand{\\chuhao}{\\fontsize{42.2pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaochu}{\\fontsize{36.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\yihao}{\\fontsize{26.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoyi}{\\fontsize{24.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\erhao}{\\fontsize{22.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoer}{\\fontsize{18.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sanhao}{\\fontsize{16.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosan}{\\fontsize{15.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sihao}{\\fontsize{14.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosi}{\\fontsize{12.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\wuhao}{\\fontsize{10.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaowu}{\\fontsize{9.0pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\liuhao}{\\fontsize{7.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoliu}{\\fontsize{6.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\qihao}{\\fontsize{5.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\bahao}{\\fontsize{5.0pt}{\\baselineskip}\\selectfont}
                \\usepackage{color}
                \\usepackage{geometry}
                \\geometry{top=2cm,bottom=2cm,right=2cm,left=2.5cm}
                \\geometry{headsep=0.5cm}
                \\usepackage{setspace}
                \\setlength{\\baselineskip}{22pt}
                \\setlength{\\parskip}{0pt}
                \\usepackage{enumerate}
                \\usepackage{enumitem}
                \\setenumerate[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setitemize[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setdescription{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\usepackage{fancyhdr}
	              \\pagestyle{fancy}
	              \\fancyhead{}
	              \\fancyhead[CE]{\\KaiTi \\wuhao xxxx}
	              \\fancyhead[CO]{\\KaiTi \\wuhao xxxxxx}
	              \\fancypagestyle{plain}{\\pagestyle{fancy}}
                \\ctexset{contentsname=\\heiti{目{\\quad}录}}
                \\ctexset{section={format=\\raggedright}}
                \\usepackage{titlesec}
	              \\titleformat{\\chapter}[block]{\\normalfont\\xiaoer\\bfseries\\centering\\heiti}{第{\\zhnumber{\\thechapter}}章}{10pt}{\\xiaoer}
	              \\titleformat{\\section}[block]{\\normalfont\\xiaosan\\bfseries\\heiti}{\\thesection}{10pt}{\\xiaosan}
	              \\titleformat{\\subsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsection}{10pt}{\\sihao}
	              \\titleformat{\\subsubsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsubsection}{10pt}{\\sihao}
	              \\titlespacing{\\chapter} {0pt}{-22pt}{0pt}{}
	              \\titlespacing{\\section} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsection} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsubsection} {0pt}{0pt}{0pt}
                \\usepackage[super,square,numbers,sort&compress]{natbib}
                \\usepackage{graphicx}
                \\usepackage{subfigure}
                \\usepackage{caption}
                \\captionsetup{font={small}}
                [NO-DEFAULT-PACKAGES]
                [NO-PACKAGES]
                [EXTRA]"
                ("\\chapter{%s}" . "\\chapter*{%s}")
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
	       '("org-article"
		 "\\documentclass[UTF8,twoside,a4paper,12pt,openright]{ctexart}
                \\setcounter{secnumdepth}{4}
                \\usepackage[linkcolor=blue,citecolor=blue,backref=page]{hyperref}
                \\hypersetup{hidelinks}
                \\usepackage{xeCJK}
                \\usepackage{fontspec}
                \\setCJKmainfont{SimSun}
                \\setCJKmonofont{SimSun}
                \\setCJKfamilyfont{kaiti}{KaiTi}
                \\newcommand{\\KaiTi}{\\CJKfamily{kaiti}}
                \\setmainfont{Times New Roman}
                \\usepackage[namelimits]{amsmath}
                \\usepackage{amssymb}
                \\usepackage{mathrsfs}
                \\usepackage{minted}
                \\newcommand{\\chuhao}{\\fontsize{42.2pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaochu}{\\fontsize{36.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\yihao}{\\fontsize{26.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoyi}{\\fontsize{24.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\erhao}{\\fontsize{22.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoer}{\\fontsize{18.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sanhao}{\\fontsize{16.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosan}{\\fontsize{15.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\sihao}{\\fontsize{14.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaosi}{\\fontsize{12.1pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\wuhao}{\\fontsize{10.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaowu}{\\fontsize{9.0pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\liuhao}{\\fontsize{7.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\xiaoliu}{\\fontsize{6.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\qihao}{\\fontsize{5.5pt}{\\baselineskip}\\selectfont}
                \\newcommand{\\bahao}{\\fontsize{5.0pt}{\\baselineskip}\\selectfont}
                \\usepackage{color}
                \\usepackage{geometry}
                \\geometry{top=2cm,bottom=2cm,right=2cm,left=2.5cm}
                \\geometry{headsep=0.5cm}
                \\usepackage{setspace}
                \\setlength{\\baselineskip}{22pt}
                \\setlength{\\parskip}{0pt}
                \\usepackage{enumerate}
                \\usepackage{enumitem}
                \\setenumerate[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setitemize[1]{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\setdescription{itemsep=0pt,partopsep=0pt,parsep=\\parskip,topsep=5pt}
                \\usepackage{fancyhdr}
	              \\pagestyle{fancy}
	              \\fancyhead{}
	              \\fancyhead[CE]{\\KaiTi \\wuhao xxxxx}
	              \\fancyhead[CO]{\\KaiTi \\wuhao xxxx}
	              \\fancypagestyle{plain}{\\pagestyle{fancy}}
                \\ctexset{contentsname=\\heiti{目{\\quad}录}}
                \\ctexset{section={format=\\raggedright}}
                \\usepackage{titlesec}
	              %\\titleformat{\\chapter}[block]{\\normalfont\\xiaoer\\bfseries\\centering\\heiti}{第{\\zhnumber{\\thechapter}}章}{10pt}{\\xiaoer}
	              \\titleformat{\\section}[block]{\\normalfont\\xiaosan\\bfseries\\heiti}{\\thesection}{10pt}{\\xiaosan}
	              \\titleformat{\\subsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsection}{10pt}{\\sihao}
	              \\titleformat{\\subsubsection}[block]{\\normalfont\\sihao\\bfseries\\heiti}{\\thesubsubsection}{10pt}{\\sihao}
	              %\\titlespacing{\\chapter} {0pt}{-22pt}{0pt}{}
	              \\titlespacing{\\section} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsection} {0pt}{0pt}{0pt}
	              \\titlespacing{\\subsubsection} {0pt}{0pt}{0pt}
                \\usepackage[super,square,numbers,sort&compress]{natbib}
                \\usepackage{graphicx}
                \\usepackage{subfigure}
                \\usepackage{caption}
                \\captionsetup{font={small}}
                [NO-DEFAULT-PACKAGES]
                [NO-PACKAGES]
                [EXTRA]"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(provide 'init-tex)
