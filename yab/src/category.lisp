(in-package :cl-user)
(defpackage yab.category
  (:use :cl
        :sxql
        :datafly)
  (:import-from :yab.db
                db
                with-connection)
  (:export :get-all-categories
           :get-category
           :add-category
           :update-category))
(in-package :yab.category)

(defun get-all-categories ()
  (with-connection (db)
    (retrieve-all
     (select :*
       (from :category)))))

(defun get-category (id)
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :category)
       (where (:= :id id))))))

(defun add-category (data)
  (with-connection (db)
    (execute
     (insert-into :category
       (set= :label (cdr (first data)))))))

(defun update-category (id data)
  (with-connection (db)
    (execute
     (update :category
       (set= :label (first (cdr data)))
       (where (:= :id id))))))
