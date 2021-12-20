#lang racket

;; these sample data are used by unit tests and e2e tests
;; so instead of parsing the sample input file in the unit tests
;; or putting the sample data in twice as I did yesterday, I just made a
;; function to generate a file from these data that can be called by pytest

(provide main)
(provide sample-image-enhancement-algorithm)
(provide sample-input-image-lines)

(define sample-image-enhancement-algorithm
  (string-append
   "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##"
   "#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###"
   ".######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#."
   ".#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#....."
   ".#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.."
   "...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#....."
   "..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"))

;; #..#.
;; #....
;; ##..#
;; ..#..
;; ..###
(define sample-input-image-lines (list "#..#." "#...." "##..#" "..#.." "..###"))

;; for pytest (end to end testing)
;; racket -t sample.rkt -m
(define (main)
  (begin
    (display sample-image-enhancement-algorithm)
    (display "\n")
    (display "\n")
    (for-each (λ (l)
                (begin
                  (display l)
                  (display "\n")))
              sample-input-image-lines)))
