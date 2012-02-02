-module(bess_tests).

-include_lib("eunit/include/eunit.hrl").

%%%----------------------------------------------------------------------
%%% Prelude
%%%----------------------------------------------------------------------
bess_test_() ->
  {setup,
    fun setup/0,
    fun teardown/1,
    [
     {"Login",
       fun login/0},
     {"Login Stats",
       fun set_login_stats/0},
     {"Logout",
       fun logout/0}
    ]
  }.

%%%----------------------------------------------------------------------
%%% Tests
%%%----------------------------------------------------------------------
login() ->
  bess:'login'(tester, sessionid, uid),
  Uid = bess:'session-uid'(tester, sessionid),
  ?assertEqual(<<"uid">>, Uid).

set_login_stats() ->
  bess:'session-login-stats'(tester, sessionid, ip, ua, src, uid, loginTS).

logout() ->
  bess:'logout'(tester, sessionid, logoutTimestamp),
  Uid = bess:'session-uid'(tester, sessionid),
  ?assertEqual(nil, Uid).

%%%----------------------------------------------------------------------
%%% Setup / Cleanup
%%%----------------------------------------------------------------------
setup() ->
  application:start(er),
  er_pool:start_link(tester, "127.0.0.1", 9961),
  er:flushall(tester).

teardown(_) ->
  ok.
