(define (expr-compare x y)
  (cond ((equal? x y) x)
        ((list 'if '% x y))))

(define test-expr-x '(+ 3 (let ((a 1) (b 2)) (list a b))))
(define test-expr-y '(+ 2 (let ((a 1) (c 2)) (list a c))))
