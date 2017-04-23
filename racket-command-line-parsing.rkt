#lang racket

(require racket/cmdline)
(require racket/match)

(define cur-filename (path->string (find-system-path 'run-file)))

(define things (make-hash '(; can be specified multiple times
                            (apple . 0) (banana . 0)
                            ; can be specified once
                            (cherry . 0) (donut . 0)
                            ; mutually exclusive
                            (egg . 0) (fennel . 0))))

(define (print-things)
  (define (iter pos)
    (if (false? pos)
        (printf "-----------~n")
        (begin (printf "~a: ~a~n"
                       (symbol->string (hash-iterate-key things pos))
                       (hash-iterate-value things pos))
               (iter (hash-iterate-next things pos)))))
  (let ([pos (hash-iterate-first things)])
    (printf "-----------~n")
    (iter pos)))
  
(define (parse-cmd [argv (current-command-line-arguments)])
  (define (+x str) (lambda (base) (+ base (string->number str))))

  (printf "command line arguments: ~a~n" (current-command-line-arguments))
  (command-line #:program cur-filename
                #:argv argv
                #:multi
                [("-a" "--apple") apple-arg
                                  "Specify the number of apples"
                                  (hash-update! things 'apple (+x apple-arg))]
                [("-b" "--banana") banana-arg
                                   "Specify the number of bananas"
                                   (hash-update! things 'banana (+x banana-arg))]
                #:once-each
                [("-c" "--cherry") cherry-arg
                                   "Specify the number of cherries"
                                   (hash-set! things 'cherry cherry-arg)]
                [("-d" "--donut") donut-arg
                                  "Specify the number of donuts"
                                  (hash-set! things 'donut donut-arg)]
                #:once-any
                [("-e" "--egg") egg-arg
                                "Specify the number of eggs"
                                (hash-set! things 'egg egg-arg)]
                [("-f" "--fennel") fennel-arg
                                   "Specify the number of fennels"
                                   (hash-set! things 'fennel fennel-arg)]
                #:usage-help
                "Come on this is actually of no use."
                "And you need to believe me."
                #:help-labels
                "This is the description of help labels."
                "Apparently another useless part."
                #:args
                args
                (printf "Non-option arguments: ~a~n" args)))

(define (normal)
  (parse-cmd)
  (print-things))

(define (git-like)
  (let* ([argv (current-command-line-arguments)]
         [first-arg (vector-ref argv 0)]
         [rest-args (vector-drop argv 1)])
    (match first-arg
      ["init" "initialize"]
      ["branch" "branch operations"]
      ["commit" (parse-cmd rest-args)
                (print-things)]
      ["push" "push commits to remote"]
      [_ "what?!"])))

; ./xxx -a 10 -b 90
;(normal)

; ./xxx commit -a 10 -b 90
(git-like)

