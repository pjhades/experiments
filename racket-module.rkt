#lang racket

; an example demonstrating the fucking racket modules

; module zoo resides directly under the top-level module
; zoo is also a submodule under main
(module zoo racket
  (printf "module zoo~n"))

; module fruit contains a 
; fruit is also a submodule under main
(module fruit racket
  ; tropical is a nested submodule under fruit
  (module tropical racket
    (printf "module tropical~n"))
  (printf "module fruit~n"))

; A submodule can be referenced by its quoted name.
;
; Module tropical will not be executed automatically
; since it's not explicitly required by module fruit.
;
; This will execute the fruit module.
(require 'fruit)

; But we can manually load it with submod form.
;
; The fucking thing here is the base module (fruit here)
; should be specified with quoted name. The point is,
; as you intend to require a submodule, you should know
; its base module, either the current one (specified via ".")
; or some other one (specified via it's quoted name).
;
; This will execute the tropical module.
(require (submod 'fruit tropical))

; Using "." as the base module means that we want to
; require from the enclosing module (main here).
;
; What we're doing here is to require the zoo module
; within the enclosing module of this require form.
;
; This will execute the zoo module.
(require (submod "." zoo))

; Now we play with a deeply nested module
(module level1 racket
  (module level2-1 racket
    (module level3 racket
      (printf "module level3 from module2-1~n"))
    (printf "module level2-1~n"))

  (module level2-2 racket
    (module level3 racket
      (printf "module level3 from module2-2~n"))
    (printf "module level2-2~n")
    ; This submod form chooese modules level2-1
    ; from the module (level1 here) one level above
    ; the enclosing one (level2-2 here), and will
    ; execute module level2-1.
    (require (submod ".." level2-1)))

  (printf "module level1~n")
  ; This will execute module level2-2.
  (require (submod "." level2-2)))

; This will execute module level1.
(require 'level1)

; It seems that we can write
;
; (require 'mod1 'mod2 'mod3)
;
; But we can't write
;
; (require (submod "." mod1 mod2 mod3))
;
; And the output of the last example above is
;
; module level2-1
; module level2-2
; module level1
;
; So I think Racket will first process all the
; require forms in a module before executing other
; expressions in a module, because we can see from
; the output that even if the printf function is called
; before require, it is executed after the require.
