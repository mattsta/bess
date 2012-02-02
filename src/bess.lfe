(defmodule bess
 (export all))

;;;--------------------------------------------------------------------
;;; Keys
;;;--------------------------------------------------------------------
(defsyntax key-session-to-uid
 ([session-id] (: eru er_key 'session session-id)))

(defsyntax key-uid-to-current-sessions
 ([uid] (: eru er_key 'sessions-current uid)))

(defsyntax key-uid-to-old-sessions
 ([uid] (: eru er_key 'sessions-old uid)))

(defsyntax key-session-stats
 ([session-id] (: eru er_key 'stats session-id)))

;;;--------------------------------------------------------------------
;;; Session Creation
;;;--------------------------------------------------------------------
(defun login (redis session-id uid)
 (: er set redis (key-session-to-uid session-id) uid)
 (: er sadd redis (key-uid-to-current-sessions uid) session-id))

(defun session-login-stats (redis session-id ip ua src uid loginTS)
 (: er hmset redis (key-session-stats session-id)
  (list 'ip ip
        'ua ua
        'src src
        'uid uid
        'login loginTS)))

(defun logout (redis session-id logoutTS)
 (let ((uid (session-uid redis session-id)))
  (: er hset redis (key-session-stats session-id) 'logout logoutTS)
  (: er srem redis (key-uid-to-current-sessions uid) session-id)
  (: er sadd redis (key-uid-to-old-sessions uid) session-id)
  (: er del redis (key-session-to-uid session-id))))

;;;--------------------------------------------------------------------
;;; Session Reading
;;;--------------------------------------------------------------------
(defun session-uid (redis session-id)
 (: er get redis (key-session-to-uid session-id)))

(defun session-stats-active-for-uid (redis uid)
 (lc ((<- s (: er smembers redis (key-uid-to-current-sessions uid))))
  (session-stats redis s)))

(defun session-stats-old-for-uid (redis uid)
 (lc ((<- s (: er smembers redis (key-uid-to-old-sessions uid))))
  (session-stats redis s)))

(defun session-stats (redis session-id)
 (: er hgetall_p redis (key-session-stats session-id)))
