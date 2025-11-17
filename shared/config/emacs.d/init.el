;; elpaca init
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
			      :ref nil :depth 1 :inherit ignore
			      :files (:defaults "elpaca-test.el" (:exclude "extensions"))
			      :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
				 (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
					   ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
									   ,@(when-let* ((depth (plist-get order :depth)))
											(list (format "--depth=%d" depth) "--no-single-branch"))
									   ,(plist-get order :repo) ,repo))))
					   ((zerop (call-process "git" nil buffer t "checkout"
								 (or (plist-get order :ref) "--"))))
					   (emacs (concat invocation-directory invocation-name))
					   ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
								 "--eval" "(byte-recompile-directory \".\" 0 'force)")))
					   ((require 'elpaca))
					   ((elpaca-generate-autoloads "elpaca" repo)))
					  (progn (message "%s" (buffer-string)) (kill-buffer buffer))
					  (error "%s" (with-current-buffer buffer (buffer-string))))
				 ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))
;;

;; use package integration
(elpaca elpaca-use-package
	(elpaca-use-package-mode))

(setq inhibit-startup-screen t
      make-backup-files nil
      create-lockfiles nil)

;; Statistics
(setq use-package-compute-statistics t)

;; Evil mode
(use-package evil
	     :ensure (:wait t)
	     :demand t
	     :init
	     (setq evil-want-keybinding nil)  ; Prevents conflicts with evil-collection (if you add it later)
	     (setq evil-want-C-u-scroll t)
	     (setq evil-want-integration t)
	     :config
	     (evil-mode 1)
;; Define EVERY leader sequence explicitly—no nesting
  (evil-define-key 'normal 'global (kbd "SPC c") 'org-capture)
  (evil-define-key 'normal 'global (kbd "SPC a") 'org-agenda)
  (evil-define-key 'normal 'global (kbd "SPC o") 'org-open-at-point)
  (evil-define-key 'normal 'global (kbd "SPC s") 'org-store-link)
  (evil-define-key 'normal 'global (kbd "SPC S") 'org-insert-link)
  (evil-define-key 'normal 'global (kbd "SPC R") 'org-refile)
  (evil-define-key 'normal 'global (kbd "SPC x") 'org-archive-subtree)
  (evil-define-key 'normal 'global (kbd "SPC T") 'org-todo)
  (evil-define-key 'normal 'global (kbd "SPC n") 'org-narrow-to-subtree)
  (evil-define-key 'normal 'global (kbd "SPC N") 'widen)
  
  ;; Org-roam under SPC r
  (evil-define-key 'normal 'global (kbd "SPC r f") 'org-roam-node-find)
  (evil-define-key 'normal 'global (kbd "SPC r i") 'org-roam-node-insert)
  (evil-define-key 'normal 'global (kbd "SPC r b") 'org-roam-buffer-toggle)
  (evil-define-key 'normal 'global (kbd "SPC r d") 'org-roam-dailies-goto-today)
  
  ;; Consult under SPC f
  (evil-define-key 'normal 'global (kbd "SPC f f") 'consult-fd)
  (evil-define-key 'normal 'global (kbd "SPC f b") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "SPC f l") 'consult-line)
  (evil-define-key 'normal 'global (kbd "SPC f g") 'consult-ripgrep)
  
  ;; Dired jump
  (evil-define-key 'normal 'global (kbd "-") 'dired-jump)
  (evil-set-initial-state 'wdired-mode 'normal)
	     (evil-define-key 'normal dired-mode-map
			      "e" #'wdired-change-to-wdired-mode  ; Edit filenames
			      "a" #'dired-create-empty-file       ; Add file
			      "A" #'dired-create-directory        ; Add directory
			      "h" #'dired-up-directory            ; Navigate up
			      "l" #'dired-find-file               ; Navigate down/open
			      "q" #'quit-window))

;; Org mode
(use-package org
	     :ensure nil
	     :after (evil)
	     :custom
	     (org-directory "~/org")
	     (org-archive-location (concat org-directory "/archive.org::"))  ; File::heading
	     (org-agenda-files (list org-directory))
	     (org-default-notes-file (concat org-directory "/inbox.org"))
	     (org-id-link-to-org-use-id t)
	     (org-id-method 'uuid)
	     (org-roam-db-autosync-mode t)
	     (org-capture-templates
	       '(("t" "Task" entry (file+headline org-default-notes-file "Inbox")
		  "* TODO %?\n  %U\n  %a" :kill-buffer t)
		 ("n" "Note" entry (file+headline org-default-notes-file "Notes")
		  "* %? :NOTE:\n  %U\n  %a" :kill-buffer t)))
	     ;; Keep standard bindings for insert/emacs state
	     :bind
	     (("C-c c" . org-capture)
	      ("C-c a" . org-agenda))
	     :config
	     ;; Resize Org headings
(dolist (face '((org-level-1 . 1.35)
                (org-level-2 . 1.3)
                (org-level-3 . 1.2)
                (org-level-4 . 1.1)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "Source Sans Pro" :weight 'bold :height (cdr face)))

;; Make the document title a bit bigger
(set-face-attribute 'org-document-title nil :font "Source Sans Pro" :weight
'bold :height 1.8)
)

(use-package org-roam
	     :ensure (:wait t)
	     :after (org evil)
	     :demand t
	     :custom
	     (org-roam-directory (concat org-directory "/roam"))
	     (org-roam-completion-everywhere t)
	     :config
	     (org-roam-db-autosync-mode 1))

(use-package org-superstar
	     :ensure (:wait t)
	     :hook (org-mode))

(use-package which-key
	     :ensure (:wait t)
	     :init (which-key-mode))

(use-package dired
	     :ensure nil
	     :init
	     (setq dired-dwim-target t
		   wdired-allow-to-change-permissions t)
	     )

;; Clean stack - no require statements needed
(use-package vertico
	     :ensure (:wait t)
	     :init (vertico-mode 1)
	     :custom (vertico-cycle t))

(use-package orderless
	     :ensure (:wait t)
	     :init (setq completion-styles '(orderless)))

(use-package marginalia
	     :ensure (:wait t)
	     :init (marginalia-mode 1))

(use-package consult
	     :ensure (:wait t)
	     :after (vertico orderless evil)  ; Ensures load order
	     :demand t
	     :bind
	     (("C-x C-f" . consult-fd)
	      ("C-x b" . consult-buffer)
	      ("M-s" . consult-line)
	      ("M-x" . consult-M-x)))	     

(use-package embark
	     :ensure (:wait t)
	     :bind (("C-." . embark-act))
	     :config
	     ;; Hide mode line in collect buffers
	     (add-to-list 'display-buffer-alist
			  '("\\`\\*Embark Collect" nil (window-parameters (mode-line-format . none)))))

(use-package embark-consult
	     :ensure (:wait t)
	     :after (embark consult))  ; Loads automatically after both

;; HISTORY PERSISTENCE (critical for consult-buffer)
(use-package savehist
	     :init (savehist-mode 1))
(use-package recentf
	     :init (recentf-mode 1)
	     :custom (recentf-max-saved-items 200))

(use-package treesit-auto
:ensure (:wait t)
:demand t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package nix-ts-mode
  :ensure (:wait t)
  :mode ("\\.nix\\'" . nix-ts-mode)
  :init
  ;; Ensure grammar is installed (prompts if missing)
  (unless (treesit-language-available-p 'nix)
    (treesit-install-language-grammar 'nix)))

(use-package ef-themes
  :ensure (:wait t)
  :config (load-theme 'ef-tritanopia-light t))

;; Check EACH font independently—safer for shared configs
(when (member "JetBrains Mono" (font-family-list))
  (set-face-attribute 'default nil :font "JetBrains Mono" :height 150))

(when (member "Source Sans Pro" (font-family-list))
  (set-face-attribute 'variable-pitch nil :family "Source Sans Pro" :height 1.15))

