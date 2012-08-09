# epgsql_pool

## Usage

### In a supervisor tree

```erlang
Args = [{name, {local, pool1}},
        {size, 10},
        {max_overflow, 10},
        {hostname, "127.0.0.1"},
        {database, "db1"},
        {username, "db1"},
        {password, "abc123"}],
Pool = epgsql_pool:child_spec(pool1, Args),
{ok, {{one_for_one, 10, 10}, [Pool]}}.
```
