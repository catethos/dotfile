;; Package Manager
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
)
(require 'ess-site)
(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/myscript")
;; Enable Ido mode
(ido-mode 1)
;; Prevent the cursor from blinking
(blink-cursor-mode 0)

;; Don't use messages that you don't read
(setq initial-scratch-message "What The Hell Do You Want?\nDo Something Small About It Now!\n")
(setq inhibit-startup-message t)

;; Don't let Emacs hurt your ears
(setq visible-bell t)

;; This is bound to f11 in Emacs 24.4
(toggle-frame-fullscreen) 

;; Who use the bar to scroll?
(scroll-bar-mode 0)
(tool-bar-mode 0)
;; Font Setting
(set-face-attribute 'default nil
		    :family "Anonymous Pro"
		    :height 250)
;; Python Mode
(add-hook 'python-mode-hook
  (lambda ()
    (setq indent-tabs-mode t)
    (setq python-indent 8)
    (setq tab-width 4)))

;; Visual Theme
(load-theme 'monokai t)

;; Annoying Error Bell
(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))

(setq ring-bell-function 'my-bell-function)

;; Org-mode
; Must have org-mode loaded before we can configure org-babel
(require 'org-install)
;; reftex keybinding
(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (define-key org-mode-map (kbd "C-c )") 'org-reftex-citation)
)
  
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; Latex output source highlight
;; Include the latex-exporter
(require 'ox-latex)
;; Add minted to the defaults packages to include when exporting.
(add-to-list 'org-latex-packages-alist '("" "minted"))
;; Tell the latex export to use the minted package for source
;; code coloration.
(setq org-latex-listings 'minted)
;; Let the exporter use the -shell-escape option to let latex
;; execute external programs.
;; This obviously and can be dangerous to activate!
(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))
;; html output source highlighted
(setq org-src-fontify-natively t)
; Some initial langauges we want org-babel to support
(setq org-babel-python-command "python3")
(setq org-src-fontify-natively t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (R . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (octave . t)
   (sqlite . t)
   (perl . t)
   ))

; Add short cut keys for the org-agenda
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)

(setq org-agenda-files (quote ("~/org"
                               "~/Projects/learning/haskell/project_haskell.org"
			       "~/Projects/learning/Emacs/latex/project_latex.org"
                               )))

;; Auctex Settings
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)
 
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)

(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
 
;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))
; Set the environment so that Emacs knows the path to pdfLatex
(setenv "PATH"
(concat
 "/usr/texbin" ":"
 "/usr/local/bin" ":"
 "~/.cabal/bin" ":"
(getenv "PATH")))

(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("~/.cabal/bin")))
;; Haskell Mode
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(setq haskell-process-type 'cabal-repl)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)

;;Publising Blogs
;(require 'org-publish)
;(setq org-publish-project-alist
;      `(("blog-note"
;         :base-directory "~/blog/org/"
;         :base-extension "org"
;         :publishing-directory "~/blog/public/"
;         :publishing-function org-publish-org-to-html
;         :section-numbers t
;	 :recursive t
;         :with-toc t
;         :html-head nil
;         :html-preamble "<h1 id=\"headline\">Categorical Ethos</h1>
;                         <ul id=\"nav\"> 
;                         <li><a href=\"/\">HOME</a></li>
;                         <li><a href=\"https://github.com/catethos/\">GITHUB</a></li>
;                         </ul>
;                         "
;         :html-postamble "<div id='disqus_thread'></div>
;                          <script type='text/javascript'>
;                          /** CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE***/
;                          var disqus_shortname = 'catethos'; // required: replace example with your forum shortname
;                          /*** DON'T EDIT BELOW THIS LINE***/
;                          (function() {
;                              var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
;                             dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
;                              if (window.location.pathname != '/'){
;                              (document.getElementsByTagName('body')[0]).appendChild(dsq)};
;                          })();
;                     </script>
;                     <noscript>Please enable JavaScript to view the <a href='http://disqus.com/?ref_noscript'>comments powered by Disqus.</a></noscript>"
;	 :style "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\" />")
;	 ("blog-static"
;           :base-directory "~/blog/org/"
;           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|otf"
;           :publishing-directory "~/blog/public/"
;           :recursive t
;           :publishing-function org-publish-attachment)
;         ("blog"
;	   :components ("blog-note" "blog-static"))
;))


;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((python . t)))

(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/local/bin/sbcl")

;; Julia

(setq inferior-julia-program-name "/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia")

;;F#
(setq inferior-fsharp-program "/usr/bin/fsharpi --readline-")
(setq fsharp-compiler "/usr/bin/fsharpc")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-lein-command "~/bin/lein")
 '(org-agenda-files (quote ("~/playground/test.org" "/Users/catethos/org/book.org" "/Users/catethos/org/career.org" "/Users/catethos/org/demon.org" "/Users/catethos/org/maybe.org" "/Users/catethos/org/meta.org" "/Users/catethos/org/org-mode.org" "/Users/catethos/org/philosophyDiary.org" "/Users/catethos/org/productivity.org" "/Users/catethos/org/projects.org" "/Users/catethos/org/working.org" "/Users/catethos/org/worklog.org" "~/Projects/learning/haskell/project_haskell.org" "~/Projects/learning/Emacs/latex/project_latex.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
