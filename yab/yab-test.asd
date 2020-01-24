(defsystem "yab-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Abishek Goda"
  :license ""
  :depends-on ("yab"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "yab"))))
  :description "Test system for yab"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
