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
           :add-and-return-entry
           :update-and-return-entry))
(in-package :yab.entry)

(defun get-all-entries ()
  (with-connection (db)
    (retrieve-all
     (select :*
       (from :entry)))))

(defun get-entry (id)
  (with-connection (db)
    (retrieve-one
     (select (:entry.id :title :content (:as :label :category))
             (from :entry)
             (full-join :category :on (:= :entry.category :category.id))
             (where (:= :entry.id id))))))

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

(defun extract-category (data)
  (loop
     for assoc in data
     do
       (if (equalp (car assoc) "category")
           (return (cdr assoc)))))

(defun add-and-return-entry (entry-data)
  (let ((title (extract-title entry-data))
        (content (extract-content entry-data))
        (category (extract-category entry-data)))
    (with-connection (db)
      (get-entry
       (getf
        (retrieve-one
         (insert-into :entry
           (set= :title title
                 :content content
                 :category category)
           (returning :id))) :id)))))
  

(defun update-and-return-entry (id entry-data)
  (let ((title (extract-title entry-data))
        (content (extract-content entry-data))
        (category (extract-category entry-data)))
    (progn
      (with-connection (db)
        (execute
         (update :entry
           (set= :title title
                 :content content
                 :category category)
           (where (:= :id id)))))
      (get-entry id))))
