;;无论在什么样的主模式下都打开auto-fill模式
;;(setq-default auto-fill-function 'do-auto-fill)

;; isswitch
(require 'iswitchb)
(iswitchb-default-keybindings)

;; 不显示 Emacs 的开始画面
(setq inhibit-startup-message t)

;; 改变 Emacs 标题栏的标题
(setq frame-title-format "L@%b::%m@")

;; 去掉菜单栏
;;(menu-bar-mode nil)
;;(tool-bar-mode nil)

;; 去掉滚动栏
;;(scroll-bar-mode nil)

;;set the default text coding system
;;(setq default-buffer-file-coding-system 'utf-8)
;; 设置tab为4个空格的宽度，而不是原来的2
(setq c-basic-offset 4)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)

;; 操作习惯
;; 设置打开文件缺省路径

;;启动语法高亮模式
(global-font-lock-mode t)

;;(mouse-avoidance-mode 'animate);光标靠近鼠标指针时，让鼠标指针自动让开
;; 滚动页面时比较舒服，不要整页的滚动
(setq scroll-step 1
scroll-margin 3
scroll-conservatively 10000)
(column-number-mode t);显示列号
(global-linum-mode 1)

;; 启动 Emacs 自动设置为两个窗口(上下各一个)
;;(split-window-vertically)
(setq initial-frame-alist '((top . 0) (left . 250) (width . 180) (height .  50)));启动自动最大化

;;(load-file "~/.emacs.d/color-theme-blackboard.el")
(add-to-list 'load-path "~/.emacs.d/")
(require 'color-theme)
(setq color-theme-is-global t)
(color-theme-blackboard)

;;根据文件扩展名自动php-mode
;;启动语法高亮模式
(global-font-lock-mode t)

;;(mouse-avoidance-mode 'animate);光标靠近鼠标指针时，让鼠标指针自动让开
;; 滚动页面时比较舒服，不要整页的滚动
(setq scroll-step 1
scroll-margin 3
scroll-conservatively 10000)
(column-number-mode t);显示列号
(global-linum-mode 1)

;; 启动 Emacs 自动设置为两个窗口(上下各一个)
;;(split-window-vertically)
(setq initial-frame-alist '((top . 0) (left . 250) (width . 180) (height .  50)));启动自动最大化

(add-to-list 'load-path "D:\Program Files (x86)\emacs\lisp")
;;(require 'color-theme)
;;(setq color-theme-is-global t)
;;(color-theme-blackboard)

;;根据文件扩展名自动php-mode
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . c-mode))
;;开发项目时，php源文件使用其他扩展名

(load "desktop")
(desktop-load-default)
(desktop-read)

(auto-image-file-mode)

;;(display-time-mode 1) ; 显示时间
;;(setq display-time-24hr-format t) ; 24 小时格式
;;(setq display-time-day-and-date t) ; 显示日期

;; (require 'session)
;; (add-hook 'after-init-hook 'session-initialize)

;;(require 'ibuffer)
;;(global-set-key (kbd "C-x b") 'ibuffer)

;;(require 'swbuff)
;;(global-set-key (kbd "") 'swbuff-switch-to-previous-buffer)
;;(global-set-key (kbd "") 'swbuff-switch-to-next-buffer)
;;(setq swbuff-exclude-buffer-regexps
;;      '("^ " "\\*.*\\*"))

;;(setq swbuff-status-window-layout 'scroll)
;;(setq swbuff-clear-delay 1)
;;(setq swbuff-separator "|")
;;(setq swbuff-window-min-text-height 1)


;;(require 'tabbar)
;;(tabbar-mode)
(global-set-key (kbd "C-x p") 'tabbar-backward)
(global-set-key (kbd "C-x n") 'tabbar-forward)
(global-set-key (kbd "C-x C-p") 'tabbar-backward-group)
(global-set-key (kbd "C-x C-n") 'tabbar-forward-group)
(global-set-key [(control tab)] 'tabbar-forward-tab)


(global-set-key [(meta ?/)] 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
try-expand-dabbrev-visible
try-expand-dabbrev-all-buffers
try-expand-dabbrev-from-kill
try-complete-file-name-partially
try-complete-file-name
try-expand-all-abbrevs
try-expand-list
try-expand-line
try-complete-lisp-symbol-partially
try-complete-lisp-symbol))

;;临时记号
;;有时你需要跳到另一个文件进行一些操作，然后很快的跳回来。你当然可以 使用 bookmark或者寄存器。
;;但是这些实在是太慢了。你多想拥有vi那样的 ma, mb, 'a, 'b 的操作。现在你可以用几行 elisp 达到类似的目的
(global-set-key [(control ?\.)] 'ska-point-to-register)
(global-set-key [(control ?\,)] 'ska-jump-to-register)
(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
Use ska-jump-to-register to jump back to the stored
position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
        (jump-to-register 8)
        (set-register 8 tmp)))

;; (require 'wcy-swbuffer)
;; then you can use <C-tab> and <C-S-kp-tab> to switch buffer.
;; (global-set-key (kbd "<C-tab>") 'wcy-switch-buffer-forward)
;; (global-set-key (kbd "<C-S-kp-tab>") 'wcy-switch-buffer-backward)

;; (setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

;; (defun tabbar-buffer-ignore-groups (buffer)
;;   "Return the list of group names BUFFER belongs to.
;; Return only one group for each buffer."
;;   (with-current-buffer (get-buffer buffer)
;;     (cond
;;      ((or (get-buffer-process (current-buffer))
;;           (memq major-mode
;;                 '(comint-mode compilation-mode)))
;;       '("Process")
;;       )
;;      ((member (buffer-name)
;;               '("*scratch*" "*Messages*"))
;;       '("Common")
;;       )
;;      ((eq major-mode 'dired-mode)
;;       '("Dired")
;;       )
;;      ((memq major-mode
;;             '(help-mode apropos-mode Info-mode Man-mode))
;;       '("Help")
;;       )
;;      ((memq major-mode
;;             '(rmail-mode
;;               rmail-edit-mode vm-summary-mode vm-mode mail-mode
;;               mh-letter-mode mh-show-mode mh-folder-mode
;;               gnus-summary-mode message-mode gnus-group-mode
;;               gnus-article-mode score-mode gnus-browse-killed-mode))
;;       '("Mail")
;;       )
;;      (t
;;       (list
;;        "default"  ;; no-grouping
;;        (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
;;            mode-name
;;          (symbol-name major-mode)))
;;       )
;;      )))




;; w+q to shell-mode
;;(global-set-key [(f1)] ‘hs-toggle-hiding)
;;(global-set-key (kbd s-q) 'shell)

;; F4:关闭buffer
(global-set-key [(f4)] 'kill-buffer-and-window)

;; F3：打开speedbar
(global-set-key [(f3)] 'speedbar)

;;F4 跳到另一个窗口
;;(global-set-key [(f4)] 'other-window)


;;auto close shell buff when command is finished
(add-hook 'shell-mode-hook 'wcy-shell-mode-hook-func)
(defun wcy-shell-mode-hook-func  ()
  (set-process-sentinel (get-buffer-process (current-buffer))
                            #'wcy-shell-mode-kill-buffer-on-exit)
      )
(defun wcy-shell-mode-kill-buffer-on-exit (process state)
  (message "%s" state)
  (if (or
       (string-match "exited abnormally with code.*" state)
       (string-match "finished" state))
      (kill-buffer (current-buffer))))

;;代码折叠
(load-library "hideshow")

(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))
(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(global-set-key  [(f1)] 'toggle-hiding)
(global-set-key  [(f2)]  'toggle-selective-display)
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'php-mode-hook         'hs-minor-mode)
(add-hook 'javascript-mode-hook         'hs-minor-mode)
(add-hook 'html-mode-hook         'hs-minor-mode)

;;; shift the meaning of C-s and C-M-s
(global-set-key [(control s)] 'isearch-forward-regexp)
(global-set-key [(control meta s)] 'isearch-forward)
(global-set-key [(control r)] 'isearch-backward-regexp)
(global-set-key [(control meta r)] 'isearch-backward)

;; Setting English Font
(set-face-attribute
  'default nil :font "Consolas 11")
 
;; Chinese Font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset
                      (font-spec :family "Microsoft Yahei" :size 13)))

(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `wy-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
             char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))
(define-key global-map (kbd "C-c a") 'wy-go-to-char)
