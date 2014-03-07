;;; esmd.el --- Emacs Major-mode for VMD

;; Copyright (C) 2014  Salvatore M Cosseddu

;; Author: Salvatore M Cosseddu <S.M.Cosseddu@warwick.ac.uk>
;;         University of Warwick

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary: Major mode to use VMD within emacs. 
;;;             It is derived from tcl mode but allow to run an instance of VMD in a
;;;             second buffer in order to send on-the-fly the commands. It add to tcl-mode tree
;;;             keys to directly interact with VMD:
;;;             "\C-c\C-n" vmd-send-line
;;;             "\C-c\C-r" vmd-send-region
;;;             "\C-c\C-q" vmd-send-quit
;;;             USAGE:
;;;             
;;;             1. installation:
;;;             add to your .emacs file
;;;             (load "<path>/esmd.el")
;;;             you might want to add the lines
;;;             (add-to-list 'auto-mode-alist '("\\.vmd\\'" . vmd-mode))
;;;             (autoload 'vmd-mode "vmd" "Major mode for VMD." t)
;;;             any file with the extension .vmd should be recognised. You can call
;;;             the mode manually by "M-x vmd-mode";
;;;
;;;             2. run VMD within emacs use "M-x vmd-run";
;;;             
;;;             3. start working.


;;; Inspired by ESS and based on:
;;; inferior-scala-mode.el
;;; http://www.masteringemacs.org/articles/2013/07/31/comint-writing-command-interpreter/
;;; http://web.math.unifi.it/users/maggesi/mechanized/emacs/inferior-coq.el

;; 

;;; Code:

(require 'comint)
(require 'tcl)

;; ----------------------------------------------
;; relevant variables 
(defvar vmd-path "/usr/bin/env vmd -nt" 
  "Default path used by `vmd-run'.")
 
(defvar vmd-cli-arguments '()
  "Commandline arguments to pass to `vmd-run'")

;; ------------------------------
;; communication with the vmd buffer
;; (nconc (make-sparse-keymap) comint-mode-map)
(defvar vmd-mode-map
  (let ((map (nconc (make-sparse-keymap) tcl-mode-map)))
    (define-key map "\C-c\C-n" 'vmd-send-line)
    (define-key map "\C-c\C-r" 'vmd-send-region)
    (define-key map "\C-c\C-q" 'vmd-send-quit)
    map)
  "Map for vmd-mode")

(defun vmd-send-line ()
  "Send the current line to the vmd process."
  (interactive)
  (save-excursion
    (end-of-line)
    (let ((end (point)))
      (beginning-of-line)
      (vmd-send-region (point) end)))
  (next-line 1))

(defun vmd-send-region (start end)
  "Send the current region to the inferior vmd process."
  (interactive "r")
  (comint-send-region "*vmd*" start end)
  (comint-send-string "*vmd*" "\n"))

(defun vmd-send-quit ()
  "Send the command \"quit.\" to the inferior vmd process."
  (interactive)
  (comint-send-string "*vmd*" "exit\n"))





;; ------------------------------------
;; Running vmd in a new buffer
(defun vmd-running ()
  ;; True if a vmd is currently running in a buffer.
  (comint-check-proc "VMD"))

(defun vmd-run ()
  "Run an inferior instance of VMD inside Emacs."
  (interactive)
  (unless (vmd-running)
    (let ((cmd/args (split-string vmd-path)))
      (apply 'make-comint-in-buffer "VMD" "*vmd*" (car cmd/args) nil (cdr cmd/args))))
  (pop-to-buffer "*vmd*")
  (switch-to-buffer "*vmd*")
  (inf-vmd-mode))
;; ------------------------------------


;; additional useful fun
;; (defun vmd--initialize ()
;;   "Helper function to initialize VMD"
;;   (setq comint-process-echoes t))

(define-derived-mode vmd-mode tcl-mode "vmd"
  "Major mode for vmd.

The following commands are available: 
\\{vmd-mode-map}")

 
(define-derived-mode inf-vmd-mode comint-mode "VMD"
  "comint mode for vmd."
  (setq comint-prompt-read-only t))

(add-hook 'vmd-mode-hook 'turn-on-font-lock)
;;(add-hook 'inf-vmd-mode-hook 'vmd--initialize)

(provide 'esmd)
;;; esmd ends here
