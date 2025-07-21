#!/bin/bash

if [[ ! -f db_config.ini ]] ; then
    echo "Missing db_config.ini, is should contain the following"
    echo "[database]"
    echo "host=localhost"
    echo "port=5432"
    echo "dbname=accelerate"
    echo "user=accelerator"
    echo "password=somepassword"
    exit 1
fi

if [[ "$(hostname | cut -f1 -d-)" == "codespaces" ]] ; then
    apt update
    apt install postgresql
    service postgresql start
    useradd accelerator
    su -c "/workspaces/pbspro-paidservice/create_db.sh" postgres
    pip install psycopg2
fi



# psql -h /tmp -U pbsdata -p 15007 pbs_datastore -c "CREATE DATABASE accelerate"

