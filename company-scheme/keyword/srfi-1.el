;;; srfi-1.el -*- lexical-binding: t -*-

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

(provide 'company-scheme-keyword-srfi-1)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
