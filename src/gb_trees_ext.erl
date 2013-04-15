%% Copyright
-module(gb_trees_ext).
-author("eshubin").

%% API
-export([lower_bound/2]).

lower_bound(_, {_, nil}) ->
  none.


-include_lib("eunit/include/eunit.hrl").

lower_bound_test_() ->
  [
    ?_assertEqual(none, lower_bound(3, gb_trees:empty()))
  ].