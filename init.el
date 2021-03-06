;;; ロードパスの追加
(setq load-path (append
                 '("~/.emacs.d/lisp"
                   "~/.emacs.d/packages"
		   "~/.emacs.d/lisp/auto-complete"
		   "~/.emacs.d/lisp/popup"
		   "~/.emacs.d/lisp/scala-mode2"
		   "~/.emacs.d/lisp/ensime"
		   "~/.emacs.d/lisp/dash"
		   "~/.emacs/elpa/"
		   "~/.emacs.d/lisp/s"
		   "~/.emacs.d/lisp/company"
		   "~/.emacs.d/lisp/sbt-mode"
		   "~/.emacs.d/lisp/yatex/yatex1.78.4"
		   "~/.emacs.d/lisp/slime"
		   )
                 load-path))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

(setq geiser-racket-binary "/usr/bin/racket")
(setq geiser-active-implementations '(racket))

;; リスト1 カーソル移動をCtrl-hjklに
;;(global-set-key "\C-h" 'backward-char)
;;(global-set-key "\C-j" 'next-line)
;;(global-set-key "\C-k" 'previous-line)
;;(global-set-key "\C-l" 'forward-char)
;;(global-set-key "\C-n" 'newline-and-indent)
;;
;;(global-set-key "\C-o" 'kill-line)
;; 行をコピーするコマンド
(defun copy-line (&optional arg)
  (interactive "p")
  (copy-region-as-kill
   (line-beginning-position)
   (line-beginning-position (1+ (or arg 1))))
  (message "Line copied"))
 
(define-key global-map "\M-o" 'copy-line);;ショートカットコマンドはここで設定可能

;; カラーテーマ設定
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)
;; 日本語の設定
(set-language-environment "Japanese")
;;(prefer-coding-system 'utf-8)
;(set-default-coding-systems 'utf-8)
;(set-terminal-coding-system 'utf-8)	
;(set-keyboard-coding-system 'utf-8)
;(set-buffer-file-coding-system 'utf-8)
;(setq default-buffer-file-coding-system 'utf-8)
;(set-buffer-file-coding-system 'utf-8)
;(set-clipboard-coding-system 'utf-8)
;; モードごとの色適用
(global-font-lock-mode t)
;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq ring-bell-function 'ignore)
;;; メニューバーを消す
(menu-bar-mode -1)
;;; ツールバーを消す
(tool-bar-mode -1)
;;; カーソルの点滅を止める
(blink-cursor-mode 0)
;;; 対応する括弧を光らせる。
(show-paren-mode 1)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)
;; スクロールバー
(scroll-bar-mode 0)
					; 行数表示
(global-linum-mode t)
; フォント
;(add-to-list 'default-frame-alist '(font . "Ricty Diminished-13"))
(add-to-list 'default-frame-alist '(font . "Osaka－等幅-13"))

; 極力UTF-8とする
(prefer-coding-system 'utf-8)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("6077e0de8ac8f10c8be7578c209bcfb6c5bbf0bd2be93a24cd74efae6aca520a" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
;; Haskell
;;

;; haskell-mode
(require 'auto-complete)
(add-to-list 'load-path "~/.emacs.d/lisp/haskell-mode-2.8.0")
(autoload 'haskell-mode "haskell-mode")
(autoload 'haskell-cabal "haskell-cabal")
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))
(setq haskell-program-name "/usr/bin/ghci")
(add-hook 'haskell-mode-hook 'inf-haskell-mode)
(defadvice inferior-haskell-load-file (after change-focus-after-load)
  "Change focus to GHCi window after C-c C-l command"
  (other-window 1))
(ad-activate 'inferior-haskell-load-file)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook #'hindent-mode)

;; ghc-mod
(add-to-list 'exec-path (concat (getenv "HOME") "/.cabal/bin"))
(add-to-list 'ac-sources 'ac-source-ghc-mod)
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;;
;; Scala
;;
;; scala-mode2
(require 'scala-mode2)
(add-to-list 'auto-mode-alist '("\.sbt$" . scala-mode))
;; ensime
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; YaTeX mode
(setq auto-mode-alist
    (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "platex")
(setq dviprint-command-format "dvipdfmx %s")
;; use Preview.app
(setq dvi2-command "open -a Preview")
(setq bibtex-command "pbibtex")

;; geiser racket
(setq geiser-racket-binary "/usr/bin/racket")
(setq geiser-active-implementations '(racket))

;; 括弧補完
(require 'smartparens-config)

(smartparens-global-mode t)
;; ~/.emacs.d/slimeをload-pathに追加
;; SBCLをデフォルトのCommon Lisp処理系に設定
(setq inferior-lisp-program "sbcl")
;; SLIMEのロード
(require 'slime)
(slime-setup '(slime-repl slime-fancy slime-banner)) 
