(add-to-list 'default-frame-alist '(undecorated-round . t))
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

;; disable for elpaca
(setq package-enable-at-startup nil)


