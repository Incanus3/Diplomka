(in-package :utils-tests)

(declaim (optimize (debug 3) (compilation-speed 0) (space 0) (speed 0)))

;; some macro tests result in code so trivial, that sbcl actually
;; decides to optimize it so that it removes part of the code
;; as unreachable, don't wonna see these warnings
(declaim #+sbcl(sb-ext:muffle-conditions sb-ext:code-deletion-note))

(defclass utils-tests (test-case) ())

(def-test-method test-to-keyword ((tests utils-tests) :run nil)
  (assert-equal :abc (to-keyword 'abc)))

(def-test-method test-weak-equal-p ((tests utils-tests) :run nil)
  (assert-true (weak-equal-p 'exil-env:facts 'exil:facts)))

(def-test-method test-assoc-value ((tests utils-tests) :run nil)
  (let ((alist (list (cons 'a 1))))
    (assert-equal 1 (assoc-value 'a alist))
    (assert-equal nil (assoc-value 'b alist))
    (setf (assoc-value 'a alist) 2)
    (assert-equal 2 (assoc-value 'a alist))
    (assert-condition 'simple-error (setf (assoc-value 'b alist) 3))))

(def-test-method test-assoc-key ((tests utils-tests) :run nil)
  (let ((alist (list (cons 'a 1))))
    (assert-equal 'a (assoc-key 1 alist))
    (assert-equal nil (assoc-key 2 alist))))

(def-test-method test-to-list ((tests utils-tests) :run nil)
  (assert-equal '(a) (to-list 'a))
  (assert-equal '(a) (to-list '(a)))
  (assert-equal () (to-list ())))

(def-test-method test-to-list-of-lists ((tests utils-tests) :run nil)
  (assert-equal '((a) (b :default 10))
               (to-list-of-lists '(a (b :default 10)))))

(def-test-method test-ext-pushnew ((tests utils-tests) :run nil)
  (let (list)
    (assert-equal (multiple-value-list (ext-pushnew 1 list))
                  (list '(1) t)) ; list has been altered
    (assert-equal (multiple-value-list (ext-pushnew 1 list))
                  (list '(1) nil)))) ; not this time

(def-test-method test-push-end ((tests utils-tests) :run nil)
  (let ((list (list 1 2))
        (empty-list ()))
    (push-end 3 list)
    (assert-equal list (list 1 2 3))
    (push-end 1 empty-list)
    (assert-equal empty-list (list 1))))

(def-test-method test-pushnew-end ((tests utils-tests) :run nil)
  (let ((list (list 1 2)))
    (assert-equal (multiple-value-list (pushnew-end 3 list))
                  (list (list 1 2 3) t))
    (assert-equal (multiple-value-list (pushnew-end 3 list))
                  (list (list 1 2 3) nil))))

(def-test-method test-ext-delete ((tests utils-tests) :run nil)
  (let ((list (list 1 2)))
    (assert-equal (multiple-value-list (ext-delete 2 list))
                  (list (list 1) t))
    (assert-equal (multiple-value-list (ext-delete 2 list))
                  (list (list 1) nil))))

(def-test-method test-diff-remove ((tests utils-tests) :run nil)
  (let ((list (list 1 2)))
    (assert-equal (multiple-value-list (diff-remove 2 list))
                  (list (list 1) (list 2)))
    (assert-equal (multiple-value-list (diff-remove 2 list))
                  (list (list 1) ()))))

(def-test-method test-push-update ((tests utils-tests) :run nil)
  (let ((list (list "BLAH" "FOO")))
    (assert-equal (push-update "blah" list) (list "blah" "FOO"))))

#|
(def-test-method test-every-couple ((tests utils-tests) :run nil)
  (flet ((even-sum (a b) (evenp (+ a b))))
    (assert-true (every-couple #'even-sum '(1 1 2 2)))
    (assert-false (every-couple #'even-sum '(1 1 2 3)))))
|#

(def-test-method test-plistp ((tests utils-tests) :run nil)
  (assert-true (plistp '(:a 1 :b 2)))
  (assert-false (plistp '(1 2 3 4))))

(def-test-method test-alistp ((tests utils-tests) :run nil)
  (assert-true (alistp '((a 1) (b 2))))
  (assert-false (alistp '(a)))
  (assert-false (alistp '((a))))
  (assert-false (alistp '((a b c)))))

(def-test-method test-doplist ((tests utils-tests) :run nil)
  (let ((plist '(:a 1 :b 2)) list)
    (doplist (key val plist)
      (push-end key list)
      (push-end val list))
    (assert-equal list '(:a 1 :b 2))))

(def-test-method test-hash-values ((tests utils-tests) :run nil)
  (let ((hash (make-hash-table)) list)
    (setf (gethash :a hash) 1)
    (setf (gethash :b hash) 2)
    (setf list (hash-values hash))
    (assert-true (member 1 list)) ; list should have both values in it
    (assert-true (member 2 list))
    (setf list (delete 1 (delete 2 list)))
    (assert-false list))) ; and nothing more

(def-test-method test-hash-equal-p ((tests utils-tests) :run nil)
  (let ((hash1 (make-hash-table)) hash2)
    (setf (gethash :a hash1) 1)
    (setf (gethash :b hash1) 2)
    (setf hash2 (copy-hash-table hash1))
    (assert-true (hash-equal-p hash1 hash2))))

(def-test-method test-partition ((tests utils-tests) :run nil)
  (let* ((list '(1 2 3 4 5 6))
	 (partition (partition list #'oddp)))
    (assert-true (set-equal-p (assoc-value t partition) '(1 3 5)))
    (assert-true (set-equal-p (assoc-value nil partition) '(2 4 6)))))

;(textui-test-run (get-suite utils-tests))
(add-test-suite 'utils-tests)
