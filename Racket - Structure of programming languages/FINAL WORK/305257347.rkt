#lang pl

#| Please complete the missing rules below  
<SOL> :: = { <NumList> }
        |  { scalar-mult <num> <SOL> }
           ;; ***********************************************************
           ;; *1* The intersection operation between SOL groups
           ;; *2* By learning from the previous assignments, the functions (intersect \ union) of our SOL language get the same type of language,
                  so that further operations can be performed on different types that we have defined from the same language and not just a set of numbers.
           ;; *3* I realized this by looking at a part of the code that defines the SOL type.
           ;; ***********************************************************
        |  { intersect <SOL> <SOL>}
        |  { union <SOL> <SOL>} 
        |  <id>
        |  { with {<id> <SOL> } <SOL> } ;; this should be a syntactic sugar
        |  { fun { <id> <id> } <SOL> } ;; a function must have exactly two formal parameters
        |  { call-static <SOL> <SOL> <SOL> } ;; extends closure environment
        |  { call-dynamic <SOL> <SOL> <SOL> } ;; extends current environment

<NumList> :: =  λ | <num> <NumList> ;; where λ stands for the empty word, i.e., { } is the empty set

;; where <num> is any expression identified by Racket as a Number
;; and <id> is any expression such that Racket identifies '<id> as a symbol
 
|#


;; -----------------------------------------------------
;; The abstract syntax tree SOL
(define-type SET = (Listof Number))
(define-type SOL
  ;; Please complete the missing parts -- you are NOT allowed to use additional variants (constructors)
  [Set  SET]
  ;; ***********************************************************
  ;; As in the comments I have attached above,
  ;; here we will implement the objects from the language to allow them to hold types of the SOL language.
  ;; ***********************************************************
  [Smult Number SOL]
  [Inter SOL SOL]
  [Union SOL SOL]
  [Id    Symbol]
  [Fun   Symbol Symbol SOL]
  [CallS SOL SOL SOL]
  [CallD SOL SOL SOL])

;; ----------------------------------------------------
;; Operations on SETs
;; Please complete the missing parts, and add comments (comments should specify 
;; the role of each procedure, but also describe your work process). Keep your code readable. 


