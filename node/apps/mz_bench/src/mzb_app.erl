-module(mzb_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_, _) ->
    {ok, WorkerDirs} = application:get_env(mz_bench, workers_dirs),

    CodeWildcards =
        [filename:join([D, "*", "ebin"])              || D <- WorkerDirs] ++
        [filename:join([D, "*", "deps", "*", "ebin"]) || D <- WorkerDirs],

    CodePaths = lists:append([filelib:wildcard(WC) || WC <- CodeWildcards]),
    code:add_pathsz([filename:absname(P) || P <- CodePaths]),
    mzb_sup:start_link().

stop(_State) ->
    ok.
