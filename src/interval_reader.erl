%% Copyright
-module(interval_reader).
-author("eshubin").

%% API
-export([read/1]).


-define(PARSE_FORMAT, "~d\"~d\\~f\\\"").

read(FileName) ->
  {ok, IO} = file:open(FileName, [read]),
  D = orddict:new(),
  read(IO, D).


read(IO, Acc) ->
  case parse(IO) of
    {{Left, Right}, Float} ->
      read(IO, orddict:store(Right, {Left, Float}, Acc));
    _ ->
      Acc
  end.

parse(IO) ->
  case io:fread(IO, "", ?PARSE_FORMAT) of
    {ok, [Left, Right, Float]} when (Left =< Right) ->
      {{Left, Right}, Float};
    eof ->
      eof
  end.


-include_lib("eunit/include/eunit.hrl").

parse_test_() ->
  [
    ?_assertEqual(
      {ok, [13935775370, 365916480006, 0.8678967605514785], []},
      io_lib:fread(?PARSE_FORMAT, "13935775370\"365916480006\\8.67896760551478463341e-01\\\"")
    )
  ].

read_test_() ->
  [
    ?_assertEqual([{9999949665618589, {9999926652351211, 0.7206746158803935}}], read("../priv/single_interval")),
    ?_assertEqual(
      [{365916480006,
        {13935775370, 0.8678967605514785}},
        {406822291477,
          {401297465489, 0.5527523660317453}}],
      read("../priv/two_intervals")
    ),
    %next test take much time
    {timeout, 24000, ?_assertMatch([_|_], read("../priv/orig_intervals"))},
    ?_assertError(_, read("../priv/not_existent")),
    ?_assertError(_, read("../priv/malformed"))
  ].