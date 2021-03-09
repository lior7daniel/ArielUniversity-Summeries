#lang pl
#|
********************************************************************************************************
******************************************** READ ME ***************************************************
********************************************************************************************************
Task #2

My name : Lior Daniel
ID : 305257347
|#




#|
*****************************************************************************
******************************* Question 1 **********************************
*****************************************************************************

Comments:
I used lesson 4-5 and the assignment examples to write the shear trees. 
I wasted a lot of time realizing that I didn't have to create a function 
called run as it does in tests given in the assignment. 
In addition, it took me a long time to realize that I needed to use the 
parse-sexpr-RegL function to "decompose" the body of the phrase. 

|#

; The ROL BNF and Parsing code:
;; Defining two new types
(define-type BIT = (U 0 1))
(define-type Bit-List = (Listof BIT))

;; The actual interpreter


#|

***************
*** 1.1 (a) ***
***************


BNF for the RegE language:
                             <ROL>  ::= {reg-len = <num> <RegE>}
                             <RegE> ::= { Reg <Bits> }
                                      | { Shl <RegE> }
                                      | { Or <RegE> <RegE> }
                                      | { And <RegE> <RegE> }
                             <Bits> ::= { <Bit> }
                                      | {<Bit> <Bits>}
                             <Bit>  ::= 0 | 1

***************
** 1.1 (b+c) **
***************

Examples:
            1."{ reg-len = 3 {0 1 0}}"   => <ROL>
                                         => <num> <RegE>
                                         => 3 (Reg (<Bits>))
                                         => 3 (Reg (<bit> <Bits)>))
                                         => 3 (Reg (<bit> <bit> <Bits>))
                                         => 3 (Reg (<bit> <bit> <bit>))
                                         => 3 (Reg (0 1 0))

            2. "{ reg-len = 3 {shl {1 0}}}" => <ROL>
                                            => 2 <RegE>
                                            => 2 (Shl <RegE>)
                                            => 2 (Shl (Reg (<Bits>)))
                                            => 2 (Shl (Reg (<bit> <Bits>)))
                                            => 2 (Shl (Reg (<bit> <Bit>)))
                                            => 2 (Shl (Reg (1 0)))
                                             
 
            3. "{ reg-len = 2 { and {or {0 0} {0 1}} {1 0}}}" => <ROL>
                                                              => <num> <RegE>
                                                              => <num> (And <RegE> <RegE>)
                                                              => <num> (And (Or <RegE> <RegE>) <RegE>)
                                                              => <num> {And (Or <Bits> <Bits>) <Bits>)
                                                              =>  2 (And (Or (0 0) (0 1)) (1 0))


|#
;; RegE abstract syntax trees
(define-type RegE
  [Reg Bit-List]
  [And RegE RegE]
  [Or RegE RegE]
  [Shl RegE])


;; Next is a technical function that converts (casts)
;; (any) list into a bit-list. We use it in parse-sexpr.
(: list->bit-list : (Listof Any) -> Bit-List)
;; to cast a list of bits as a bit-list
(define (list->bit-list lst)
  (cond [(null? lst) null]
        [(eq? (first lst) 1)(cons 1 (list->bit-list (rest lst)))]
        [else (cons 0 (list->bit-list (rest lst)))]))


