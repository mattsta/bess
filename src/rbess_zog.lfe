(defmodule rbess_zog
 (export all))

(defmacro zs-call
 ([fn redis-name args]
  `(defun ,fn ,args
    (: bess_zog ,fn ',redis-name ,@args))))

(defmacro mk-bess_zog-tied-to-redis-name
 ([redis-name]
  `(progn
    (zs-call logged_in ,redis-name (cxn))
    (zs-call session_uid ,redis-name (cxn))
    (zs-call session_secret ,redis-name (cxn))
    (zs-call set_session ,redis-name (cxn uid))
    (zs-call remove_session ,redis-name (cxn)))))

(mk-bess_zog-tied-to-redis-name redis_bess)
