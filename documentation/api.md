API documentation
=================

Author: Imre Jonk

The standardized REST API can be used to securely access compliance information from remote systems. An API key with enough privileges is required for this. The keys are kept in a table with the same name, inside the 'chef\_compliance' database.

Creating the 'keys' table
-------------------------

Connect to the database and execute the query in create-keys-table.psql to create the 'keys' table. All PostgreSQL files can be found in the 'psql' directory in the root of the project repository.

Manually inserting a key
------------------------

If you do not have the privileges required to create keys with the API itself, but do have access to the PostgreSQL database, you can manually create and insert the key. You can try the demo query in insert-sample-key.psql.

Generating an API key
---------------------

You can use the API to create more keys. The required authorization for creating keys is level 10. Just send a PUT request to the key index to create a key:

```
$ curl -X PUT -H 'X-API-KEY: your-level-10-api-key' https://monitoring.stan.ooo/api/key/index
```

HTTP methods
------------

|Method|Description|
|-|-|
|GET|Request data|
|POST|Change data|
|PUT|Insert data|
|DELETE|Remove data|

CIS Compliance API calls
------------------------

All calls require authentication with API keys.

|Call|Method|Arguments|Returns|
|-|-|-|-|
|/api/chef/nodes|GET||All hostnames|
|/api/chef/compliance|GET|$hostname|All scan results of a node|
|/api/chef/patchlevel|GET|$hostname|All patch scans of a node|
