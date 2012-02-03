(defmodule bess_zog
 (export all))

;;;--------------------------------------------------------------------
;;; defines
;;;--------------------------------------------------------------------
(defsyntax session-cookie-name
 ([] '"zogs"))

(defun cookie-name ()
 (session-cookie-name))

;;;--------------------------------------------------------------------
;;; zog_web callbacks
;;;--------------------------------------------------------------------
(defun logged_in (redis cxn)
 (not (=:= 'nil (session_uid redis cxn))))

(defun session_uid (redis cxn)
 (: bess session-uid redis (session-id cxn)))

; login and log session stats
(defun set_session (redis cxn uid)
 (let ((session-id (gen-session-id))
       (ip  (call cxn 'get 'peer))
       (ua  (call cxn 'get_header_value '"user-agent"))
       (src (call cxn 'get_header_value '"referer"))
       (loginTS (now-s)))
  (: bess login redis session-id uid)
  (: bess session-login-stats redis session-id ip ua src uid loginTS)
  session-id)) ; return session id so client can manually set session cookie

; logout
(defun remove_session (redis cxn)
 (: bess logout redis (session-id cxn) (now-s)))

;;;--------------------------------------------------------------------
;;; helpers
;;;--------------------------------------------------------------------
(defun session-id (cxn)
 (call cxn 'get_cookie_value (session-cookie-name)))

(defun gen-session-id ()
 (: mochihex to_hex (: crypto rand_bytes 24))) ; 24 bytes = 48 hex characters.

(defun now-s ()
 (calc-now-to-s (now)))

(defun calc-now-to-s
 ([(tuple mega sec _)]
  (+ (* mega 1000000) sec)))
