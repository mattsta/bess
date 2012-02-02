(defmodule rbess
 (export all))

(defmacro zs-call
 ([fn redis-name args]
  `(defun ,fn ,args
    (: bess ,fn ',redis-name ,@args))))

(defmacro mk-bess-tied-to-redis-name
 ([redis-name]
  `(progn
    (zs-call login ,redis-name (session-id uid))
    (zs-call session-login-stats ,redis-name (session-id ip ua src ud ts))
    (zs-call logout ,redis-name (session-id logoutTS))
    (zs-call session-uid ,redis-name (session-id))
    (zs-call session-stats-active-for-uid ,redis-name (uid))
    (zs-call session-stats-old-for-uid ,redis-name (uid))
    (zs-call session-stats ,redis-name (session-id)))))

(mk-bess-tied-to-redis-name redis_bess)
