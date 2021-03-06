(in-package :integration-tests)
(declaim (optimize (compilation-speed 0) (debug 3) (space 0) (speed 0)))

(defclass integration-tests (test-case)
  ((env :accessor env)))

(defmethod set-up ((tests integration-tests))
  (defenv int-test)
  (setenv int-test)
  (setf (env tests) (getenv :int-test)))

(defmethod tear-down ((tests integration-tests))
  (undefenv int-test))

(defclass simple-integration-tests (integration-tests) ())

(defmethod set-up ((tests simple-integration-tests))
  (call-next-method)

  (deffacts world
    (in robot A)
    (in box B)
    (goal push box B A))

  (defrule move
    (goal push ?object ?from ?to)
    (in ?object ?from)
    (- in robot ?from)
    (in robot ?z)
    =>
    (retract (in robot ?z))
    (assert (in robot ?from)))

  (defrule push
    (goal push ?object ?from ?to)
    (in ?object ?from)
    (in robot ?from)
    =>
    (retract (in robot ?from))
    (assert (in robot ?to))
    (retract (in ?object ?from))
    (assert (in ?object ?to)))

  (defrule stop
    (goal push ?object ?from ?to)
    (in ?object ?to)
    =>
    (halt))

  (unwatch all))

(def-test-method simple-integration-test ((tests simple-integration-tests) :run nil)
  (reset)
  (run)
  (assert-true (eenv::find-fact (env tests) (eenv::make-simple-fact '(in box A)))))

(add-test-suite 'simple-integration-tests)
;(textui-test-run (get-suite simple-integration-tests))
