-module(interval_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  {ok, FileName} = application:get_env(filename),
  interval_sup:start_link(FileName).

stop(_State) ->
    ok.
