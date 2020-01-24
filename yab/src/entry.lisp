(in-package :cl-user)
(defpackage yab.entry
  (:use :cl
        :sxql
        :datafly)
  (:import-from :yab.db
                db
                with-connection)
  (:export :get-all-entries
           :get-entry
           :add-and-return-entry))
(in-package yab.entry)

(defun get-all-entries ()
  (with-connection (db)
    (retrieve-all
     (select :*
       (from :entry)))))

(defun get-entry (id)
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :entry)
       (where (:= :id id))))))

(defun extract-title (data)
  (loop
     for assoc in data
     do
       (if (equalp (car assoc) "title")
           (return (cdr assoc)))))

(defun extract-content (data)
  (loop
     for assoc in data
     do
       (if (equalp (car assoc) "content")
           (return (cdr assoc)))))

(defun add-and-return-entry (entry-data)
  (let ((title (extract-title entry-data))
        (content (extract-content entry-data)))
    (with-connection (db)
                     (get-entry
                      (getf
                       (retrieve-one
                        (insert-into :entry
                          (set= :title title
                                :content content)
                          (returning :id))) :id)))))



            
