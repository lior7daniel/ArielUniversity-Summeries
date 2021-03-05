#lang pl

#|
********************************************************************************************************
******************************************** READ ME ***************************************************
********************************************************************************************************
Task #3

By:
Lior Daniel (ID 305257347) & Amir Adar (ID 302308168)

|#

#|
*****************************************************************************
******************************* PART A **************************************
*****************************************************************************


BNF for the MUWAE language:
       <MUWAE> ::= <num>
               | { + <MUWAE> <MUWAE> }
               | { - <MUWAE> <MUWAE> }
               | { * <MUWAE> <MUWAE> }
               | { / <MUWAE> <MUWAE> }
               | { with { <id> <MUWAE> } <MUWAE> }
               | {sqrt <MUWAE>} ;; *** part A (1) ***
               | <id>
|#

;; MUWAE abstract syntax trees
(define-type MUWAE
  [Num  (Listof Number)]
  [Add  MUWAE MUWAE]
  [Sub  MUWAE MUWAE]
  [Mul  MUWAE MUWAE]
  [Div  MUWAE MUWAE]
  [Sqrt MUWAE] ;; *** part A (2) ***
  [Id   Symbol]
  [With Symbol MUWAE MUWAE])


(: run : String -> (Listof Number))
;; evaluate a MUWAE program contained in a string
(define (run str)
  (eval (parse str)))


(: parse : String -> MUWAE)
;; parses a string containing a MUWAE expression to a MUWAE AST
(define (parse str)
  (parse-sexpr (string->sexpr str)))


