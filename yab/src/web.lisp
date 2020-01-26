(in-package :cl-user)
(defpackage yab.web
  (:use :cl
        :caveman2
        :yab.config
        :yab.view
        :yab.db
        :datafly
        :sxql)
  (:import-from :yab.entry
                :get-entry
                :get-all-entries
                :add-and-return-entry
                :update-and-return-entry)
  (:export :*web*))
(in-package :yab.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"
          (list :entries (get-all-entries))))

(defroute "/add" ()
  (render #P"add.html"))

(defroute "/edit/:id" (&key id)
  (render #P"edit.html"
          (list :entry (get-entry id))))

(defroute "/view/:id" (&key id)
  (render #P"view.html"
          (list :entry (get-entry id))))

(defroute ("/add-entry" :method :POST) (&key _parsed)
  (render #P"view.html"
          (list :entry (add-and-return-entry _parsed))))

(defroute ("/update-entry/:id" :method :POST) (&key id _parsed)
  (render #P"view.html"
          (list :entry (update-and-return-entry id _parsed))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
