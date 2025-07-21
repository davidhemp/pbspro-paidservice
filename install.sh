#!/bin/bash

if [[ "$(hostname | cut -f1 -d-)" == "codespaces" ]] ; then
    apt update
    apt install postgresql
    service postgresql start
    useradd accelerator
    su -c "/workspaces/pbspro-paidservice/create_db.sh" postgres
    pip install psycopg2
fi



# psql -h /tmp -U pbsdata -p 15007 pbs_datastore -c "CREATE DATABASE accelerate"

