#!/bin/bash
if [[ "$(hostname | cut -f1 -d-)" == "codespaces" ]] ; then
    apt update
    apt install postgresql
    service postgresql start
    su -c 'psql -c "CREATE DATABASE accelerate"' postgres
    su -c 'psql -c "CREATE TABLE transactions (project VARCHAR(255), date TIMESTAMP, amount INT, jobid VARCHAR(255))" accelerate' postgres
    su -c 'createuser accelerator' postgres
    sudo useradd accelerator
    su -c 'psql -c "GRANT ALL PRIVILEGES ON TABLE transactions TO accelerator" accelerate' postgres;
    su -c "psql -c 'select * from transactions' accelerate" accelerator

    pip install psycopg2
fi

# psql -h /tmp -U pbsdata -p 15007 pbs_datastore -c "CREATE DATABASE accelerate"

