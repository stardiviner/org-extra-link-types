;;; org-extra-link-types.el --- Add extra link types to Org Mode -*- lexical-binding: t; -*-

;;; Time-stamp: <2020-08-11 09:09:01 stardiviner>

;; Authors: stardiviner <numbchild@gmail.com>
;; Package-Requires: ((emacs "25.1"))
;; Package-Version: 0.1
;; Keywords: org
;; homepage: https://github.com/stardiviner/org-extra-link-types

;; org-extra-link-types is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; org-extra-link-types is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.
;;
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:



;;; Code:

;;===============================================================================
;;; [ telnet ]

;;  telnet://ptt.cc
(org-link-set-parameters "telnet" :follow #'telnet)

;;===============================================================================
;;; [ rss ]

(defun org-rss-link-open (uri)
  "Open rss:// URI link."
  (eww uri))

(org-link-set-parameters "rss" :follow #'org-rss-link-open)

;;===============================================================================
;;; [ tag ]

;; e.g. [[tag:work+phonenumber-boss][Optional Description]]

(defun org-tag-link-open (tag)
  "Display a list of TODO headlines with tag TAG.
With prefix argument, also display headlines without a TODO keyword."
  (org-tags-view (null current-prefix-arg) tag))

(org-link-set-parameters "tag" :follow #'org-tag-link-open)

;;===============================================================================
;;; [ track ]

;;; `track:' for OSM Maps
;; [[track:((9.707032442092896%2052.37033874553582)(9.711474180221558%2052.375238282987))data/images/org-osm-link.svg][Open this link will generate svg, png image for track link on map]]

(if (featurep 'org-osm-link)
    (require 'org-osm-link))



(provide 'org-extra-link-types)

;;; org-extra-link-types.el ends here
