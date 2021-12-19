#lang racket

(require rackunit)

(require "./unit.rkt")

(check-equal? (untokenize (explode-first (tokenize "[[[[[9,8],1],2],3],4]")))
              "[[[[0,9],2],3],4]")

(check-equal? (untokenize (explode-first (tokenize "[7,[6,[5,[4,[3,2]]]]]")))
              "[7,[6,[5,[7,0]]]]")

(check-equal? (untokenize (explode-first (tokenize "[[6,[5,[4,[3,2]]]],1]")))
              "[[6,[5,[7,0]]],3]")

(check-equal? (untokenize (explode-first
                           (tokenize "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")))
              "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")

(check-equal?
 (untokenize (explode-first (tokenize "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")))
 "[[3,[2,[8,0]]],[9,[5,[7,0]]]]")

(check-equal?
 (untokenize (explode-first (tokenize "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")))
 "[[3,[2,[8,0]]],[9,[5,[7,0]]]]")

;; extracted from an example - one that does not change
;; except changed 15 to 1 because you can't tokenize double digits like this
(let ([number-string "[[[[0,7],4],[1,[0,13]]],[1,1]]"])
  (check-equal? (untokenize (explode-first (tokenize number-string)))
                number-string))

;; hard to do a real example from the question for this function because any
;; real example will have a two digit number that I can't parse directly from
;; their string
(check-equal? (split-first '("A" "B" 3 "C" 11 "D" 12))
              '("A" "B" 3 "C" "[" 5 "," 6 "]" "D" 12))

(let ([multi-example (tokenize "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")])
  (begin
    (check-equal? (untokenize (explode-first multi-example))
                  "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]")
    (check-equal? (untokenize (explode-all multi-example))
                  "[[[[0,7],4],[15,[0,13]]],[1,1]]")
    (check-equal? (untokenize (reduce-once multi-example))
                  "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
    (check-equal? (untokenize (reduce-all multi-example))
                  "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
    ;; didn't plan for this one, so have to re-untokenize it:
    (check-equal? (reduce (untokenize multi-example))
                  "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")))

(check-equal? (snailfish-add "[1,2]" "[[3,4],5]") "[[1,2],[[3,4],5]]")

(check-equal? (snailfish-add "[[[[4,3],4],4],[7,[[8,4],9]]]" "[1,1]")
              "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")

(check-equal? (snailfish-add "[1,1]" "[2,2]" "[3,3]" "[4,4]")
              "[[[[1,1],[2,2]],[3,3]],[4,4]]")

(check-equal? (snailfish-add "[1,1]" "[2,2]" "[3,3]" "[4,4]" "[5,5]")
              "[[[[3,0],[5,3]],[4,4]],[5,5]]")

(check-equal? (snailfish-add "[1,1]" "[2,2]" "[3,3]" "[4,4]" "[5,5]" "[6,6]")
              "[[[[5,0],[7,4]],[5,5]],[6,6]]")

(check-equal? (snailfish-add "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]"
                             "[[[5,[2,8]],4],[5,[[9,9],0]]]"
                             "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]"
                             "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]"
                             "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]"
                             "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]"
                             "[[[[5,4],[7,7]],8],[[8,3],8]]"
                             "[[9,3],[[9,9],[6,[4,9]]]]"
                             "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]"
                             "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]")
              "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")

(check-equal? (snailfish-magnitude "[[1,2],[[3,4],5]]") 143)
(check-equal? (snailfish-magnitude "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]") 1384)
(check-equal? (snailfish-magnitude "[[[[1,1],[2,2]],[3,3]],[4,4]]") 445)
(check-equal? (snailfish-magnitude "[[[[3,0],[5,3]],[4,4]],[5,5]]") 791)
(check-equal? (snailfish-magnitude "[[[[5,0],[7,4]],[5,5]],[6,6]]") 1137)
(check-equal?
 (snailfish-magnitude "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
 3488)
