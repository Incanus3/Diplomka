(in-package :exil-user)
(declaim (optimize (compilation-speed 0) (debug 3) (space 0) (speed 0)))

(format t "~%~%Running examples with simple facts:~%")

(complete-reset)

(deffacts world
  (in robot B)
  (in box A)
  (goal move box A B))

(defrule move-robot
  (goal move ?object ?from ?to)
  (in ?object ?from)
  (- in robot ?from)
  ?original <- (in robot ?z)
  =>
  (retract ?original)
  (assert (in robot ?from)))

(defrule move-object
  (goal move ?object ?from ?to)
  ?obj-pos <- (in ?object ?from)
  ?rob-pos <- (in robot ?from)
  =>
  (retract ?obj-pos)
  (retract ?rob-pos)
  (assert (in robot ?to))
  (assert (in ?object ?to)))

(defrule stop
  (goal move ?object ?from ?to)
  (in ?object ?to)
  =>
  (halt))

(unwatch all)
(watch facts)
;(watch activations)

(reset)

(run)

#|
(step)
|#

;(complete-reset)
