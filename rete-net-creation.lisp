(in-package :exil)

(defmethod find-test-node ((parent alpha-node) field value)
  (dolist (child (children parent) nil)
    (when (and (equalp (tested-field child) field)
	       (var-or-equal-p (value child) value))
      (return child))))

(defmethod find/create-test-node% (parent field value new-node-type)
  (let ((node (find-test-node parent field value)))
    (if node
	(values node nil)
	(values (make-instance new-node-type
			       :tested-field field
			       :value value) t))))

(defgeneric find/create-test-node (parent field value)
  (:method ((parent simple-fact-alpha-node) field value)
    (find/create-test-node% parent field value 'simple-fact-test-node))
  (:method ((parent template-fact-alpha-node) field value)
    (find/create-test-node% parent field value 'template-fact-test-node)))

(defmethod create-alpha-net ((pattern simple-pattern) (root simple-fact-subtop-node))
  (loop with pattern = (pattern pattern)
     with node = root
     for atom in pattern
     for field upto (1- (length pattern))
     do (multiple-value-bind (child created-p) (find/create-test-node node field atom)
	  (print (list node child created-p))
	  (when created-p (add-child node child))
	  (setf node child))
     finally
       (progn
	 (print (list node (memory node)))
       (return (if (memory node)
		   (memory node)
		   (setf (memory node)
			 (make-instance 'alpha-memory-node)))))))

(defmethod template-create-alpha-net ((pattern template-pattern) (root alpha-subtop-node)))

(defmethod create-alpha-net ((pattern pattern) (root alpha-top-node))
  )
