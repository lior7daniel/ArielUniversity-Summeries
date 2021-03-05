#lang pl

#|
********************************************************************************************************
******************************************** READ ME PLEASE ********************************************
********************************************************************************************************
My name : Lior Daniel
ID : 305257347

There is an important comment in Exercise 2.1 that could affect the test results. It was a matter of an edge case that was unclear how to solve.
Thanks.
|#




#|
********************************
********** Question 1 **********
********************************
This function consumes a list of strings
and returns the first string that contains the string "pl" as a suffix – if one such
exists, and returns #f otherwise.

Comments:
In this exercise, I had mostly syntactic problems that slowed me down.
I tried to search for an effective suffix function and found that that ::-> (string-suffix? s suffix),
but it probably did not recognize PL. In addition, instructions are recommended to use the string-ref function,
but this function is less effective because I need to double-check the characters.
|#

( : plSuffixContained : (Listof String) -> (U #f String))
( define (plSuffixContained myList)
   (cond
     [(null? myList) #f]
     [(equal? "pl" (substring (first myList) (- (string-length (first myList)) 2))) (first myList)]
     [else (plSuffixContained(rest myList))]
    )
 )

(test (plSuffixContained (list)) => false)
(test (plSuffixContained (list "Apple")) => false)
(test (plSuffixContained (list "pllp" "fsdplsdfplsfdpld" "Apple")) => false)
(test (plSuffixContained (list "pllp" "plyy" "ppple" "lpTT" "lol")) => false)
(test (plSuffixContained (list "pl")) => "pl")
(test (plSuffixContained (list "pl" "lpl")) => "pl")
(test (plSuffixContained (list "Appl" "lpl")) => "Appl")
(test (plSuffixContained (list "dfa" "Apl" "Bpl")) => "Apl")
(test (plSuffixContained (list "pllp" "plyy" "ppple" "lpTTpl" "lol")) => "lpTTpl")
(test (plSuffixContained (list "pllp" "plyy" "ppp" "lpTT" "lolpl")) => "lolpl")

#|
********************************
********** Question 2 **********
********************************
This function consumes a number x and a list ofcoefficients (numbers) a1, a2, ... , an
and returns the result of the polynomial (again, in a reversed order of coefficients) a1x^n + a2x^n-1 + ⋯ + a
applied to the first argument x (the natural number n is not given to you.

Comments:
**2.1**
This exercise was the most difficult of each assignment and it took me about 7 hours just to make sure I closed all the end cases.
Unfortunately, it was unclear whether the following case (1 1 1) should return "1x^2+1x+1" or "x^2+x+1".
I made worse and returned "x^2+x+1". But in addition, I marked "%%%" next to each line that can be deleted to get the second option.
**2.2**
This exercise was fine and clear.
|#

; 2.1

( : write-poly : (Listof Number) -> String)
(define (write-poly myList)
  ( : helper-write-poly : (Listof Number) String -> String)
  (define (helper-write-poly myList myStr)
    (cond
      [(null? myList) myStr]
      [(= (first myList) 0) (helper-write-poly (rest myList) myStr)]
      [(and (= (length myList) 1) (= (string-length myStr) 0)) (helper-write-poly (rest myList) (string-append myStr (number->string (first myList))))]
      [(and (= (length myList) 1) (> (string-length myStr) 0) (> (first myList) 0)) (helper-write-poly (rest myList) (string-append myStr "+" (number->string (first myList))))]
      [(and (= (length myList) 1) (> (string-length myStr) 0) (< (first myList) 0)) (helper-write-poly (rest myList) (string-append myStr (number->string (first myList))))]

      [(and (= (length myList) 2) (= (string-length myStr) 0) (= (first myList) 1)) (helper-write-poly (rest myList) (string-append myStr "x"))] ;; %%%
      [(and (= (length myList) 2) (= (string-length myStr) 0) (= (first myList) -1)) (helper-write-poly (rest myList) (string-append myStr "-x"))] ;; %%%
      [(and (= (length myList) 2) (> (string-length myStr) 0) (= (first myList) 1)) (helper-write-poly (rest myList) (string-append myStr "+x"))] ;; %%%
      [(and (= (length myList) 2) (> (string-length myStr) 0) (= (first myList) -1)) (helper-write-poly (rest myList) (string-append myStr "-x"))] ;; %%%
      
      [(and (= (length myList) 2) (= (string-length myStr) 0)) (helper-write-poly (rest myList) (string-append myStr (number->string (first myList)) "x"))]
      [(and (= (length myList) 2) (> (string-length myStr) 0) (> (first myList) 0)) (helper-write-poly (rest myList) (string-append myStr "+" (number->string (first myList)) "x"))]
      [(and (= (length myList) 2) (> (string-length myStr) 0) (< (first myList) 0)) (helper-write-poly (rest myList) (string-append myStr (number->string (first myList)) "x"))]

      [(and (= (string-length myStr) 0) (= (first myList) 1)) (helper-write-poly (rest myList) (string-append myStr "x^" (number->string(- (length myList) 1))))] ;; %%%
      [(and (= (string-length myStr) 0) (= (first myList) -1)) (helper-write-poly (rest myList) (string-append myStr "-x^" (number->string(- (length myList) 1))))] ;; %%%

      [(= (string-length myStr) 0) (helper-write-poly (rest myList) (string-append myStr (number->string (first myList)) "x^" (number->string(- (length myList) 1))))]
      [(> (first myList) 0) (helper-write-poly (rest myList) (string-append myStr "+" (number->string (first myList)) "x^" (number->string(- (length myList) 1))))]
      [else (helper-write-poly (rest myList) (string-append myStr (number->string (first myList)) "x^" (number->string(- (length myList) 1))))]))
  (helper-write-poly myList ""))


(test (write-poly '(1 1 1)) => "x^2+x+1")
(test (write-poly '(1 1)) => "x+1")
(test (write-poly '(-1 1)) => "-x+1")
(test (write-poly '(2 -1 1)) => "2x^2-x+1")
(test (write-poly '(-1 2 -1 1)) => "-x^3+2x^2-x+1")
(test (write-poly '(6 4 2 -1 1)) => "6x^4+4x^3+2x^2-x+1")
(test (write-poly '(3 6 -4 2 -1 1)) => "3x^5+6x^4-4x^3+2x^2-x+1")
(test (write-poly '(2 0 5)) => "2x^2+5")
(test (write-poly '(2 0 7 5)) => "2x^3+7x+5")
(test (write-poly '(2 7 8 9)) => "2x^3+7x^2+8x+9")
(test (write-poly '(2 3 4 5)) => "2x^3+3x^2+4x+5")
(test (write-poly '(2 -3 4)) => "2x^2-3x+4")
(test (write-poly '(-2 -3 4)) => "-2x^2-3x+4")
(test (write-poly '(2 3 -4)) => "2x^2+3x-4")
(test (write-poly '(-2 -3 -4)) => "-2x^2-3x-4")
(test (write-poly '(-2 -3)) => "-2x-3")
(test (write-poly '(0 -2 -3)) => "-2x-3")
(test (write-poly '(0 0 0)) => "")
(test (write-poly '(2 3 4)) => "2x^2+3x+4")
(test (write-poly '()) => "")
(test (write-poly '(0)) => "")
(test (write-poly '(1)) => "1")
(test (write-poly '(-1)) => "-1")


; 2.2

( : compute-poly : Number (Listof Number) -> Number)
( define (compute-poly x myList)
   ( : helper-compute-poly : Number Number (Listof Number) -> Number)
   ( define (helper-compute-poly res x myList)
      (if (null? myList)
          res
          (helper-compute-poly (+ res (* (first myList) (expt x (- (length myList) 1)))) x (rest myList))))                           
   (helper-compute-poly 0 x myList))


(test (compute-poly 2 '()) => 0)
(test (compute-poly 0 '(3 2 6)) => 6)
(test (compute-poly 0 '(-3 -2 -6)) => -6)
(test (compute-poly 2 '(3 2 6)) => 22)
(test (compute-poly 3 '(4 3 -2 0)) => 129)
(test (compute-poly 3 '(4 3 -2 0)) => 129)


#|
********************************
********** Question 3 **********
********************************
In this question we will implement a keyed-stack data structure. In this data
structure you will need to define a new type called KeyStack. Each element
in the stack will be keyed (indexed) with a symbol. In the following the
operations that you are required to implement are detailed below, together
with some guidance.

Comments:
In this exercise I encountered a problem in terms of understanding their instructions
and "translating" them into the tools we were given in the course.
I didn't understand how to create the constructor and after realizing I got into trouble
with the push function, but the logic worked out and I finally succeeded.
The rest of the sections were challenging and I used the presentations of the lecture to realize the 'cases'.
|#

; 3.1
(define-type KeyStack
  [EmptyKS]
  [Push Symbol String KeyStack])

 ; 3.3
(: search-stack : Symbol KeyStack -> (U String #f))
(define (search-stack smbl ks)
  (cases ks
    [(EmptyKS) #f]
    [(Push mySmbl myStr myKs)
      (cond
        [(eq? smbl mySmbl)
             myStr]
        [else
             (search-stack smbl myKs)])]))

; 3.4
(: pop-stack : KeyStack -> (U KeyStack #f))
(define (pop-stack ks)
  (cases ks
    [(EmptyKS) #f]
    [(Push mySmbl myStr myKs) myKs]))


(test (EmptyKS) => (EmptyKS))
(test (pop-stack (EmptyKS)) => #f)
(test (Push 'FIRST "first" (EmptyKS)) => (Push 'FIRST "first" (EmptyKS)))
(test (Push 'FIRST "first" (Push 'SEC "sec" (Push 'THIRD "third" (EmptyKS)))) => (Push 'FIRST "first" (Push 'SEC "sec" (Push 'THIRD "third" (EmptyKS)))))
(test (search-stack 'LIOR (Push 'DANIEL "daniel" (Push 'LIOR "lior" (Push 'TALIA "talia" (EmptyKS))))) => "lior")
(test (search-stack 'DANIEL (Push 'LIOR "lior" (Push 'TALIA "talia" (Push 'ILANA "ilana" (EmptyKS))))) => #f)
(test (pop-stack (Push 'FIRST "first" (Push 'SEC "sec" (EmptyKS)))) => (Push 'SEC "sec" (EmptyKS)))


#|
********************************
********** Question 4 **********
********************************
|#

(: is-odd? : Natural -> Boolean)
; This function consumes a natural number and determines whether it is odd by boolean.
; It uses the "is-even?" function to subtract the number to 0.
(define (is-odd? x)
 (if (zero? x)
 false
 (is-even? (- x 1))))
(: is-even? : Natural -> Boolean)
;; This function consumes a natural number and determines whether it is even by boolean.
;; It uses the "is-odd?" function to subtract the number to 0.
(define (is-even? x)
 (if (zero? x)
 true
 (is-odd? (- x 1))))

;; TESTS
(test (not (is-odd? 12)))
(test (is-even? 12))
(test (not (is-odd? 0)))
(test (is-even? 0))
(test (is-odd? 1))
(test (not (is-even? 1)))


(: every? : (All (A) (A -> Boolean) (Listof A) -> Boolean))
;; A function that receives three parameters.
;; (A) - Represents climbing
;; (A -> Boolean) - Represents a function that accepts type A and returns a boolean value.
;; (Listof A) - List of type A values
;; The function passes all the values in the list and checks if when it sends them to the received function they all return true.
(define (every? pred lst)
 (or (null? lst)
     (and (pred (first lst))
          (every? pred (rest lst)))))

;; An example for the usefulness of this polymorphic function
(: all-even? : (Listof Natural) -> Boolean)
;; The function receives a list of numbers and sends each number to the is-even function.
;; The function returns true if all organs in the list are even.
(define (all-even? lst)
 (every? is-even? lst))

;; TESTS
(test (all-even? null))
(test (all-even? (list 0)))
(test (all-even? (list 2 4 6 8)))
(test (not (all-even? (list 1 3 5 7))))
(test (not (all-even? (list 1))))
(test (not (all-even? (list 2 4 1 6))))


(: every2? : (All (A B) (A -> Boolean) (B -> Boolean) (Listof A) (Listof B) -> Boolean))
;; As in every function? The first, again here, the same parameters are obtained only in addition to a different type B type,
;; with another function that accepts type B, and a list with type B values.
;; This function recursively checks both lists and sends the values of each of the lists to their respective functions.
;; If all the values in the two lists together return true - our function will return true.
(define (every2? pred1 pred2 lst1 lst2)
 (or (null? lst1) ;; both lists assumed to be of same length
     (and (pred1 (first lst1))
          (pred2 (first lst2))
          (every2? pred1 pred2 (rest lst1) (rest lst2)))))


