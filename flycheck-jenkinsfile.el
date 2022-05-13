;;; flycheck-jenkinsfile.el
;;
;; Copyright (c) 2020 Arista Networks
;;
;; Author: Rski <rom.skiad@gmail.com>
;; URL: https://github.com/rski/flycheck-jenkinsfile
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(require 'flycheck)

(defgroup flycheck-jenkinsfile nil
  "Support for validating Jenkinsfiles with curl."
  :group 'flycheck-jenkinsfile)

(defcustom flycheck-jenkinsfile-jenkins-url ""
  "Where jenkins lives"
  :type 'string
  :safe #'stringp
  :group 'flycheck-jenkinsfile)

;; (defcustom flycheck-jenkinsfile-jenkins-crumb ""
;;   "The crumb."
;;   :type 'string
;;   :safe #'stringp
;;   :group 'flycheck-jenkinsfile)

(flycheck-define-checker
    jenkinsfile
  "A Jenkins declarative pipeline syntax checker using the Jenkins declarative linter.
See URL `https://www.jenkins.io/doc/book/pipeline/development/#linter'. Using CURL"
  :command ("curl"
            ;; (option "-H" flycheck-jenkinsfile-jenkins-crumb)
            (eval (when buffer-file-name
                    (concat "-F jenkinsfile=<" buffer-file-name)))
            (eval (concat flycheck-jenkinsfile-jenkins-url "/pipeline-model-converter/validate")))
  :standard-input t
  :error-patterns ((error line-start "WorkflowScript: " line ": " (message) "@ line " line ", column " column "."))
  :modes (groovy-mode jenkinsfile-mode))

(add-to-list 'flycheck-checkers 'jenkinsfile)
