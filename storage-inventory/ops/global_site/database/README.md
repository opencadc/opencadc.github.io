## Initial database setup
- Storage Inventory services have been tested with postgres 12.3.  Newer versions will likely work as well.
- It is assumed that you already have postgres installed.
- As the content in the database grows, you'll need to think about its storage requirements.  For the PG data and indices, this is roughly 1KB/artifact (storage site) or 1.5KB/artifact (global site)
- In the following, the database being created is called `global_db`, but you can change that name as you see fit.
- Initialize the database: `initdb -D /var/lib/postgresql/data --encoding=UTF8 --lc-collate=C --lc-ctype=C`
  - You might need to change the data location (`-D`), depending on your postgres installation and hardware layout.
- As the postgres user, create a file named [si.dll](si.dll) with the linked content and run `psql -f si.dll -a`
  - This will create three users:
    - `tapadm` - privileged user.  Manages the tap schema with permissions to create, alter, and drop tables 
    - `tapuser` - unprivileged user.  Used by the `luskan` service to query the inventory database.
    - `invadm` - privileged user. Manages the inventory schema with privileges to create, alter, and drop tables, and is also used to insert, update, and delete rows in the inventory tables.
  - NOTE: The first service or application to connect to the database will create and initialize the tables and indices using the above privileged user roles.

Example of how to set up _Storage site_ database for testing purposes:

1. Edit the [si.dll](si.dll) file and add passwords for the `invadm`, `tapadm`, and `tapuser` accounts.  You will need to add these same passwords to the config (`.properties`) files for the _Storage site_ services and applications.
1. Create a docker volume for the database.  

    ```
    docker volume create GLOBAL_SITE_PG_DATA
    ```

1. Initialize the database:

    ```
    POSTGRES_PASSWORD=xxyyzz PGHOME=/var/lib/postgresql PG_INSTALL_DIR=/usr/lib/postgresql/12 sh -c 'docker run --rm  --volume GLOBAL_SITE_PG_DATA:/${PGHOME}/data -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} postgres:12 su -l postgres -c "${PG_INSTALL_DIR}/bin/initdb -D ${PGHOME}/data --encoding=UTF8 --lc-collate=C --lc-ctype=C"'
    ```

1. Start the database:

    ```
    POSTGRES_PASSWORD=xxyyzz PGHOME=/var/lib/postgresql PG_INSTALL_DIR=/usr/lib/postgresql/12 sh -c 'docker run --rm --volume GLOBAL_SITE_PG_DATA:${PGHOME}/data -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} --detach --name storage_db postgres:12 su -l postgres -c "${PG_INSTALL_DIR}/bin/postgres -D ${PGHOME}/data"'

1. Copy the [`pg_hba.conf`](pg_hba.conf) and [`si.dll`](si.dll) files to the container:

    ```
    PGHOME=/var/lib/postgresql sh -c 'docker cp pg_hba.conf storage_db:${PGHOME}/data/pg_hba.conf'
    PGHOME=/var/lib/postgresql sh -c 'docker cp si.dll storage_db:${PGHOME}/si.dll'
    ```

1. Run the `si.dll` file in the database, then restart the server:

    ```
    PGHOME=/var/lib/postgresql sh -c 'docker exec storage_db su postgres -c "mkdir ${PGHOME}/data/global_data; psql -f ${PGHOME}/si.dll -a"'
    PG_INSTALL_DIR=/usr/lib/postgresql/12 sh -c 'docker exec storage_db su postgres -c "${PG_INSTALL_DIR}/bin/pg_ctl reload"'
