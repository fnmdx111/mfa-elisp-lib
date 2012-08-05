;;; mfa-misc.el --- miscellaneous functions wrote for convenience

;; Copyright (C) 2012  

;; Author:  <wo@SIMPLE-PORTABLE>
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


(defun mfa/join (l separator)
  (apply 'concat
	 (car l)
	 (mapcar #'(lambda (str) (concat separator str))
		 (cdr l))))


(defun mfa/list-image-files (directory)
  (mapcar 'file-name-nondirectory
	  (directory-files directory
			   :match-regexp "\\.\\(png\\|jpg\\|jpeg\\|git\\)")))


(defun mfa/extract-file-name (file-name)
  (file-name-nondirectory (file-name-sans-extension file-name)))


(defun mfa/remove-date (file-name)
  (mfa/join (cdddr (split-string file-name "-")) "-"))


(defun mfa/get-directory-from-bufname (file-name)
  (mfa/remove-date (mfa/extract-file-name file-name)))


(defun mfa/get-images-directory (file-name)
  (concat (file-name-as-directory (expand-file-name "" "../assets/images/"))
	  (mfa/get-directory-from-bufname file-name)))


(defun mfa/yield-choices (file-name)
  (mfa/list-image-files (mfa/get-images-directory file-name)))


(require 'cl)

(defmacro mfa/defmarkfun (name shift search-fn)
  (` (defun* (, name) (ch &optional (count 1))
       (interactive "cChar? \np")
       (let* ((cur-pnt (point))
	      (cur-char (string-to-char (buffer-substring cur-pnt (+ 1 cur-pnt))))
	      (cnt (+ count (if (equal cur-char ch) 1 0)))
	      (target-pnt ((, search-fn) (char-to-string ch) nil nil cnt)))
	 (if (not target-pnt)
	     nil
	   (progn
	     (push-mark cur-pnt nil t)
	     (goto-char (+ target-pnt (, shift)))))))))


(mfa/defmarkfun mfa/mark-till -1 search-forward)
(mfa/defmarkfun mfa/mark-find  0 search-forward)
(mfa/defmarkfun mfa/rmark-till 1 search-backward)
(mfa/defmarkfun mfa/rmark-find 0 search-backward)



(provide 'mfa-misc)

;;; mfa-misc.el ends here
