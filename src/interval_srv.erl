%% Copyright
-module(interval_srv).
-author("eshubin").

-behaviour(gen_server).

%% API
-export([start_link/1, find/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% API
start_link(FileName) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, FileName, []).

find(N) ->
  gen_server:call(?MODULE, {point, N}).

%% gen_server callbacks
-record(state, {tree}).

init(FileName) ->
  {ok, #state{tree = interval_container:new(interval_reader:read(FileName))}}.

handle_call({point, N}, _From, #state{tree = Tree} = State) ->
  R = interval_container:find(N, Tree),
  {reply, R, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

-include_lib("eunit/include/eunit.hrl").

interval_srv_test_() ->
  {
    setup,
    fun() ->
      start_link("../priv/two_intervals")
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
