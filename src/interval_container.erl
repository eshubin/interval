%% Copyright
-module(interval_container).
-author("eshubin").

%% API
-export([new/1, find/2]).

new(OrdDict) ->
  gb_trees:from_orddict(OrdDict).


find(N, Tree) ->
  I = gb_trees_ext:lower_bound(N, Tree),
  case gb_trees:next(I) of
    {Right, {Left, Float}, _} when N >= Left ->
      {{Left, Right}, Float};
    _ -> not_found
  end.


-include_lib("eunit/include/eunit.hrl").

container_test_() ->
  {
    setup,
    fun() ->
      new([{X + 3, {X, X}} || X <- lists:seq(0, 2000, 5)])
    end,
    fun(Tree) ->
      [
        ?_assertEqual({{0, 3}, 0}, find(2, Tree)),
        ?_assertEqual({{0, 3}, 0}, find(0, Tree)),
        ?_assertEqual({{0, 3}, 0}, find(1, Tree)),
        ?_assertEqual({{0, 3}, 0}, find(3, Tree)),
        ?_assertEqual(not_found, find(4, Tree)),
        ?_assertEqual({{5, 8}, 5}, find(5, Tree)),

        ?_assertEqual({{2000, 2003}, 2000}, find(2000, Tree)),
        ?_assertEqual({{2000, 2003}, 2000}, find(2001, Tree)),
        ?_assertEqual({{2000, 2003}, 2000}, find(2002, Tree)),
        ?_assertEqual({{2000, 2003}, 2000}, find(2003, Tree)),
        ?_assertEqual(not_found, find(2004, Tree))
      ]
    end
  }.