;;; org-extra-link-types.el --- Add extra link types to Org Mode -*- lexical-binding: t; -*-

;;; Time-stamp: <2020-08-13 19:50:23 stardiviner>

;; Authors: stardiviner <numbchild@gmail.com>
;; Package-Requires: ((emacs "25.1") (olc "1.4.1"))
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

;;===============================================================================
;;; [ geo ]

;;; `geo:'
;; [geo:37.786971,-122.399677;u=35]
;; [[geo:58.397813,15.576063]]
;; [[geo:9FCQ9HXG+4CG]]

;;; Open Location Code library `olc'
(autoload 'olc-encode "olc")
(autoload 'olc-decode "olc")

(defcustom org-geo-link-application-command "gnome-maps"
  "Specify the program name for openning geo: link."
  :type 'string)

(defun org-geo-link-open (link)
  "Open Geography location `URI' like \"geo:25.5889136,100.2208514\" in Map application."
  (let ((location (cond
                   ;; (string-match-p "\\,.*" "25.5889136,100.2208514")
                   ((string-match-p "\\,.*" link)
                    link)
                   ;; (string-match-p "\\+.*" "9FCQ9HXG+4CG")
                   ((string-match-p "\\+.*" link)
                    (when (featurep 'olc)
                      (format "%s,%s"
                              (olc-area-lat (olc-decode link))
                              (olc-area-lon (olc-decode link)))))
                   (t (user-error "Your link is not Geo location or Open Location Code!")))))
    (if (executable-find org-geo-link-application-command)
        (start-process
         "org-geo-link-open"
         "*org-geo-link-open*"
         org-geo-link-application-command
         (shell-quote-wildcard-pattern location))
      (browse-url location))))

(org-link-set-parameters "geo" :follow #'org-geo-link-open)

;;===============================================================================
;;; [ video ]

;;; [[video:/path/to/file.mp4::00:13:20]]

(defcustom org-video-link-open-command "mplayer"
  "Specify the program for openning video: link."
  :type 'string)

(defvar org-video-link-extension-list '("avi" "rmvb" "ogg" "mp4" "mkv"))

(defun org-video-link-open (uri)
  "Open video file `URI' with video player."
  (let* ((list (split-string uri "::"))
         (path (car list))
         (start-timstamp (cadr list)))
    (make-process
     :command (list org-video-link-open-command
                    "-ss" start-timstamp
                    (expand-file-name (org-link-unescape path)))
     :name "org-video-link")))

(defun org-video-complete-link (&optional arg)
  "Create a video link using completion."
  (let ((file (read-file-name "Video: " nil nil nil nil
                              #'(lambda (file)
                                  (seq-contains-p
                                   org-video-link-extension-list
                                   (file-name-extension file)))))
        (pwd (file-name-as-directory (expand-file-name ".")))
        (pwd1 (file-name-as-directory (abbreviate-file-name
                                       (expand-file-name ".")))))
    (cond ((equal arg '(16))
           (concat "video:"
                   (abbreviate-file-name (expand-file-name file))))
          ((string-match
            (concat "^" (regexp-quote pwd1) "\\(.+\\)") file)
           (concat "video:" (match-string 1 file)))
          ((string-match
            (concat "^" (regexp-quote pwd) "\\(.+\\)")
            (expand-file-name file))
           (concat "video:"
                   (match-string 1 (expand-file-name file))))
          (t (concat "video:" file)))))

(org-link-set-parameters "video"
                         :follow #'org-video-link-open
                         :complete #'org-video-complete-link)



(provide 'org-extra-link-types)

;;; org-extra-link-types.el ends here
