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

(require 'company)
(eval-when-compile
  (require 'cl-lib))

(cl-defun company-keywords-upper-lower (&rest lst)
  ;; Upcase order is different for _.
  (nconc (cl-sort (cl-mapcar 'upcase lst) #'string<) lst))

(defvar company-scheme-keyword-r7rs
  '(* + - ... / < <= = => > >= abs and append apply assoc assq
      assv begin binary-port?  boolean=?  boolean?  bytevector
      bytevector-append bytevector-copy bytevector-copy! bytevector-length
      bytevector-u8-ref bytevector-u8-set!  bytevector?  caar cadr
      call-with-current-continuation call-with-port call-with-values call/cc
      car case cdar cddr cdr ceiling char->integer char-ready?  char<=?
      char<?  char=?  char>=?  char>?  char?  close-input-port
      close-output-port close-port complex?  cond cond-expand cons
      current-error-port current-input-port current-output-port
      define
      define-record-type define-syntax
      define-values
      denominator do
      dynamic-wind else eof-object?  equal?  error error-object-message
      even?  exact-integer-sqrt exact?  features floor floor-remainder
      flush-output-port gcd get-output-string if include-ci inexact?
      input-port?  integer?  lcm let let*-values let-values letrec* list
      list->vector list-ref list-tail make-bytevector make-parameter
      make-vector max memq min negative?  not number->string numerator
      open-input-bytevector open-output-bytevector or output-port?
      parameterize peek-u8 positive?  quasiquote quotient raise-continuable
      rationalize read-bytevector!  read-error?  read-string real?  reverse
      set!  set-cdr!  string string->number string->utf8 string-append
      eof-object eq?  eqv?  error-object-irritants error-object?  exact
      exact-integer?  expt file-error?  floor-quotient floor/ for-each
      get-output-bytevector guard include inexact input-port-open?
      integer->char lambda length let* let-syntax letrec letrec-syntax
      list->string list-copy list-set!  list?  make-list make-string map
      member memv modulo newline null?  number?  odd?  open-input-string
      open-output-string output-port-open?  pair?  peek-char port?
      procedure?  quote raise rational?  read-bytevector read-char read-line
      read-u8 remainder round set-car!  square string->list string->symbol
      string->vector string-copy string-copy!  string-for-each string-map
      string-set!  string<?  string>=?  string?  symbol->string symbol?
      syntax-rules truncate truncate-remainder u8-ready?  unquote
      utf8->string vector vector->string vector-copy vector-fill!
      vector-length vector-ref vector?  with-exception-handler write-char
      write-u8 string-fill!  string-length string-ref string<=?
      string=?  string>?  substring symbol=?  syntax-error textual-port?
      truncate-quotient truncate/ unless unquote-splicing values
      vector->list vector-append vector-copy!  vector-for-each vector-map
      vector-set!  when write-bytevector write-string zero?
      ))

(defvar company-scheme-keyword-srfi-1
  '(xcons list-tabulate circular-list not-pair? list= first second third fourth
          fifth sixth seventh eighth ninth tenth car+cdr take-right drop-right
          take! drop-right! zip unzip1 unzip2 unzip3 unzip4 unzip5 unfold pair-fold
          unfold-right pair-fold-right map! pair-for-each map-in-order partition!
          list-index take-while drop-while take-while! span break span! break!
          alist-cons lset<= lset= lset-adjoin lset-union lset-union! lset-intersection
          lset-intersection! lset-difference lset-difference! lset-xor lset-xor!
          lset-diff+intersection lset-diff+intersection! null-list? cons* last
          member take drop take-right drop-right take! drop-right! delete delete!
          delete-duplicates delete-duplicates! assoc alist-copy alist-delete alist-delete!
          any every filter filter! remove remove! filter-map fold fold-right count
          reduce reduce-right append-reverse append-reverse! concatenate concatenate!
          append-map append-map! find find-tail split-at split-at! partition iota))

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

(defvar company-scheme-keywords-alist
  ;; Please contribute corrections or additions.
  `((scheme-mode
     ,@(cl-mapcar #'symbol-name
                  (append
                   company-scheme-keyword-r7rs
                   company-scheme-keyword-srfi-1
                   company-scheme-keyword-srfi-13))))
  "Alist mapping major-modes to sorted keywords for `company-scheme'.")

;;;###autoload
(cl-defun company-scheme (command &optional arg &rest ignored)
  "`company-mode' back-end for programming language keywords."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-scheme))
    (prefix (and (assq major-mode company-scheme-keywords-alist)
                 (not (company-in-string-or-comment))
                 (or (company-grab-symbol) 'stop)))
    (candidates
     (let ((completion-ignore-case nil)
           (symbols (cdr (assq major-mode company-scheme-keywords-alist))))
       (all-completions arg (if (consp symbols)
                                symbols
                              (cdr (assq symbols company-scheme-keywords-alist))))))
    (sorted t)))

(provide 'company-scheme)
;;; company-scheme.el ends here
