;; * Configure package repositories
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
       ("marmalade" . "https://marmalade-repo.org/packages/")
       ("melpa" . "https://melpa.org/packages/")
       ("org" . "https://orgmode.org/elpa/")))

(package-initialize)

;; * Outshine
(add-hook 'emacs-lisp-mode-hook 'outshine-mode)

;; * Appearance
;; ** remove tool bar and menu bar
(tool-bar-mode 0)
(menu-bar-mode 0)

;; ** show line numbers
(global-display-line-numbers-mode)

;; ** visually break lines outside the buffer
(setq-default truncate-lines nil)

;; ** set cursor type to |
(setq-default cursor-type 'bar)

;; ** load theme
(require 'kaolin-themes)
(load-theme 'kaolin-aurora t)

;; ** customize splash screen
(require 'dashboard)
(dashboard-setup-startup-hook)

(setq dashboard-startup-banner 'logo)
(setq dashboard-center-content t)
(setq dashboard-set-file-icons t)
(setq dashboard-footer-messages '("Gotta go fast!"))

;; ** customize power line
(require 'telephone-line)

;; *** define faces
(defface telephone-line-god
  '((t (:foreground "white" :weight bold :inherit mode-line)))
  "")

(defface telephone-line-god-god
  '((t (:background "red3" :inherit telephone-line-god)))
  "")

(defface telephone-line-god-normal
  '((t (:background "forest green" :inherit telephone-line-god)))
  "")

(defface telephone-line-god-inactive
  '((t (:foreground "grey33" :background "grey22" :inherit telephone-line-god)))
  "")

;; *** god mode configurations
(defun telephone-line-god-modal (active)
  (cond
   ((not active) 'telephone-line-god-inactive)
   ((or god-local-mode buffer-read-only) 'telephone-line-god-god)
   (t 'telephone-line-god-normal)))

(setq telephone-line-faces
      '((god . telephone-line-god-modal)
	(accent . (telephone-line-accent-active . telephone-line-accent-inactive))
	(nil . (mode-line . mode-line-inactive))))

(telephone-line-defsegment god-segment ()
  (if (or god-local-mode buffer-read-only)
      "God"
    "Normal"))

;; *** define segments
(setq telephone-line-lhs
      '((god    . (god-segment))
        (accent . (telephone-line-vc-segment
                   telephone-line-erc-modified-channels-segment
                   telephone-line-process-segment
		   telephone-line-minor-mode-segment))
        (nil    . (telephone-line-buffer-segment))))

(setq telephone-line-rhs
      '((nil    . (telephone-line-misc-info-segment))
        (accent . (telephone-line-major-mode-segment))
        (nil    . (telephone-line-airline-position-segment))))

;; *** initialize telephone-line
(telephone-line-mode)

;; * File management
;; ** change backup location
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5)   ; and how many of the old

;; ** update file after change git branch
(global-auto-revert-mode)

;; ** disable lockfiles
(setq create-lockfiles nil)

;; ** configure dired
(put 'dired-find-alternate-file 'disabled nil)

(add-hook 'dired-mode-hook
	  (lambda ()
	    (define-key dired-mode-map (kbd "RET")
	      'dired-find-alternate-file)))

;; * God mode
(require 'god-mode)
(god-mode)

;; ** set keybindings
(global-set-key (kbd "<escape>") 'god-mode-all)
(global-set-key (kbd "M-i") 'god-mode-all) ; for emacs on terminal
(global-set-key (kbd "C-x C-1") 'delete-other-windows)
(global-set-key (kbd "C-x C-2") 'split-window-below)
(global-set-key (kbd "C-x C-3") 'split-window-right)
(global-set-key (kbd "C-x C-0") 'delete-window)
(global-set-key (kbd "C-x C-4 C-f") 'find-file-other-window)

(define-key god-local-mode-map (kbd "i") #'god-local-mode)
(define-key god-local-mode-map (kbd ".") #'repeat)

;; ** ensure god-mode-all works
(setq god-mode-exempt-major-modes nil)
(setq god-mode-exempt-predicates nil)

;; ** disable god-mode for function keys (like f5)
(setq god-mode-enable-function-key-translation nil)

;; ** configure cursor
(defun my-god-mode-update-cursor ()
  (setq cursor-type
	(if (or god-local-mode buffer-read-only) 'box 'bar)))

(add-hook 'god-mode-enabled-hook 'my-god-mode-update-cursor)
(add-hook 'god-mode-disabled-hook 'my-god-mode-update-cursor)

;; * Smartparens
(require 'smartparens-config)
(add-hook 'prog-mode-hook 'smartparens-mode)

;; ** set keybindings
(global-set-key (kbd "C-M-a") 'sp-beginning-of-sexp)
(global-set-key (kbd "C-M-e") 'sp-end-of-sexp)
(global-set-key (kbd "M-(") 'sp-backward-unwrap-sexp)
(global-set-key (kbd "M-k") 'sp-backward-kill-sexp)
(global-set-key (kbd "M-)") 'sp-forward-slurp-sexp)

;; ** define parens
(defmacro wrap-with-pair (open close)
  `(global-set-key (kbd ,(concat "C-" close))
		   (lambda (&optional args)
		     (interactive "P")
		     (sp-wrap-with-pair ,open))))

(wrap-with-pair "(" ")")
(wrap-with-pair "[" "]")
(wrap-with-pair "{" "}")
(wrap-with-pair "\"" "\"")
(wrap-with-pair "`" "`")

;; * Ace Jump
(require 'ace-jump-mode)
(global-set-key (kbd "M-SPC") 'ace-jump-mode)
(global-set-key (kbd "M-o") 'ace-window)

;; * Personalized functions
;; ** resize window
(defun my-shrink-window (&optional size)
  (interactive "P")
  (unless size (setq size 5))
  (shrink-window size))

(defun my-enlarge-window (&optional size)
  (interactive "P")
  (unless size (setq size 5))
  (enlarge-window size))

(global-set-key (kbd "C-c r s") #'my-shrink-window)
(global-set-key (kbd "C-c r e") #'my-enlarge-window)

;; * Languages
;; ** Coq
;; *** proof-general
(setq proof-splash-enable nil)
(add-hook 'coq-mode-hook 'proof-unicode-tokens-enable)

;; ** Haskell
;; *** start interactive mode
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;; *** prettify symbols
(defun haskell-prettify ()
  "Make some word or string show as pretty Unicode symbols."
  (progn
    (setq prettify-symbols-alist
        '(
	  ("\\" . 955) ; λ
          ("->" . 8594) ; →
          ("<-" . 8592) ; ←
          ("=>" . 8658) ; ⇒
	  ("`elem`" . 8712) ; ∈
	  ("`notElem`" . 8713); ∉
	  ("forall" . 8704) ; ∀
          ))
    (prettify-symbols-mode)))

(add-hook 'haskell-mode-hook #'haskell-prettify)

;; ** Common Lisp
(load (expand-file-name "~/.roswell/helper.el"))

(defun slime-eval-buffer-with-ros ()
  (interactive)
  (let ((old-buffer (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring old-buffer)
      (goto-char 0)
      (flush-lines "^#")
      (flush-lines "^|")
      (flush-lines "^exec")
      (slime-eval-buffer))))

(define-key lisp-mode-map (kbd "C-c C-;") 'slime-eval-buffer-with-ros)

;; ** Elixir
;; *** elixir-format
(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

;; *** alchemist
(require 'alchemist)
(add-hook 'elixir-mode-hook 'alchemist-mode)

(define-key alchemist-mode-map (kbd "C-c C-a C-i C-i") 'alchemist-iex-run)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-p") 'alchemist-iex-project-run)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-l") 'alchemist-iex-send-current-line)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-c") 'alchemist-iex-send-current-line-and-go)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-r") 'alchemist-iex-send-region)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-m") 'alchemist-iex-send-region-and-go)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-b") 'alchemist-iex-compile-this-buffer)
(define-key alchemist-mode-map (kbd "C-c C-a C-i C-S-R") 'alchemist-iex-reload-module)

;; ** Python
(add-hook 'python-mode-hook 'blacken-mode)

;; ** HTML
(require 'web-mode)

(add-hook 'web-mode-hook 'emmet-mode)
(add-to-list 'auto-mode-alist '("\\.html\\.eex\\'" . web-mode))

;; * Org mode
(require 'org)

;; ** set latex compiler
(setq org-latex-pdf-process '("latexmk --shell-escape -bibtex -f -pdf %f"))

;; ** set rendered latex size
(plist-put org-format-latex-options :scale 1.5)

;; * Emacs automatic configuration
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coq-shortcut-alist nil)
 '(lsp-haskell-server-args nil)
 '(org-agenda-files '("~/Documents/agenda.org"))
 '(org-babel-load-languages '((latex . t) (emacs-lisp . t)))
 '(package-selected-packages
   '(dockerfile-mode proof-general outshine alchemist all-the-icons dashboard eglot idris-mode markdown-mode emmet-mode web-mode elixir-mode smartparens god-mode htmlize rjsx-mode blacken json-mode yaml-mode elm-mode haskell-mode ace-jump-mode ace-window telephone-line kaolin-themes)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
