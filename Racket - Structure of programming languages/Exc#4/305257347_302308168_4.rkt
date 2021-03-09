;; The Flang interpreter

#lang pl

#| The grammar:

 <FLANG> ::= <num> ;; Rule 1
 | { + <FLANG> <FLANG> } ;; Rule 2
 | { - <FLANG> <FLANG> } ;; Rule 3
 | { * <FLANG> <FLANG> } ;; Rule 4
 | { / <FLANG> <FLANG> } ;; Rule 5
 | { with { <id> <FLANG> } <FLANG> } ;; Rule 6
 | <id> ;; Rule 7
 | { fun { <id> } <FLANG> } ;; Rule 8
 | { call <FLANG> <FLANG> } ;; Rule 9
;;Here we add the "fill-in" lines 
 | { 'True <FLANG> } ;; add rule for True ;; Rule 10
 | { 'False <FLANG> } ;; Rule 11
 | { = <FLANG> <FLANG> } ;; add rule for = ;; Rule 12
 | { < <FLANG> <FLANG> } ;; Rule 13
 | { > <FLANG> <FLANG> } ;; Rule 14
 | { 'not <FLANG> } ;; Rule 15
 | { 'if { <FLANG> } {then-do <FLANG>}
                     {else-do <FLANG>}} ;; add rule 16 for (the above) if expressions




  Evaluation rules:

    eval:
      eval(N)            = N
      eval({+ E1 E2})    = eval(E1) + eval(E2)  \ if both E1 and E2
      eval({- E1 E2})    = eval(E1) - eval(E2)   \ evaluate to numbers
      eval({* E1 E2})    = eval(E1) * eval(E2)   / otherwise error!
      eval({/ E1 E2})    = eval(E1) / eval(E2)  /
      eval(id)           = error!
      eval({with {x E1} E2}) = eval(E2[eval(E1)/x])
      eval(FUN)          = FUN ; assuming FUN is a function expression
      eval({call E1 E2}) = eval(Ef[eval(E2)/x]) if eval(E1)={fun {x}Ef}
                         = error!               otherwise
  |#

(define-type FLANG
  [Num  Number]
  [Add  FLANG FLANG]
  [Sub  FLANG FLANG]
  [Mul  FLANG FLANG]
  [Div  FLANG FLANG]
  [Id   Symbol]
  [With Symbol FLANG FLANG]
  [Fun  Symbol FLANG]
  [Call FLANG FLANG] 
  ;; for this task we addad those lines
  ;; first we add 5 new constractors for boolean, greater than, smaller than, equal than, not statment and if else condition.
  [Bool Boolean]
  [GreaterThan FLANG FLANG]
  [SmallerThan FLANG FLANG]
  [Equal FLANG FLANG]
  [Not FLANG]
  [If FLANG FLANG FLANG])

(: parse-sexpr : Sexpr -> FLANG)
;; to convert s-expressions into FLANGs
(define (parse-sexpr sexpr)
  (match sexpr
    [(number: n)    (Num n)]
    ['True (Bool true)]
    ['False (Bool false)]
    [(symbol: name) (Id name)]
    [(cons 'with more)
     (match sexpr
       [(list 'with (list (symbol: name) named) body)
        (With name (parse-sexpr named) (parse-sexpr body))]
       [else (error 'parse-sexpr "bad `with' syntax in ~s" sexpr)])]
    [(cons 'fun more)
     (match sexpr
       [(list 'fun (list (symbol: name)) body)
        (Fun name (parse-sexpr body))]
       [else (error 'parse-sexpr "bad `fun' syntax in ~s" sexpr)])]
    [(list '+ lhs rhs) (Add (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '- lhs rhs) (Sub (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '* lhs rhs) (Mul (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '/ lhs rhs) (Div (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list 'call fun arg) (Call (parse-sexpr fun) (parse-sexpr arg))]
    ;; for this task we addad those lines 
    [(list '= lhs rhs) (Equal (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '> lhs rhs) (GreaterThan (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list '< lhs rhs) (SmallerThan (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list 'not exp) (Not (parse-sexpr exp))]
    [(cons 'if more)
     (match sexpr
       [(list 'if condition (list 'then-do then) (list 'else-do else))
        (If (parse-sexpr condition) (parse-sexpr then) (parse-sexpr else))]
       [else (error 'parse-sexpr "bad `if' syntax in ~s" sexpr)])]
    [else (error 'parse-sexpr "bad syntax in ~s" sexpr)]))

(: parse : String -> FLANG)
;; parses a string containing a FLANG expression to a FLANG AST
(define (parse str)
  (parse-sexpr (string->sexpr str)))

#|
    subst:
    N[v/x] = N
   {+ E1 E2}[v/x] = {+ E1[v/x] E2[v/x]}
   {- E1 E2}[v/x] = {- E1[v/x] E2[v/x]}
   {* E1 E2}[v/x] = {* E1[v/x] E2[v/x]}
   {/ E1 E2}[v/x] = {/ E1[v/x] E2[v/x]}
   y[v/x] = y
   x[v/x] = v
   {with {y E1} E2}[v/x] = {with {y E1[v/x]} E2[v/x]} ; if y =/= x
   {with {x E1} E2}[v/x] = {with {x E1[v/x]} E2}
   {call E1 E2}[v/x] = {call E1[v/x] E2[v/x]}
   {fun {y} E}[v/x] = {fun {y} E[v/x]} ; if y =/= x 
   {fun {x} E}[v/x] = {fun {x} E}
   B[v/x] = B ;; B is Boolean
;;
   {= E1 E2}[v/x] = {= E1[v/x] E2[v/x]}
   {> E1 E2}[v/x] = {> E1[v/x] E2[v/x]}
   {< E1 E2}[v/x] = {< E1[v/x] E2[v/x]}
   { not E}[v/x] = {not E[v/x]}
   {if Econd {then-do Edo} {else-do Eelse}}[v/x]
                = {if Econd[v/x] {then-do Edo[v/x]}
                                 {else-do Eelse[v/x]}}
|#


(: subst : FLANG Symbol FLANG -> FLANG)
;; substitutes the second argument with the third argument in the
;; first argument, as per the rules of substitution; the resulting
;; expression contains no free instances of the second argument
;;
(define (subst expr from to)
  (cases expr
    [(Num n) expr]
    [(Add l r) (Add (subst l from to) (subst r from to))]
    [(Sub l r) (Sub (subst l from to) (subst r from to))]
    [(Mul l r) (Mul (subst l from to) (subst r from to))]
    [(Div l r) (Div (subst l from to) (subst r from to))]
    [(Id name) (if (eq? name from) to expr)]
    [(With bound-id named-expr bound-body)
     (With bound-id
           (subst named-expr from to)
           (if (eq? bound-id from)
               bound-body
               (subst bound-body from to)))]
    [(Call l r) (Call (subst l from to) (subst r from to))]
    [(Fun bound-id bound-body)
     (if (eq? bound-id from)
         expr
         (Fun bound-id (subst bound-body from to)))]
    ;;we add the folowing lines in order to use subst with the '> '< '= 'not 'if 'else in the substitution.
    [(Bool b) (if (eq? b from) to expr)]
    [(Equal l r) (Equal (subst l from to) (subst r from to))]
    [(GreaterThan l r) (GreaterThan (subst l from to) (subst r from to))]
    [(SmallerThan l r) (SmallerThan (subst l from to) (subst r from to))]
    [(Not n) (Not (if (eq? n from) to expr))]
    [(If condition then-do else-do)
     (If (subst condition from to)
         (subst then-do from to)
         (subst else-do from to))]))



;; The following function is used in multiple places below,
;; hence, it is now a top-level definition

(: Num->number : FLANG -> Number)
;; gets a FLANG -- presumably a Num variant -- and returns the
;; unwrapped number
(define (Num->number e)
  (cases e
    [(Num n) n]
    [else (error 'Num->number "expected a number, got: ~s" e)]))



(: arith-op : (Number Number -> Number) FLANG FLANG -> FLANG)
;; gets a Racket numeric binary operator, and uses it within a FLANG
;; `Num' wrapper
(define (arith-op op expr1 expr2)
  (Num (op (Num->number expr1) (Num->number expr2))))



(: logic-op : (Number Number -> Boolean) FLANG FLANG -> FLANG)
;; gets a Racket Boolean binary operator (on numbers), and applies it
;; to two `Num' wrapped FLANGs
(define (logic-op op expr1 expr2)
  (Bool (op (Num->number expr1) (Num->number expr2))))



(: flang->bool : FLANG -> Boolean)
;; gets a Flang E (of any kind) and returns a its appropiate
;; Boolean value -- which is true if and only if E does not
;; represent false
;; Remark: the `flang->bool` function will also be top-level
;; since it's used in more than one place.

;; we will return #t for every case which is not absulote FALSE
(define (flang->bool e)
  (cases e
    [(Bool true) (if true #t #f)]
    [else #t]))

#|
  (: arith-op : (Number Number -> Number) FLANG FLANG -> FLANG)
  ;; gets a Racket numeric binary operator, and uses it within a FLANG
  ;; `Num' wrapper
  (define (arith-op op expr1 expr2)
    (: Num->number : FLANG -> Number)
    (define (Num->number e)
      (cases e
        [(Num n) n]
        [else (error 'arith-op "expects a number, got: ~s" e)]))
    (Num (op (Num->number expr1) (Num->number expr2))))
|#


(: eval : FLANG -> FLANG)
;; evaluates FLANG expressions by reducing them to expressions
(define (eval expr)
  (cases expr
    [(Num n) expr]      
    [(Bool b) expr]
    [(GreaterThan l r) (logic-op > (eval l) (eval r))]
    [(SmallerThan l r) (logic-op < (eval l) (eval r))]
    [(Equal l r) (logic-op = (eval l) (eval r))]
    [(If l m r)
     (let ([fl (eval l)])
       (if (flang->bool fl) (eval m) (eval r)))]
    [(Not exp) (Bool (not (flang->bool (eval exp))))]
    [(Add l r) (arith-op + (eval l) (eval r))]
    [(Sub l r) (arith-op - (eval l) (eval r))]
    [(Mul l r) (arith-op * (eval l) (eval r))] 
    [(Div l r) (arith-op / (eval l) (eval r))]
    [(With bound-id named-expr bound-body)
     (eval (subst bound-body
                  bound-id
                  (eval named-expr)))]
    [(Id name) (error 'eval "free identifier: ~s" name)]
    [(Fun bound-id bound-body) expr]
    [(Call fun-expr arg-expr)
     (let([fval (eval fun-expr)])
       (cases fval
         [(Fun bound-id bound-body)
          (eval (subst bound-body
                       bound-id
                       (eval arg-expr)))]
         [else (error 'eval "`call' expects a function, got: ~s"
                      fval)]))]))
#|
  (: run : String -> Number)
  ;; evaluate a FLANG program contained in a string
  (define (run str)
    (let ([result (eval (parse str))])
      (cases result
        [(Num n) n]
        [else (error 'run
                     "evaluation returned a non-number: ~s" result)])))
|#

(: run : String -> (U Number Boolean FLANG))
;; evaluate a FLANG program contained in a string
;; cases for result : Num, Bool, Not (Bool)
;; else eval on result
(define (run str)
  (let ([result (eval (parse str))])
    (cases result
      [(Num num) num]
      [(Bool bool) bool]
      [(Not b) b]
      [else result])))




;; tests


(test (run "{call 4 {4}}") =error> "")
(test (run "{call {fun {x} {+ x 1}} 4}") => 5)
(test (run "{with {add3 {fun {x} {+ x 3}}} {call add3 1}}") => 4)
(test (run "{with {add3 {fun {x} {+ x 3}}} {with {add1 {fun {x} {+ x 1}}} {with {x 3} {call add1 {call add3 x}}}}}") => 7)
(test (run "{call {x} {x}}") =error> "")
(test (run "{with {x 5} {with {x 3} {+ x x}}}") => 6)  
(test (run "{with {x 8} {if {> x 0} {then-do {- 2 x}} {else-do x}}}") => -6)
(test (run "{- 0 0}") => 0)
(test (run "{asd}") =error> "asd")
(test (run "{= 3 44}") => false)
(test (run "{= 3 3}") => true)
(test (run "{if asd}") =error> "bad `if' syntax in (if asd)")
(test (run "{fun asd}") =error> "bad `fun' syntax in (fun asd)")
(test (run "{with asd}") =error> "bad `with' syntax in (with asd)")
(test (run "True") => true)
(test (run "{not True}") => false)
(test (run "{> 3 44}") => false)
(test (run "{if {- 3 3} {then-do 4} {else-do 5}}") => 4)
(test (run "{with {x 8} {if {> x 0} {then-do {/ 2 x}} {else-do x}}}") => 1/4)
(test (run "{with {x -8} {if {< x 0} {then-do {/ 2 x}} {else-do x}}}") => -1/4)
(test (run "{with {x -8} {if {= x -8} {then-do {/ 2 x}} {else-do x}}}") => -1/4)
(test (run "{with {x 8} {if {> x 0} {then-do {* 2 x}} {else-do x}}}") => 16)
(test (run "{with {x 0} {if {> x 0} {then-do {/ 2 x}} {else-do x}}}") => 0)
(test (run "{if {> 2 1} {then-do True} {else-do {+ 2 2}}}") => true)
(test (run "{if {> 2 1} {then-do False} {else-do {- 2 2}}}") => false)
(test (run "{if {< 2 1} {then-do False} {else-do {- 2 2}}}") => 0)
(test (run "{with {c True} {if c {then-do {> 2 1}} {else-do 2}}}") => true)
(test (run "{with {foo {fun {x}{if {< x 2} {then-do x} {else-do {/ x 2}}}}} foo}") => (Fun 'x (If (SmallerThan (Id 'x) (Num 2)) (Id 'x) (Div (Id 'x) (Num 2)))))
(test (run "{with {x 0} {if {> x 0} {/ 2 x} x}}") =error> "parse-sexpr: bad `if' syntax in (if (> x 0) (/ 2 x) x)")
(test (run "true") =error> "eval: free identifier: true")
(test (run "{< false 5}") =error> "eval: free identifier: false")
(test (run "{< False 5}") =error> "Num->number: expected a number, got: #(struct:Bool #f)")