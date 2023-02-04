## Initial database setup
- Storage Inventory services have been tested with postgres 12.3.  Newer versions will likely work as well.
- It is assumed that you already have postgres installed.
- In the following, the database being created is called `si_db`, but you can change that name as you see fit.
- Initialize the database: `initdb -D /var/lib/pgsql/data --encoding=UTF8 --lc-collate=C --lc-ctype=C`
  - You might need to change the data location (`-D`), depending on your postgres installation and hardware layout.
- As the postgres user, create a file named [si.dll](si.dll) with the linked content and run `psql -f si.dll -a`
  - This will create three users:
    - `tapadm` - privileged user.  Manages the tap schema with permissions to create, alter, and drop tables 
    - `tapuser` - unprivileged user.  Used by the `luskan` service to query the inventory database.
    - `invadm` - privileged user. Manages the inventory schema with privileges to create, alter, and drop tables, and is also used to insert, update, and delete rows in the inventory tables.
  - NOTE: The first service or application to connect to the database will create and initialize the tables and indices using the above privileged user roles.
- edit pg_hba.conf to allow access from nodes running services and applications

