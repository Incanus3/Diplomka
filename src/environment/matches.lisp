(in-package :exil-env)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; match represents a rule whose conditions have been satisfied by a list of
;; facts (represented by token)
;; environment's agenda keeps track of matches from which they're then selected
;; and the match rules fired (the variable bindings are resolved and substituted
;; in rule's RHS activations before its evaluation)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; public
(defclass match () ((rule :initarg :rule :reader match-rule
                          :initform (error "match rule has to be specified"))
                    (token :initarg :token :reader match-token
                           :initform (error "match token has to be specified"))
                    (timestamp :initarg :timestamp :reader timestamp
                               :initform (get-internal-real-time))))

; public
(defun make-match (rule token &optional (timestamp (get-internal-real-time)))
  (make-instance 'match :rule rule :token token :timestamp timestamp))

(defgeneric match-equal-p (match1 match2))

; public
(defmethod match-equal-p ((match1 match) (match2 match))
  (and (rule-equal-p (match-rule match1)
                     (match-rule match2))
       (token-equal-p (match-token match1)
                      (match-token match2))))

(defun rule-name (match)
  (name (match-rule match)))

; public
(defmethod print-object ((match match) stream)
  (if *print-escape*
      (print-unreadable-object (match stream :type t :identity t)
        (format stream "~S" (list (match-rule match)
                                  (token->list (match-token match)))))
      (format stream "(MATCH ~A ~A)"
              (rule-name match)
              (token->list (match-token match)))))

(defun copy-match (match)
  (make-match (match-rule match) (match-token match)))
