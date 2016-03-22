;;; company-scheme.el --- A company back-end for programming language keywords

;; Copyright (C) 2009-2011  Free Software Foundation, Inc.

;; Author: Nikolaj Schumacher

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:
;;

;;; Code:

(eval-when-compile
  (require 'cl-lib))
(require 'company)
(require 'company-scheme-keyword-r7rs "company-scheme/keyword/r7rs")
(require 'company-scheme-keyword-srfi-1 "company-scheme/keyword/srfi-1")

(defvar company-scheme-keyword-srfi-13
  '(string-null? string-every string-any string-tabulate reverse-list->string
    substring/shared string-copy! string-take string-take-right
    string-drop string-drop-right string-pad string-pad-right string-trim
    string-trim-right string-trim-both string-compare string-compare-ci
    string= string<> string< string> string<= string>= string-ci=
    string-ci<> string-ci< string-ci> string-ci<= string-ci>=
    string-hash string-hash-ci string-prefix-length string-suffix-length
    string-prefix-length-ci string-suffix-length-ci string-prefix?
    string-suffix? string-prefix-ci? string-suffix-ci? string-index
    string-index-right string-skip string-skip-right string-count
    string-contains string-contains-ci string-titlecase
    string-titlecase! string-upcase string-upcase! string-downcase
    string-downcase! string-reverse string-reverse! string-concatenate
    string-append/shared string-concatenate/shared string-concatenate-reverse
    string-concatenate-reverse/shared string-map string-map!
    string-fold string-fold-right string-unfold string-unfold-right
    string-for-each string-for-each-index xsubstring string-xcopy!
    string-replace string-tokenize string-filter string-delete
    string-parse-start+end string-parse-final-start+end let-string-start+end
    check-substring-spec substring-spec-ok? make-kmp-restart-vector
    kmp-step string-kmp-partial-search string? make-string string
    string->list list->string string-join string-length string-ref
    string-copy string-set! string-fill! string-append))

(defvar company-scheme-keyword-srfi-106
  '(make-client-socket make-server-socket call-with-socket
    socket-input-port socket-output-port
    socket-merge-flags socket-purge-flags
    socket-accept socket-send socket-recv socket-shutdown socket-close
    *af-unspec* *af-inet* *af-inet6*
    *sock-stream* *sock-dgram*
    *ai-canonname* *ai-numerichost*
    *ai-v4mapped* *ai-all* *ai-addrconfig*
    *ipproto-ip* *ipproto-tcp* *ipproto-udp*
    *msg-none* *msg-peek* *msg-oob* *msg-waitall*
    *shut-rd* *shut-wr* *shut-rdwr*
    address-family socket-domain address-info
    ip-protocol message-type shutdown-method))

(defvar company-scheme-keywords-list
  (cl-mapcar #'symbol-name
             (append
              company-scheme-keyword-r7rs
              company-scheme-keyword-srfi-1
              company-scheme-keyword-srfi-13
              company-scheme-keyword-srfi-106)))

(cl-defun company-scheme-candidates (prefix)
  (let ((completion-ignore-case nil)
        (symbols company-scheme-keywords-list))
    (all-completions prefix symbols)))

;;;###autoload
(cl-defun company-scheme-backend (command &optional arg &rest ignored)
  "`company-mode' back-end for programming language keywords."
  (interactive (list 'interactive))
  (pcase command
    (`interactive (company-begin-backend 'company-scheme-backend))
    (`prefix (and (eq  major-mode 'scheme-mode)
                  (company-grab-symbol)))
    (`candidates
     (company-scheme-candidates arg))
    (`meta (format "This value is named %s" arg))))

(provide 'company-scheme)
;;; company-scheme.el ends here