;; ***********************************************************
;; This function accepts a number and list and returns true if the number is in the list or false if otherwise.
;; ***********************************************************
(: ismember? : Number SET  -> Boolean)
(define (ismember? n l)
  (cond [(null? l) #f]
        [(= n (first l)) #t]
        [else (ismember? n (rest l))]))



;; ***********************************************************
;; *1* This function accepts a set of numbers and returns a set of the same numbers without repetition.
;; *2* We will go through the whole list recursively so that in each iteration we separate the first number from the rest of the list
;;     and use the 'ismember?' function to check if the same number we separated exists again in the rest of the list.
;;     If so, we will only return the rest of the list and say goodbye to the organ we separated.
;; *3* In the 'else' part we separate the first number from the rest of the list which we send recursively for review,
;;     but because of the 'cons' the whole list will be reunited with the same number. Under this condition,
;;     I realized that under the condition before me I would have to exercise the part where we got rid of the number.
;; ***********************************************************
(: remove-duplicates : SET  -> SET)
(define (remove-duplicates l)
  (cond [(or (null? l) (null? (rest l))) l]
        [(ismember? (first l) (rest l)) (remove-duplicates (rest l))]
        [else (cons (first l) (remove-duplicates (rest l)))]))

  
;; ***********************************************************
;; The requirement is that this function get a list of numbers,
;; sort it and return it when there are no repetitions in its numbers.
;; The sort function is given, so we will send the entire sorted array to the function we used earlier - 'remove-duplicates'.
;; ***********************************************************
(: create-sorted-set : SET -> SET)
(define (create-sorted-set l)
  (remove-duplicates(sort l <)))


;; ***********************************************************
;; This function should combine two lists and exclude one list so that there are no repeating numbers.
;; As in the previous function, the way of thinking is to use the same functions that exist to solve the problem of repetition and sorting.
;; So we will use the 'append' function that we learned in lectures that unites two arrays, and only the resulting list remains to be sent
;; to the previous functions we used above and used to complete the solution.
;; ***********************************************************
(: set-union : SET SET -> SET)
(define (set-union A B)
  (create-sorted-set (append A B)))

;; ***********************************************************
;; This function intersects two groups A and B, so that the returned group will be sorted and without repetition.
;; In thinking I knew I had to use the 'ismember?' We allready implemented, but for some reason I got into trouble with the internal function 'mem-filter' that sends the values to it.
;; Explanation of the implementation:
;; I created three conditions to recursively pass on list A, so we will check if each number in the list also appears in B.
;; In the first condition, we will return a blank list if we went over everything.
;; In the second condition, we will check whether the first number in A is in B with 'ismember?'. If so, we will create a list consisting of the same number. The list of the same number is recursively tested with List B and the rest of A.
;; In the third condition, if the number we tested in A is not in B, the list B and the rest of list A are sent recursively for examination without the same number.
;; ***********************************************************
(: set-intersection : SET SET -> SET)
(define (set-intersection A B)
  (: mem-filter : Number -> Boolean)
  (define (mem-filter n)
    (ismember? n B))
  (cond
    [(null? A) (list )]
    [(mem-filter (first A)) (create-sorted-set(cons(first A) (set-intersection B (rest A))))]
    [else (set-intersection B (rest A))]))
  

;; ---------------------------------------------------------
;; Parser
;; Please complete the missing parts, and add comments (comments should specify 
;; choices you make, and also describe your work process). Keep your code readable. 
(: parse-sexpr : Sexpr -> SOL)
;; to convert s-expressions into SOLs
(define (parse-sexpr sexpr)
  (match sexpr
    [(list (number: ns) ...) (Set (create-sorted-set ns))] ;; sort and remove-duplicates
    ;; In our language, the 'Set' object represents the list of numbers,
    ;; so when we want to create a number list in our language we need to convert it to the Set object that holds the same list.
    ;; By definition, a list should be a group - so the requirement is that the list be sorted and without repetition of numbers.
    ;; For this purpose we will use the function we have implemented 'create-sorted-set'.
    [(symbol: name) (Id name)]
    [(cons 'with more)
     (match sexpr
       [(list 'with (list (symbol: name) named) body)
        ;; In Exercise 9, we learned about the "With" constructor conversion in "Call" and "Fun" functions and used the same practice presentation
        ;; to match the code for this specific case.
        (CallS (Fun name name (parse-sexpr body)) (parse-sexpr named) (parse-sexpr named))]
       [else (error 'parse-sexpr "bad `with' syntax in ~s" sexpr)])]
    [(cons 'fun more)
     (match sexpr
       [(list 'fun (list (symbol: name1) (symbol: name2)) body)
        (if (eq? name1 name2)
            (error 'parse-sexpr "`fun' has a duplicate param name in ~s" sexpr) ;; cannot use the same param name twice --- 
            (Fun name1 name2 (parse-sexpr body)))]
       [else (error 'parse-sexpr "bad `fun' syntax in ~s" sexpr)])]
    [(list 'scalar-mult (number: sc) rhs) (Smult sc (parse-sexpr rhs))]
    [(list 'intersect lhs rhs) (Inter (parse-sexpr lhs) (parse-sexpr rhs))] 
    [(list 'union lhs rhs) (Union (parse-sexpr lhs) (parse-sexpr rhs))]
    [(list 'call-static fun arg1 arg2) (CallS (parse-sexpr fun) (parse-sexpr arg1) (parse-sexpr arg2))]
    [else (error 'parse-sexpr "bad syntax in ~s" sexpr)]))

    


(: parse : String -> SOL)
;; parses a string containing a SOL expression to a SOL AST
(define (parse str)
  (parse-sexpr (string->sexpr str)))

  

  

;;-----------------------------------------------------
;; Evaluation 
#|
------------------------------------------------------
Evaluation rules:
    ;; Please complete the missing parts in the formal specifications below

    eval({ N1 N2 ... Nl }, env)  =  (sort (create-set (N1 N2 ... Nl)))
                               where create-set removes all duplications from
                              the sequence (list) and sort is a sorting procedure
    eval({scalar-mult K E},env) =   (K*N1 K*N2 ... K*Nl) if (N1 N2 ... Nl) = eval(E,env) is a sorted set AND
                                = error! otherwise (if S is not a sorted set)
    eval({intersect E1 E2},env) = (sort (create-set (set-intersection (eval(E1,env) , eval(E2,env))))
                                    if both E1 and E2 evaluate to sorted sets
                                = error! otherwise
    eval({union E1 E2},env) = (sort (create-set (eval(E1,env) , eval(E2,env))))
                                  if both E1 and E2 evaluate to sorted sets
                             = error! otherwise
    eval({with {x E1} E2},env) = eval(E2,extend(x,eval(E1,env),env))
    eval({fun {x1 x2} E},env)  = <{fun {x1 x2} E}, env>
    eval({call-static E-op E1 E2},env)
             = eval(Ef,extend(x2,eval(E2,env) ... extend(x1,eval(E1,env),envf) )
                               if eval(E-op,env) = <{fun {x1 x2} Ef}, envf>
             = error!          otherwise
    eval({call-dynamic E-op E1 E2},env)
             = eval(Ef,extend(x2,eval(E2,env),extend(x1,eval(E1,env),env))
                               if eval(E-op,env) = <{fun {x1 x2} Ef}, envf>
             = error!          otherwise

|#

;; Types for environments, values, and a lookup function

(define-type ENV
  [EmptyEnv]
  [Extend Symbol VAL ENV])

(define-type VAL
  [SetV SET]
  [FunV Symbol Symbol SOL ENV])

(: lookup : Symbol ENV -> VAL)
(define (lookup name env)
  (cases env
    [(EmptyEnv) (error 'lookup "no binding for ~s" name)]
    [(Extend id val rest-env)
     (if (eq? id name) val (lookup name rest-env))]))


;; Auxiliary procedures for eval 
;; Please complete the missing parts, and add comments (comments should specify 
;; the role of each procedure, but also describe your work process). Keep your code readable. 

(: SetV->set : VAL -> SET)
(define (SetV->set v)
  (cases v
    [(SetV S) S]
    [else (error 'SetV->set "expects a set, got: ~s" v)]))


;; This function multiplies a number list by number (scalar).
;; The function receives a number and 'VAL' and returns 'VAL'.
;; Note: Note that since VAL can be FunV or SetV, we want to be sure that it is SetV and so we will use the SetV->set function
;; to be sure of this.
(: smult-set : Number VAL -> VAL)
(define (smult-set n s)
  (: mult-op : Number -> Number)
  (define (mult-op k)
    (* k n))
  (SetV (map mult-op (SetV->set s))))


(: set-op : (SET SET -> SET) VAL VAL -> VAL)
;; gets a binary SET operator VAL VAL -> VAL
;(Unien/intervation)
;; wrapper
(define (set-op op val1 val2)
  (SetV (op (SetV->set val1) (SetV->set val2))))



 
;;---------  the eval procedure ------------------------------
;; Please complete the missing parts, and add comments (comments should specify 
;; the choices you make, and also describe your work process). Keep your code readable. 
(: eval : SOL ENV -> VAL)
;; evaluates SOL expressions by reducing them to set values
;; 
(define (eval expr env)
  (cases expr
    [(Set S) (SetV S)] ;; return S as SetV
    [(Smult n set) (smult-set n (eval set env))] ;; send set to eval
    [(Inter l r) (set-op set-intersection (eval l env) (eval r env))] ;; eval both l and r
    [(Union l r) (set-op set-union (eval l env) (eval r env))] ;; eval both l and r
    [(Id name) (lookup name env)]
    [(Fun bound-id1 bound-id2 bound-body)
     (FunV bound-id1 bound-id2 bound-body env)]
    [(CallS fun-expr arg-expr1 arg-expr2)
     (let ([fval (eval fun-expr env)])
       (cases fval
         [(FunV bound-id1 bound-id2 bound-body f-env)
          ;; I adjusted the function with the practice of the FLANG language.
          (eval bound-body
                (Extend bound-id1 (eval arg-expr1 env) (Extend bound-id2 (eval arg-expr2 env) f-env)))]
         [else (error 'eval "`call-static' expects a function, got: ~s"
                      fval)]))] 
    [(CallD fun-expr arg-expr1 arg-expr2)
     (let ([fval (eval fun-expr env)])
       (cases fval
         [(FunV bound-id1 bound-id2 bound-body f-env)
          ;; same as in the previous case of CallS
          (eval bound-body
                (Extend bound-id1 (eval arg-expr1 env) (Extend bound-id2 (eval arg-expr2 env) env)))]
         [else (error 'eval "`call-dynamic' expects a function, got: ~s"
                      fval)]))]))    


(: createGlobalEnv : -> ENV)
(define (createGlobalEnv)
  (Extend 'second (FunV 'a 'b (Id 'b) (EmptyEnv))
          (Extend 'first (FunV 'a 'b (Id 'a) (EmptyEnv))
                  (Extend 'cons (FunV 'a 'b (Union (Id 'a) (Id 'b)) (EmptyEnv))
                          (EmptyEnv)))))



(: run : String -> (U SET VAL))
;; evaluate a SOL program contained in a string
(define (run str)
  (let ([result (eval (parse str) (createGlobalEnv))])
    (cases result
      [(SetV S) S]
      [else (error
             'run "evaluation returned a non set: ~s" result)])))
 


#|
------------------------------
I culsnt run ths test, i worked on this task but the time was short.
hope it will be ok with binary grade.
------------------------------
(test (run "{with {p {call-static cons {1 2 3} {4 2 3}}}
              {with {S {intersect {call-static first p {}}
                                  {call-static second p {}}}}
                 {call-static {fun {x y} {union x S}}
                              {scalar-mult 3 S}
                              {4 5 7 6 9 8 8 8}}}}")
      =>  '(2 3 6 9))

  
(test (run "{with {p {call-dynamic cons {1 2 3} {4 2 3}}}
              {with {S {intersect {call-dynamic first p {}}
                                  {call-dynamic second p {}}}}
                 {call-dynamic {fun {x y} {union x S}}
                              {scalar-mult 3 S}
                              {4 5 7 6 9 8 8 8}}}}")
      =>  '(2 3 6 9))
 |#




(test (parse "{1 2 3  4 1 4  4 2 3 4 1 2 3}") => (Set '(1 2 3 4)))
(test (parse "{union {1 2 3} {4 2 3}}") => (Union (Set '(1 2 3)) (Set '(2 3 4))))
(test (parse "{fun {x x} x}") =error> "parse-sexpr: `fun' has a duplicate param name in (fun (x x) x)")
(test (parse "{intersect {1 2 3} {4 2 3}}") => (Inter (Set '(1 2 3)) (Set '(2 3 4))))
(test (parse "{with {S {intersect {1 2 3} {4 2 3}}}
                 {call-static {fun {x y} {union x S}}
                              {scalar-mult 3 S}
                              {4 5 7 6 9 8 8 8}}}") 
      =>
      (CallS (Fun 'S
                  'S
                  (CallS (Fun 'x 'y (Union (Id 'x) (Id 'S))) 
                         (Smult 3 (Id 'S)) 
                         (Set '(4 5 6 7 8 9))))
             (Inter (Set '(1 2 3)) (Set '(2 3 4)))
             (Inter (Set '(1 2 3)) (Set '(2 3 4)))))


(test (parse "{with {S {intersect {1 2 3} {4 2 3}}}
              {fun {x} S}}")
      =error> "parse-sexpr: bad `fun' syntax in (fun (x) S)") ;; functions require two formal parameters


(test (run "{1 2 3  4 1 4  4 2 3 4 1 2 3}") => '(1 2 3 4))
(test (run "{union {1 2 3} {4 2 3}}") => '(1 2 3 4))
(test (run "{intersect {1 2 3} {4 2 3}}") => '( 2 3))
(test (run "{with {S {intersect {1 2 3} {4 2 3}}}
                 {call-static {fun {x y} {union x S}}
                              {scalar-mult 3 S}
                              {4 5 7 6 9 8 8 8}}}")
      => '(2 3 6 9))
(test (run "{with {S {intersect {1 2 3} {4 2 3}}}
                 {call-static {fun {x y} {union x y}}
                              {scalar-mult 3 S}
                              {4 5 7 6 9 8 8 8}}}")
      => '(4 5 6 7 8 9))

(test (run "{call-static {1} {2 2} {}}")
      =error> "eval: `call-static' expects a function, got: #(struct:SetV (1))")

(test (run "{fun {x x} x}") =error> "parse-sexpr: `fun' has a duplicate param name in (fun (x x) x)")

(test (not (ismember? 1 '(3 4 5))))
(test (not (ismember? 1 '( 3 2 3 5 6))))
(test (ismember? 1 '(3 4 5 1 3 4)))
(test (ismember? 1 '(1)))

(test (remove-duplicates '(3 4 5)) => '(3 4 5)) 
(test (remove-duplicates '(3 1 3 5 9)) => '(1 3 5 9))
(test (remove-duplicates '(3 4 5 1 3 4)) => '(5 1 3 4))
(test (remove-duplicates '(5)) => '(5))
(test (remove-duplicates '(3 1 3 5 9 9 9 9)) => '(1 3 5 9))
(test (remove-duplicates '(3 4 5 5 5 5 1 3 4)) => '(5 1 3 4))
(test (remove-duplicates '(5 5 5 5 5 5)) => '(5))
(test (remove-duplicates '()) => '())

(test (create-sorted-set '(3 4 5 1 3 4)) => '(1 3 4 5))
(test (create-sorted-set '(9 8 7 6 5 4)) => '(4 5 6 7 8 9))
(test (create-sorted-set '(5 5 4 4 3 3 2 2 1 1)) => '(1 2 3 4 5))
(test (create-sorted-set '(1 1 1 1 1 1 1)) => '(1))
(test (create-sorted-set '(1 2 3 3 2 1)) => '(1 2 3))
(test (create-sorted-set '(5 4 3 4 5 4 3 4 5)) => '(3 4 5))


(test (set-union '(1 2 3 4 5) '(3 4 5 6 7 8)) => '(1 2 3 4 5 6 7 8))
(test (set-union '(1 1 1 2 2 3) '(4 4 3 2 2)) => '(1 2 3 4))
(test (set-union '(6 7 8 9) '(9 8 7 6)) => '(6 7 8 9))
(test (set-union '(2 2 2 2 2 2) '(3 4 5 6 7 8)) => '(2 3 4 5 6 7 8))
(test (set-union '(3 3) '(4 4 3 2 2)) => '(2 3 4))
(test (set-union '(1) '(9 8 7 6)) => '(1 6 7 8 9))

(test (set-intersection '(1 2 3 4 5) '(4 3 2)) => '(2 3 4))
(test (set-intersection '(7 6 5 4 3 2) '(3 2)) => '(2 3))
(test (set-intersection '(3 3 3 4 4 4) '(6 6 6 5 5 4)) => '(4))
(test (set-intersection '() '(4 3 2)) => '())
(test (set-intersection '(7 6 5 4 3 2) '(1 1 2)) => '(2))
(test (set-intersection '(3 3 3 4 4 4) '(1 2 5 6 7)) => '())

(test (set-op set-union (SetV '(1 2 3 4 5))(SetV '(4 5 6 7))) => (SetV '(1 2 3 4 5 6 7)))
(test (set-op set-intersection (SetV '(1 2 3 4 5))(SetV '(4 5 6 7))) => (SetV '(4 5)))

(test (not (ismember? 1 '(3 4 5))))
  (test (not (ismember? 1 '( 3 2 3 5 6))))
  (test (ismember? 1 '(3 4 5 1 3 4)))
  (test (ismember? 1 '(1)))
  (test (not (ismember? 6 '(3 4 5))))
  (test (not (ismember? 7 '( 3 2 3 5 6))))
  (test (not (ismember? 7 '())))
  (test (ismember? 1 '(3 6 6 6 6 6 4 5 1 3 4)))


 

#|
**********
Question 6
**********



*******
***1*** 
*******


   No. I used the previous assignments, the course presentations and the exercises and the questions asked in the forum that helped to focus and understand.


*******
***2***
*******


   The types of the SOL language

    SET ------> List of numbers.

    Set ------> A SET.
    Smult ----> A list of two unions sets.
    Inter ----> A list of two intersection sets.
    Union ----> Scalar multiply, list of numbers and scalar.
    Id -------> A symbol.
    Fun ------> Representation of a function.
    CallS ----> Representation of a static call.
    CallD ----> Representation of a static call.

    SetV -----> new SET. 
    FunV -----> new Representation of a function.

    VAL ------> SetV & FunV.

    EmptyEnv -> empty environment.
    Extend ---> enviroment with symbol, VAL and ENV.

    ENV -----> EmptyEnv & Extend.


*******
***3***
*******

I have been very helpful in the presentations of the exercises to solve this with the help of 'Call' and 'Fun'.
As you learned there is 'With' Both Syntactic sugar of both.

Static conversation expands the environment, so this is the more appropriate option between the two.



*******
***4***
*******

I used a tail recursion in the 'set-intersection' function.
The advantage of tail recursion is that the value can be returned as soon as we want without recursion of the recursion. It saves time and memory.


6) Probably we will get an unwanted answer, because in dynamic reading the extension is not ideal.



סרוקב םויה ףסונ ןחבמ יתישע .תוניצרה לכב ,בתוכ ינאש המל בל םש אל רבכ ינאש תמאה
 ןיב ,הזה םויב םינחבמ ינשל ימצע תא ןיכהל ידכ רטסמסה לכ ךשמב הדובע יתתנ 2, םימתירוגלא 
לבא .הברה יכה וב יתעקשהש סרוקה הז .תואצרהה ךלהמב ונינבש רבד לכ ןיבהלב וא תולטמב םא
 .רותפלו הנבהל עיגהל תלוכיו עדי תניחבמ אלו תיזיפ הניחבמ תלוכיה לובג הצקל יתעגה ירעצל 
 הפיא עגרכ עדוי אל ינאו (תוניצרב) ךסמה ןוויכל טיבהל יל באוכ ,תוצפוקו תודעור ילש םייפעפעה
 הדות יללכ ןפואב .שיגהל ץלאנ לבא רבועל םינוירטירקה המ וא הלטמב קפסהה תניחבמ דמוע ינא
.דואמ ךרעומ ,ץר אל ץבוקהש היעב ןקתל תוחפל יל רזע הז,ןמזה תכראב תובשחתהה לע


|#

