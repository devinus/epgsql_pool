-module(epgsql_pool).

-export([child_spec/2, squery/2, equery/3]).

child_spec(Name, Args) ->
    WorkerModule = {worker_module, epgsql_pool_worker},
    PoolArgs = lists:keystore(worker_module, 1, Args, WorkerModule),
    poolboy:child_spec(Name, PoolArgs).

squery(PoolName, Sql) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        epgsql_pool_worker:squery(Worker, Sql)
    end).

equery(PoolName, Stmt, Params) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        epgsql_pool_worker:equery(Worker, Stmt, Params)
    end).
