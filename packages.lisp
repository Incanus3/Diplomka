(in-package :cl-user)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defpackage :exil-utils
  (:use :common-lisp)
  (:shadow :intern :symbol-name)
  (:export :intern :string-append :symbol-name :symbol-append :to-keyword
	   :from-keyword :mac-exp :subsets :assoc-value :assoc-key :to-list
	   :to-list-of-lists :my-pushnew :ext-pushnew :ext-delete :diff-delete
	   :push-update :class-slot-value :select))

(defpackage :exil-core
  (:use :common-lisp :exil-utils)
  (:shadowing-import-from :exil-utils :intern :symbol-name)
  (:export :variable-p :template :tmpl-name :slots :make-tamplate :find-atom
	   :fact :fact-equal-p :simple-fact :find-atom :atom-position
	   :template-fact :tmpl-fact-slot-value :fact-slot :make-fact
	   :atom-equal-p :constant-test :pattern :negated-p :pattern-equal-p
	   :simple-pattern :var-or-equal-p :template-pattern :make-pattern
	   :rule :rule-equal-p :make-rule :name :conditions :activations))

(defpackage :exil-rete
  (:use :common-lisp :exil-utils :exil-core)
  (:shadowing-import-from :exil-utils :intern :symbol-name)
  (:export :add-wme :rem-wme :new-production :remove-production :make-rete
	   :token->list :token-equal-p))

(defpackage :exil-env
  (:use :common-lisp :exil-utils :exil-core :exil-rete)
  (:shadowing-import-from :exil-utils :intern :symbol-name)
  (:export :add-template :add-fact :rem-fact :reset-environment
	   :add-fact-group :add-rule :rem-fule :find-rule
	   :add-strategy :set-strategy :select-activation
	   :set-watcher :unset-watcher :activate-rule
	   :agenda :fact-groups))

