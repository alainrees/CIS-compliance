PostgreSQL basics
=================

Author: Matthijs de Munk
Markdown: Imre Jonk

Basic commands
--------------

Login to the database:
```
psql -h localhost -U chef-pggsl -d chef_compliance
```

Show all tables:
```
chef_compliance=# \dt
```
 
List all schemas:
```
chef_compliance=# \dn
```

List all users:
```
chef_compliance=# \du
```

Change user password:
```
ALTER USER chef-pgsql WITH PASSWORD 'new-password';
```

Backup & restore
----------------

Create a backup of the database and save the backup to a file:

```
pg_dump -h localhost -U chef-pgsql -d chef_compliance > chef_compliance.psql
```

The backup will be stored in the directory where you run the command, with the filename 'chef\_compliance.psql'.

Restore the database with the SQL file:
```
psql -h localhost -U chef-pgsql -d chef_compliance < chef_compliance.psql
```