(: parse-sexpr : Sexpr -> MUWAE)
;; to convert s-expressions into MUWAEs
(define (parse-sexpr sexpr)
  (match sexpr
    [(number: n) (Num (list n))]
    [(symbol: name) (Id name)]
    [(cons 'with more)
     (match sexpr
       [(list 'with (list (symbol: name) named) body)
        (With name (parse-sexpr named) (parse-sexpr body))]
       [else (error 'parse-sexpr "bad `with' syntax in ~s" sexpr)])]
    [(list '+ lhs rhs) (Add (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '- lhs rhs) (Sub (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '* lhs rhs) (Mul (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '/ lhs rhs) (Div (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list 'sqrt val) (Sqrt (parse-sexpr val))] ;; *** part A (3) ***
    [else (error 'parse-sexpr "bad syntax in ~s" sexpr)]))


#| Formal specs for `eval':
       eval(N)         = N
       eval({+ E1 E2}) = eval(E1) + eval(E2)
       eval({- E1 E2}) = eval(E1) - eval(E2)
       eval({* E1 E2}) = eval(E1) * eval(E2)
       eval({/ E1 E2}) = eval(E1) / eval(E2)
       eval({sqrt E1}) = (sqrt (eval (E1))) ;; *** part A (6) ***
       eval(id)        = error!
       eval({with {x E1} E2}) = eval(E2[eval(E1)/x])
|#
(: eval : MUWAE -> (Listof Number))
;; evaluates MUWAE expressions by reducing them to numbers
(define (eval expr)
  (cases expr
    [(Num n) n]
    [(Add l r) (bin-op + (eval l) (eval r))]
    [(Sub l r) (bin-op - (eval l) (eval r))]
    [(Mul l r) (bin-op * (eval l) (eval r))]
    [(Div l r) (cond
                 [(equal? (eval r) '(0))(error 'eval "cannot divide by zero")]
                 [else (bin-op / (eval l) (eval r))])]
    [(Sqrt val) (sqrt+ (eval val))]
    [(With bound-id named-expr bound-body)
     (eval (subst bound-body bound-id (Num (eval named-expr))))]
    [(Id name) (error 'eval "free identifier: ~s" name)]))


#| Formal specs for `subst':
     (`N' is a <num>, `E1', `E2' are <MUWAE>s, `x' is some <id>, `y' is a
     *different* <id>)
        N[v/x]                = N
        {+ E1 E2}[v/x]        = {+ E1[v/x] E2[v/x]}
        {- E1 E2}[v/x]        = {- E1[v/x] E2[v/x]}
        {* E1 E2}[v/x]        = {* E1[v/x] E2[v/x]}
        {/ E1 E2}[v/x]        = {/ E1[v/x] E2[v/x]}
        {sqrt E1}[v/x]        = {sqrt E1[v/x]} ;; *** part A (4) ***
        y[v/x]                = y
        x[v/x]                = v
        {with {y E1} E2}[v/x] = {with {y E1[v/x]} E2[v/x]}
        {with {x E1} E2}[v/x] = {with {x E1[v/x]} E2}
|#
(: subst : MUWAE Symbol MUWAE -> MUWAE)
;; substitutes the second argument with the third argument in the
;; first argument, as per the rules of substitution; the resulting
;; expression contains no free instances of the second argument
(define (subst expr from to)
  (cases expr
    [(Num n) expr]
    [(Add l r) (Add (subst l from to) (subst r from to))]
    [(Sub l r) (Sub (subst l from to) (subst r from to))]
    [(Mul l r) (Mul (subst l from to) (subst r from to))]
    [(Div l r) (Div (subst l from to) (subst r from to))]
    [(Sqrt val) (Sqrt (subst val from to))] ;; *** part A (5) ***
    [(Id name) (if (eq? name from) to expr)]
    [(With bound-id named-expr bound-body)
     (With bound-id (subst named-expr from to) (if (eq? bound-id from)
                                                   bound-body
                                                   (subst bound-body from to)))]))


(: sqrt+ : (Listof Number) -> (Listof Number))
;; a version of `sqrt' that takes a list of numbers, and return a list
;; with twice the elements, holding the two roots of each of the inputs
;; throws an error if any input is negative. 
(define (sqrt+ ns)
  (cond [(null? ns) '()]
        [(< (first ns) 0) (error 'eval "`sqrt' requires a nonnegative input")]
        [else (cons (sqrt (first ns)) (cons (- (sqrt (first ns))) (sqrt+ (rest ns))))]))

              
(: bin-op : (Number Number -> Number) (Listof Number) (Listof Number) -> (Listof Number))
;; applies a binary numeric function on all combinations of numbers from
;; the two input lists, and return the list of all of the results
(define (bin-op op ls rs)
  (: helper : Number (Listof Number) -> (Listof Number))
  (define (helper l rs)
    (: f : Number -> Number)
    (define (f n)
      (op l n))
    (map f rs))
  (if (null? ls) null
      (append (helper (first ls) rs) (bin-op op (rest ls) rs))))


;; tests
(test (run "{with}") =error> "bad `with' syntax in (with)")
(test (run "{as {3}}") =error> "bad syntax in (as (3))")
(test (run "{/ 5 0}") =error> "cannot divide by zero")
(test (run "{with {x 4} {* x x}}") => '(16))
(test (run "{with {x 4} {/ x x}}") => '(1))
(test (run "{with {x 4} {sqrt x}}") => '(2 -2))
(test (run "{with {x -4} {sqrt x}}") =error> "`sqrt' requires a nonnegative input")
(test (run "5") => '(5))
(test (run "{sqrt 0}") => '(0 0)) 
(test (run "{sqrt 9}") => '(3 -3))
(test (run "{+ 5 5}") => '(10))
(test (run "{with {x {+ 5 5}} {+ x x}}") => '(20))
(test (run "{with {x 5} {+ x x}}") => '(10))
(test (run "{with {x {+ 5 5}} {with {y {- x 3}} {+ y y}}}") => '(14))
(test (run "{with {x 5} {with {y {- x 3}} {+ y y}}}") =>'(4))
(test (run "{with {x 5} {+ x {with {x 3} 10}}}") => '(15))
(test (run "{with {x 5} {+ x {with {x 3} x}}}") => '(8))
(test (run "{with {x 5} {+ x {with {y 3} x}}}") => '(10))
(test (run "{with {x 5} {with {y x} y}}") => '(5))
(test (run "{with {x 5} {with {x x} x}}") => '(5))
(test (run "{with {x 1} y}") =error> "free identifier")
(test (run "{+ {sqrt 1} 3}") => '(4 2))
(test (run "{+ {/ {+ {sqrt 1} 3} 2} {sqrt 100}}") => '(12 -8 11 -9))
(test (run "{sqrt {+ 16 {* {+ 1 {sqrt 1}} {/ 9 2}}}}") => '(5 -5 4 -4))

#|
{call {fun {x}
           {* x x}}
      5}


sqr = {fun {x}
           {* x x}}
{+ {sqr 5}
   {sqr 6}}

[parameter: 'x
            body:  (Mul (Id 'x) (Id 'x))
            ]

((lambda (x)
   (* x x)) 5)
(f 5)
|#

#|
*****************************************************************************
******************************* PART B **************************************
*****************************************************************************
|#

#|

<WAE> ::= <num> 
   | {+ <WAE> <WAE>}
   | {-  <WAE> <WAE>}
   | {* <WAE> <WAE>}
   | {/ <WAE> <WAE>}
   | {with {<id> <WAE>} <WAE>}
   | <id>

|#



(define-type WAE
  [NumW Number]
  [AddW WAE WAE]
  [SubW WAE WAE]
  [MulW WAE WAE]
  [DivW WAE WAE]
  [IdW Symbol]
  [WithW Symbol WAE WAE])



(: parse-sexprW : Sexpr -> WAE) 
(define (parse-sexprW sexpr)
  (match sexpr
    [(number: n) (NumW n)]
    [(symbol: name) (IdW name)]
    [(cons 'with more)
     (match sexpr
       [(list 'with (list (symbol: name) named) body)
        (WithW name (parse-sexprW named) (parse-sexprW body))]
       [else (error 'parse-sexprW "bad `with' syntax in ~s" sexpr)])]
    [(list '+ lhs rhs) (AddW (parse-sexprW lhs) (parse-sexprW rhs))]
    [(list '- lhs rhs) (SubW (parse-sexprW lhs) (parse-sexprW rhs))]
    [(list '* lhs rhs) (MulW (parse-sexprW lhs) (parse-sexprW rhs))]
    [(list '/ lhs rhs) (DivW (parse-sexprW lhs) (parse-sexprW rhs))]
    [else (error 'parse-sexprW "bad syntax in ~s" sexpr)]))

(: parseW : String -> WAE)
(define (parseW str)
  (parse-sexprW (string->sexpr str)))



#| Formal specs for `subst':
   (`N' is a <num>, `E1', `E2' are <WAE>s, `x' is some <id>,
   `y' is a *different* <id>)
      N[v/x]                = N
      {+ E1 E2}[v/x]        = {+ E1[v/x] E2[v/x]}
      {- E1 E2}[v/x]        = {- E1[v/x] E2[v/x]}
      {* E1 E2}[v/x]        = {* E1[v/x] E2[v/x]}
      {/ E1 E2}[v/x]        = {/ E1[v/x] E2[v/x]}
      y[v/x]                = y
      x[v/x]                = v
      {with {y E1} E2}[v/x] = {with {y E1[v/x]} E2[v/x]}
      {with {x E1} E2}[v/x] = {with {x E1[v/x]} E2}
|#



(: substW : WAE Symbol WAE -> WAE)
(define (substW expr from to)
  (cases expr
    [(NumW n) expr]
    [(AddW l r) (AddW (substW l from to) (substW r from to))]
    [(SubW l r) (SubW (substW l from to) (substW r from to))]
    [(MulW l r) (MulW (substW l from to) (substW r from to))]
    [(DivW l r) (DivW (substW l from to) (substW r from to))]
    [(IdW name) (if (eq? name from) to expr)]
    [(WithW bound-id named-expr bound-body)
     (WithW bound-id
           (substW named-expr from to)
           (if (eq? bound-id from)
               bound-body
               (substW bound-body from to)))]))


(: freeInstanceList : WAE -> (Listof Symbol))
(define (freeInstanceList expr)
    (cases expr
      [(NumW n) '()]
      [(AddW l r) (append (freeInstanceList l) (freeInstanceList r))]
      [(SubW l r) (append (freeInstanceList l) (freeInstanceList r))]
      [(MulW l r) (append (freeInstanceList l) (freeInstanceList r))]
      [(DivW l r) (append (freeInstanceList l) (freeInstanceList r))]
      [(WithW bound-id named-expr bound-body)
       (append (freeInstanceList named-expr) (freeInstanceList (substW bound-body bound-id (NumW 0))))]
      [(IdW freeIn) (list freeIn)]))


(test (freeInstanceList (parseW "{w {4} {f}}")) =error> "bad syntax in (w (4) (f))")
(test (freeInstanceList (parseW "{with}")) =error> "bad `with' syntax in (with)")
(test (freeInstanceList (parseW "w")) => '(w))
(test (freeInstanceList (parseW "{with {xxx 2} {with {xxx 3} {* xxx xxx}}}")) => '())
(test (freeInstanceList (parseW "{with {xxx 2} {with {yyy 3} {+ {- xx y} z}}}")) => '(xx y z))
(test (freeInstanceList (parseW "{with {xxx 2} {with {yyy 3} {* {/ xx y} z}}}")) => '(xx y z))
(test (freeInstanceList (WithW 'x (NumW 2) (AddW (IdW 'x) (NumW 3)))) => '())
(test (freeInstanceList (parseW "{+ z {+ x z}}")) => '(z x z))