(defpackage :exil
  (:use :common-lisp :exil-utils :exil-core :exil-env)
  (:shadowing-import-from :exil-utils :intern :symbol-name)
  (:export :deftemplate :assert :retract :modify :clear :deffacts :reset
	   :defrule :undefrule :defstrategy :setstrategy :watch :unwatch
	   :step :halt :run)
  (:shadow :assert :step))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defpackage :exil-test
  (:use :common-lisp :exil-utils :exil-core :exil-rete :exil-env)
  (:shadowing-import-from :exil-utils exil-utils::intern
  exil-utils::string-append exil-utils::symbol-name exil-utils::symbol-append
  exil-utils::to-keyword exil-utils::from-keyword exil-utils::mac-exp
  exil-utils::subsets exil-utils::assoc-value exil-utils::assoc-key
  exil-utils::to-list exil-utils::to-list-of-lists exil-utils::my-pushnew
  exil-utils::ext-pushnew exil-utils::ext-delete exil-utils::diff-delete
  exil-utils::push-update exil-utils::class-slot-value exil-utils::select)
  (:shadowing-import-from :exil-core exil-core::variable-p exil-core::template
  exil-core::tmpl-slot-spec exil-core::tmpl-equal-p exil-core::make-template
  exil-core::template-object exil-core::tmpl-object-slot-value
  exil-core::tmpl-object-equal-p exil-core::find-atom exil-core::atom-position
  exil-core::find-template exil-core::make-tmpl-object
  exil-core::tmpl-object-specification-p exil-core::name exil-core::slots
  exil-core::tmpl-name exil-core::fact exil-core::fact-equal-p
  exil-core::simple-fact exil-core::template-fact
  exil-core::tmpl-fact-slot-value exil-core::fact-slot exil-core::make-tmpl-fact
  exil-core::tmpl-fact-specification-p exil-core::make-fact
  exil-core::atom-equal-p exil-core::constant-test exil-core::pattern
  exil-core::pattern-equal-p exil-core::simple-pattern exil-core::var-or-equal-p
  exil-core::pattern-const-equal-p exil-core::template-pattern
  exil-core::tmpl-pattern-slot-value exil-core::pattern-slot
  exil-core::make-tmpl-pattern exil-core::tmpl-pattern-specification-p
  exil-core::make-pattern exil-core::negated-p exil-core::rule
  exil-core::rule-equal-p exil-core::make-rule exil-core::conditions
  exil-core::activations)
  (:shadowing-import-from :exil-rete exil-rete::token exil-rete::empty-token
  exil-rete::previous-wme exil-rete::includes-p exil-rete::token-equal-p
  exil-rete::token->list exil-rete::parent exil-rete::wme
  exil-rete::negative-wmes exil-rete::described-object exil-rete::node
  exil-rete::node-equal-p exil-rete::add-child exil-rete::add-children
  exil-rete::activate exil-rete::activate-children exil-rete::inactivate
  exil-rete::inactivate-children exil-rete::memory-node exil-rete::add-item
  exil-rete::description exil-rete::children exil-rete::items
  exil-rete::alpha-node exil-rete::alpha-test-node exil-rete::test
  exil-rete::activate-memory exil-rete::simple-fact-alpha-node
  exil-rete::template-fact-alpha-node exil-rete::simple-fact-test-node
  exil-rete::template-fact-test-node exil-rete::alpha-subtop-node
  exil-rete::simple-fact-subtop-node exil-rete::template-fact-subtop-node
  exil-rete::alpha-top-node exil-rete::get-network exil-rete::initialize-network
  exil-rete::get/initialize-network exil-rete::alpha-memory-node
  exil-rete::tested-field exil-rete::value exil-rete::memory exil-rete::networks
  exil-rete::simple-fact-key-name exil-rete::beta-node
  exil-rete::beta-memory-node exil-rete::agenda exil-rete::add-match
  exil-rete::remove-match exil-rete::complete-match exil-rete::broken-match
  exil-rete::add-production exil-rete::delete-production
  exil-rete::beta-top-node exil-rete::make-test exil-rete::test-equal-p
  exil-rete::tests-equal-p exil-rete::beta-join-node exil-rete::beta-memory
  exil-rete::perform-join-test exil-rete::perform-join-tests
  exil-rete::beta-negative-node exil-rete::get-bad-wmes exil-rete::productions
  exil-rete::current-field exil-rete::previous-condition
  exil-rete::previous-field exil-rete::alpha-memory exil-rete::tests
  exil-rete::rete exil-rete::add-wme exil-rete::rem-wme exil-rete::make-rete
  exil-rete::find-test-node exil-rete::find/create-test-node%
  exil-rete::find/create-test-node exil-rete::create-alpha-net%
  exil-rete::create-alpha-net exil-rete::find-atom-in-cond-list%
  exil-rete::get-intercondition-tests% exil-rete::get-intracondition-tests%
  exil-rete::get-join-tests-from-condition exil-rete::find/create-join-node
  exil-rete::find/create-neg-node exil-rete::new-production
  exil-rete::remove-production)
  (:shadowing-import-from :exil-env exil-env::match exil-env::make-match
  exil-env::match-equal-p exil-env::match-rule exil-env::match-token
  exil-env::timestamp exil-env::variable-bindings
  exil-env::get-variable-bindings exil-env::substitute-variables
  exil-env::activate-rule exil-env::newer-than exil-env::depth-strategy
  exil-env::breadth-strategy exil-env::simpler-than
  exil-env::simplicity-strategy exil-env::complexity-strategy
  exil-env::exil-environment exil-env::*environments* exil-env::defenv
  exil-env::setenv exil-env::*current-environment* exil-env::exil-env-reader
  exil-env::exil-env-writer exil-env::exil-env-accessor
  exil-env::exil-env-accessors exil-env::facts exil-env::add-fact
  exil-env::rem-fact exil-env::add-fact-group exil-env::add-template
  exil-env::find-template exil-env::add-rule exil-env::remove-matches
  exil-env::rem-rule exil-env::find-rule exil-env::add-match
  exil-env::remove-match exil-env::add-strategy exil-env::set-strategy
  exil-env::current-strategy exil-env::select-activation exil-env::set-watcher
  exil-env::unset-watcher exil-env::watched-p exil-env::reset-environment
  exil-env::completely-reset-environment exil-env::fact-groups
  exil-env::templates exil-env::rules exil-env::rete exil-env::agenda
  exil-env::strategies exil-env::current-strategy-name exil-env::watchers)
  (:shadowing-import-from :exil exil::deftemplate exil::assert% exil::assert
  exil::retract% exil::retract exil::modify% exil::modify exil::clear
  exil::deffacts exil::assert-group% exil::reset exil::defrule exil::undefrule
  exil::defstrategy exil::setstrategy exil::step exil::*exil-running* exil::halt
  exil::run exil::watch exil::unwatch))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
