%% Copyright
-module(interval).
-author("eshubin").

%% API
-export([find/1]).


find(N) when is_integer(N) ->
  interval_srv:find(N).


-include_lib("eunit/include/eunit.hrl").

interval_test_() ->
  {
    setup,
    fun() ->
      ok = application:load(interval),
      ok = application:set_env(interval, filename, "../priv/two_intervals"),
      ok = application:start(interval)
    end,
    fun(_) ->
      application:stop(interval)
    end,
    fun(_) ->
      [
        ?_assertEqual(not_found, find(4)),
        ?_assertEqual(not_found, find(365916480007)),
        ?_assertEqual(not_found, find(506822291477)),
        ?_assertEqual({{401297465489,406822291477}, 0.5527523660317453}, find(401298465489)),
        ?_assertEqual({{13935775370,365916480006}, 0.8678967605514785}, find(13935775371)),
        ?_assertEqual({{13935775370,365916480006}, 0.8678967605514785}, find(365916480006)),
        ?_assertEqual({{13935775370,365916480006}, 0.8678967605514785}, find(13935775370))
      ]
    end
  }.