(: parse-sexpr : Sexpr -> RegE)
;; to convert the main s-expression into ROL
(define (parse-sexpr sexpr)
  (match sexpr
    [(list 'reg-len '= (number: size) body) (cond
                                              [(>= size 1) (parse-sexpr-RegL body size)]
                                              [else (error 'parse-sexpr "List can NOT be empty!")])]
    [else (error 'parse-sexpr "bad syntax in ~s" sexpr)]))


(: parse-sexpr-RegL : Sexpr Number -> RegE)
;; to convert s-expressions into RegEs
(define (parse-sexpr-RegL sexpr reg-len)
  (match sexpr
    [(list (and a (or 1 0)) ... ) (if (= reg-len (length a))
                                      (Reg(list->bit-list a))
                                      (error 'parse-sexpr "wrong number of bits in ~s" a))]
    [(list 'shl body) (Shl (parse-sexpr-RegL body reg-len))]
    [(list 'or body1 body2) (Or (parse-sexpr-RegL body1 reg-len)(parse-sexpr-RegL body2 reg-len))]
    [(list 'and body1 body2) (And (parse-sexpr-RegL body1 reg-len)(parse-sexpr-RegL body2 reg-len))]
    [else (error 'parse-sexpr "bad syntax in ~s" sexpr)]))


(: parse : String -> RegE)
;; parses a string containing a RegE expression to a RegE AST
(define (parse str)
  (parse-sexpr (string->sexpr str)))

;; tests
(test (parse "{ reg-len = 4 {1 0 0 0}}") => (Reg '(1 0 0 0)))
(test (parse "{ reg-len = 4 {shl {1 0 0 0}}}") => (Shl (Reg '(1 0 0 0))))
(test (parse "{ reg-len = 4 {and {shl {1 0 1 0}} {shl {1 0 1 0}}}}") => (And (Shl (Reg '(1 0 1 0))) (Shl (Reg '(1 0 1 0)))))
(test (parse "{ reg-len = 4 { or {and {shl {1 0 1 0}} {shl {1 0 0 1}}} {1 0 1 0}}}") => (Or (And (Shl (Reg '(1 0 1 0))) (Shl (Reg '(1 0 0 1)))) (Reg '(1 0 1 0))))
(test (parse "{ reg-len = 2 { or {and {shl {1 0}} {1 0}} {1 0}}}") => (Or (And (Shl (Reg '(1 0))) (Reg '(1 0))) (Reg '(1 0))))
(test (parse "{ reg-len = 4 {or {1 1 1 1} {0 1 1}}}") =error> "wrong number of bits in")
(test (parse "{ reg-len = 0 {or {1 1 1 1} {0 1 1}}}") =error> "List can NOT be empty!")
(test (parse "{ reg-len = 3 {2 3 4}}") =error> "bad syntax in (2 3 4)")
(test (parse "{0 1 1}") =error> "bad syntax in (0 1 1)")

#|
*****************************************************************************
******************************* Question 2 **********************************
*****************************************************************************
************
*** 1(a) ***
************
    If I misunderstand the intent of the language, then I already notice that there is a problem with order.
    There are two sets that keep a number, there is a connection between the two sets,
    but there is no set that keeps the connection between them.
    Also, what happens if we take the get before we do the set?
************
*** 1(b) ***
************
    The language should be edited in such a way that it is not possible to confuse the order and do invalid things like do 'get' before 'set',
    In addition, 'set' must be on any arrhythmic operation to contain the result.
************
**** 2 *****
************
    <MAE>  ::= { seq <AE> }
             | { seq <SET> }
 
    <AE>   ::= <num> 
             | { + <AE> <AE> } 
             | { - <AE> <AE> } 
             | { * <AE> <AE> } 
             | { / <AE> <AE> } 

    <SET>  ::= { set <AE> } <GET> 
             | { set <AE> } <TEMP> <GET> 

    <GET>  ::= get
             | <num> 
             | { + <GET> <GET> } 
             | { - <GET> <GET> }
             | { * <GET> <GET> } 
             | { / <GET> <GET> } 

    <TMP>  ::= { set <GET> } 
             | { set <GET> } <TMP>
|#

#|
*****************************************************************************
******************************* Question 3 **********************************
*****************************************************************************

A function using 'foldl' and 'map' to calculate the sum of the list squares.

comments:
In this exercise, I tried to use a link from the Racket site that you included in the instructions,
where I saw examples of 'foldl' using lambda (with or without map), but for some reason
I couldn't run the exercise that existed there and got into trouble with it.
Maybe '#lang pl' doesn't support this option? Anyway, I used auxiliary function to realize the square function.

|#

(: sum-of-squares : (Listof Natural) -> Natural)
(define(sum-of-squares myList)
  (foldl + 0 (map expt-helper myList)))

( : expt-helper : Natural -> Natural)
(define(expt-helper x)
  (* x x))

(test (sum-of-squares '()) => 0)
(test (sum-of-squares '(2)) => 4)
(test (sum-of-squares '(1 2 3)) => 14)
(test (sum-of-squares '(2 3 4)) => 29)

#|
*****************************************************************************
******************************* Question 3 **********************************
*****************************************************************************


|#


(define-type BINTREE
  [Node BINTREE BINTREE]
  [Leaf Number])
(: add1 : Number -> Number)
(define (add1 num)
  (+ num 1))

#|
This function takes in a numeric function f and a binary tree, and returns a
tree with the same shape but using f(n) for values in its leaves in recursive way.

Comments:
|#
(: tree-map : (Number -> Number) BINTREE -> BINTREE)
(define (tree-map f tree)
  (cases tree
    [(Leaf arg) (Leaf (f arg))]
    [(Node myNode1 myNode2) (Node (tree-map f myNode1) (tree-map f myNode2))]))

(test (tree-map add1 (Node (Leaf 1) (Node (Leaf 2) (Leaf 3)))) => (Node (Leaf 2) (Node (Leaf 3) (Leaf 4))))



(: plus2 : Number -> Number)
(define (plus2 num)
  (+ 2 num))
(test (plus2 10) => 12)

#|
This function is equivalent to the foldl of lists, but here for binary tree.
The function uses 'leaf-function' to take action on any value found in the leaves,
then uses 'f' to get any two leaves, to act on them, and finally to extract one leaf
within which the result of all actions done on the whole tree .

This function uses two functions:
'f' - combiner function, which accepts two objects of type A and returns a single object A.
'leaf-function' - Gets a number and takes out a type A object.
|#
(: tree-fold : (All (A) (A A -> A) (Number -> A) BINTREE -> A))
(define (tree-fold f leaf-func tree)
  (cases tree
    [(Leaf num) (leaf-func num)]
    [(Node node1 node2) (f (tree-fold f leaf-func node1) (tree-fold f leaf-func node2))]))
(test (tree-fold + plus2 (Node (Leaf 1) (Node (Leaf 2) (Leaf 3)))) => 12)

#|
This function takes a binary tree and returns a binary tree in the reverse order by alternating
between the two boys (left and right) recursively until the leaf arrives.
Comments: This function was logically understandable and the coding was instinctive.
|#
(: tree-reverse : BINTREE -> BINTREE)
(define (tree-reverse tree)
  (cases tree
    [(Leaf num) (Leaf num)]
    [(Node node1 node2) (Node (tree-reverse node2) (tree-reverse node1))]))

(test (tree-reverse (Node (Leaf 3) (Leaf 2))) => (Node (Leaf 2) (Leaf 3)))
(test (tree-reverse (Node (Node (Leaf 3) (Leaf 2)) (Leaf 1))) => (Node (Leaf 1) (Node (Leaf 2) (Leaf 3))))
