bess: basic erlang session system
=================================

Status
------
`bess` is a small and dumb big cookie to local UID lookup
service.  All session information is stored in redis.
`bess` has a native zog module so `zog_web` can use
`bess` without any further configuration.

Usage
-----
See the tests.  It's all pretty simple and dumb.

Building
--------
        rebar get-deps
        rebar compile

Testing
-------
        rebar eunit skip_deps=true suite=bess

Next Steps
----------
There's no step three!
