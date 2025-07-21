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

# Used for simple tests on codespaces
if [[ "$(hostname | cut -f1 -d-)" == "codespaces" ]] ; then
    apt update
    apt install postgresql
    service postgresql start
    useradd accelerator
    su -c "/workspaces/pbspro-paidservice/create_db.sh" postgres
    pip install psycopg2
    exit 0
fi

# Install in PBSServer
source /etc/pbs.conf
if [[ -z ${PBS_START_SERVER} ]]; then
    echo "This should be installed on a PBSPro server as it makes changes to the postgres db"
else
    source /etc/os-release
    if [[ "${ID}" == "rhel" ]] ; then
        if [[ -z ${PGPASSWORD} ]] ; then
            echo "A password for pbsdata must be set with pbs_ds_password" 
            echo "This then needs to be set to the PGPASSWORD env var"
            exit 1
        fi
        dnf -y install postgresql python3-psycopg2
        useradd accelerator
        PGPORT=15007 PGDATABASE=pbs_datastore PGUSER=pbsdata PGHOST=/tmp ./create_db.sh
    fi
fi