(in-package :exil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; facts

; public
(defun facts (&optional (start-index 1)
                (end-index (length (exil-env:facts *current-environment*)))
                (at-most end-index))
  "return at most at-most facts from start-index to end-index"
  (subseq (exil-env:facts *current-environment*)
          (1- start-index)
          (min end-index (+ start-index at-most -1))))

; private
(defun assert% (fact-spec)
  (add-fact *current-environment* (make-fact *current-environment* fact-spec)))

; public
(defmacro assert (&rest fact-specs)
  "add facts to working memory"
  `(mapc #'assert% ',fact-specs))

;; retract needs to compute the facts to remove first, for when facts are
;; specified by indices and one is removed, the other indices shift
; private
(defun retract% (fact-specs)
  (let (facts-to-remove)
    (dolist (fact-spec fact-specs)
      (typecase fact-spec
        (list (pushnew (make-fact *current-environment* fact-spec)
                       facts-to-remove))
        (integer (pushnew (nth (1- fact-spec)
                               (exil-env:facts *current-environment*))
                          facts-to-remove))
        (t (error "~%Don't know how to retract ~A." fact-spec))))
    (dolist (fact facts-to-remove)
      (rem-fact *current-environment* fact))))

; retract supports either full fact specification e.g. (retract (is-animal duck))
; or number indices (starting with 1) for clips compatitibity.
; It can't support * to retract all facts as clips does, cause this symbol has
; a special meaning in lisp. retract-all does this instead.
; public
(defmacro retract (&rest fact-specs)
  "remove facts from working memory"
  `(retract% ',fact-specs))

; public
(defun retract-all ()
  "remove all facts from working memory"
  (reset-facts *current-environment*))

; private
(defun nonclips-mod-list-p (mod-list)
  (plistp mod-list))

; private
(defun clips-mod-list-p (mod-list)
  (alistp mod-list))

; private
(defun clips->nonclips-mod-list (mod-list)
  (iter (for (slot-name new-val) in mod-list)
        (appending (list (to-keyword slot-name) new-val))))

; private
(defun to-mod-spec-list (mod-list)
  (cond
    ((nonclips-mod-list-p mod-list) mod-list)
    ((clips-mod-list-p mod-list) (clips->nonclips-mod-list mod-list))
    (t (error "~A not a valid modify specifier" mod-list))))

;; mod-list is a mapping from slot-name to new value
;; it can be either plist for non-clips syntax of alist for clips syntax
; private
(defun modify% (fact-spec mod-list)
  (let ((mod-fact (make-fact *current-environment* fact-spec)))
    (unless (typep mod-fact 'template-fact)
      (error "modify: ~S is not a template fact specification" fact-spec))
    (modify-fact *current-environment* mod-fact (to-mod-spec-list mod-list))))

;; used as follows:
;; (defrule push
;;   (goal :object ?x :from ?y :to ?z)
;;   ?object <- (in :object ?x :location ?y)
;;   ?robot <- (in :object robot :location ?y)
;;   =>
;;   (modify ?robot :location ?z)
;;   (modify ?object :location ?z))
;; modify works for template-facts ONLY!
;; it doesn't make much sense to use it for simple facts as there are no
;; slot names that could be used in the mod-list
;; CLIPS doesn't support modify for simple-facts either
; public
(defmacro modify (fact-spec &rest mod-list)
  "modify fact-spec by mod-list"
  `(modify% ',fact-spec ',mod-list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fact groups

; public
(defmacro deffacts (name &body descriptions)
  "create group of facts to be asserted after (reset)"
  (if (stringp (first descriptions)) (pop descriptions))
  `(add-fact-group *current-environment* ',name ',descriptions))

; public
(defmacro undeffacts (name)
  "delete fact group"
  `(rem-fact-group ',name))

; private
(defun assert-group% (group)
  (format t "~%Asserting fact group ~A" (car group))
  (dolist (desc (cdr group))
    (assert% desc)))
