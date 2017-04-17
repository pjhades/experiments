#lang racket

; Here we want to update the values of variables given
; to `rotate` rather than constructing a new list.
; For input x=1, y=2, z=3, we want x=2, y=3, z=1.
;
; We assign the variables like this:
;    x   y   z
;    |   |   |
;    |   V   V
;    |   x   y  z
;    |          ^
;     \________/
; So here in the helper macro `shift-to`, we "align"
; the variables and then assign each one with the new value,
; which is the value of the varible next to it. Finally we
; handle the assignment of the last pair, because we cannot
; cover that pair with the `...` syntax.

(define-syntax rotate
  (syntax-rules ()
    [(rotate a c ...)
     (shift-to (c ... a) (a c ...))]))

(define-syntax shift-to
  (syntax-rules ()
    [(shift-to (from0 from ...) (to0 to ...))
     (let ([tmp from0])
       (set! to from) ...
       (set! to0 tmp))]))

(let-values ([(x y z) (values 1 2 3)])
  (printf "x=~a y=~a z=~a~n" x y z)
  (rotate x y z)
  (printf "x=~a y=~a z=~a~n" x y z))
