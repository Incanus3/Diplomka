(in-package :exil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; environment cleanup

; public
(defun clear ()
  "delete all facts"
  (reset-environment *current-environment*))

;; DEBUG:
(defun complete-reset ()
  (exil-env::completely-reset-environment *current-environment*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; starting execution

;; TODO: move this behavior to environment
; public
(defun reset ()
  "clear all facts and add all fact groups"
  (clear)
  (dolist (group (fact-groups *current-environment*))
    (assert-group group)))

; public
(defun step ()
  "run inference engine for one turn"
  (when (agenda *current-environment*)
    ;; (format t "~%------------------------------------------------------")
    (activate-rule (select-activation *current-environment*))
    t))

(defvar *exil-running* nil)

; public
(defun halt ()
  "stop the inference engine"
  (format t "~%Halting")
  (setf *exil-running* nil))

; public
(defun run ()
  "run the infenece engine"
  (setf *exil-running* t)
  (iter (while (and *exil-running* (step)))))