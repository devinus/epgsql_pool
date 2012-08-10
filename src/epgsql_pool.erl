-module(epgsql_pool).

-export([child_spec/3, squery/2, equery/3]).

-spec child_spec(Name :: node(),
                 PoolArgs :: proplists:proplist(),
                 WorkerArgs :: proplists:proplist())
    -> supervisor:child_spec().
child_spec(Name, SizeArgs, WorkerArgs) ->
    PoolArgs = lists:keystore(worker_module, 1, SizeArgs,
                              {worker_module, epgsql_pool_worker}),
    poolboy:child_spec(Name, PoolArgs, WorkerArgs).

-spec squery(PoolName :: node(), Sql :: string()) ->
    term().
squery(PoolName, Sql) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        epgsql_pool_worker:squery(Worker, Sql)
    end).

-spec equery(PoolName :: node(), Stmt :: string(), Params :: list()) ->
    term().
equery(PoolName, Stmt, Params) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        epgsql_pool_worker:equery(Worker, Stmt, Params)
    end).
