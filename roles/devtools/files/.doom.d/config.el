;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Rui Vieira"
      user-mail-address "ruidevieira@googlemail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 14 :weight 'semi-light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'acme)
(setq doom-theme 'doom-sourcerer)

(let ((alternatives '("doom-emacs-color.png" "doom-emacs-color2.png"
                      "doom-emacs-slant-out-bw.png" "doom-emacs-slant-out-color.png")))
  (setq fancy-splash-image
        (concat doom-private-dir "splash/"
                (nth (random (length alternatives)) alternatives))))
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Sync/notes/pages/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(setq confirm-kill-emacs nil) ; Disable exit confirmation.

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; start full-screen
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq python-shell-completion-native-enable nil)

(after! org
      (setq org-todo-keywords
            '((sequence "IDEA" "TODO" "LATER" "DOING" "|" "DONE" "CANCELED")
            (sequence "BACKLOG" "INPROGRESS" "ONHOLD" "INREVIEW" "|" "MERGED" "CANCELED")
            (sequence "WORK" "|" "DONE" "CANCELED")
            (sequence "SHOP" "|" "DONE" "CANCELED")
            (sequence "REVIEW" "|" "DONE" "CANCELED")
            (sequence "MEETING" "|" "MET" "CANCELED")))
      (setq org-agenda-custom-commands
            '(("l" todo "LATER")
            ("j" "Agenda and work tasks" (
                                          (agenda "")
                                          (todo "BACKLOG") (todo "INPROGRESS")
                                          (todo "WORK")
                                          (todo "REVIEW")))
            ("h" "Work (on hold): agend and tasks" (
                                                    (agenda "" ((todo "ONHOLD") (todo "INREVIEW")))
                                                    (todo "ONHOLD") (todo "INREVIEW")))
            ("m" "Work: agenda and meetings" (
                                              (agenda "" ((todo "MEETING")))
                                              (todo "MEETING")))
            ("w" "Work tasks and meetings" (
                                            (agenda "" ((org-agenda-span 14)
                                                        (todo "MEETING")
                                                        (todo "REVIEW")
                                                        (todo "BACKLOG")
                                                        (todo "WORK")
                                                        (tags "+work")))
                                    (todo "MEETING")
                                    (todo "REVIEW")
                                    (todo "BACKLOG")
                                    (todo "WORK")
                                    (tags "+work")))
    ("tw" tags-todo "+work")
    ("s" "Shopping: agenda and tasks" (
                                       (agenda "" ((todo "SHOP")))
                                       (todo "SHOP")))
    ("n" "General: agenda and TODOs" (
                             (agenda "" ((todo "TODO")))
                             (todo "TODO")))
    ("f" "Fortnight agenda and everything" (
                                            (agenda "" ((org-agenda-span 14)))
                                            (alltodo "")))
    ))
    (setq rui/org-agenda-directory "~/Sync/notes/pages/")
    (setq org-capture-templates
          `(("t" "todo" entry (file ,(concat rui/org-agenda-directory "Inbox.org"))
          "* TODO  %?")
         ("w" "work" entry (file ,(concat rui/org-agenda-directory "Inbox.org"))
            "* WORK  %?")
         ("e" "email" entry (file+headline ,(concat rui/org-agenda-directory "emails.org") "Emails")
          "* TODO  [#A] Reply: %a :@home:@school:" :immediate-finish t)
         ("l" "link" entry (file ,(concat rui/org-agenda-directory "Inbox.org"))
          "* TODO %(org-cliplink-capture)" :immediate-finish t)
         ("c" "org-protocol-capture" entry (file ,(concat rui/org-agenda-directory "Inbox.org"))
          "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)))
 (setq org-image-actual-width nil)
    (org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (plantuml . t)
    (java . t)
    (python . t)
    (deno . t)
    (go . t)
    (jupyter . t)))
    (setq org-roam-directory "~/Sync/notes/pages/")
    
    )

(add-hook 'typescript-mode-hook 'deno-fmt-mode)
(add-hook 'js2-mode-hook 'deno-fmt-mode)
;; (add-to-list 'org-src-lang-modes '("deno" . typescript))

;; Configure file templates
(set-file-template! "/post\\.org$" :trigger "__post.org" :mode 'org-mode)
(set-file-template! "/JIRAs\\.org$" :trigger "__jira.org" :mode 'org-mode)

(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups '((:auto-dir-name t)))
  (org-super-agenda-mode))
