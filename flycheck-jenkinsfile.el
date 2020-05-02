(require 'flycheck)

(defgroup flycheck-jenkinsfile nil
  "Support for validating Jenkinsfiles with curl."
  :group 'flycheck-jenkinsfile)

(defcustom flycheck-jenkinsfile-jenkins-url ""
  "Where jenkins lives"
  :type 'string
  :safe #'stringp
  :group 'flycheck-jenkinsfile)

(defcustom flycheck-jenkinsfile-jenkins-crumb ""
  "The crumb."
  :type 'string
  :safe #'stringp
  :group 'flycheck-jenkinsfile)

(flycheck-define-checker
    jenkinsfile
  "A Jenkins declarative pipeline checker."
  :command ("curl"
            (option "-H" flycheck-jenkinsfile-jenkins-crumb)
            (eval (when buffer-file-name
                    (concat "-F jenkinsfile=<" buffer-file-name)))
            (eval (concat flycheck-jenkinsfile-jenkins-url "/pipeline-model-converter/validate")))
  :error-patterns (
                   (error line-start "WorkflowScript: " line ": " (message) "@ line " line ", column " column ".")
                   )
  :modes groovy-mode)

(add-to-list 'flycheck-checkers 'jenkinsfile)
