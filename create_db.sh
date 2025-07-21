psql -c "CREATE DATABASE accelerate"
psql -c "CREATE TABLE transactions (project VARCHAR(255), date TIMESTAMP, amount INT, jobid VARCHAR(255))" accelerate
createuser accelerator
psql -c "GRANT ALL PRIVILEGES ON TABLE transactions TO accelerator" accelerate
db_password="$(grep password db_config.ini | cut -d'=' -f2)"
psql -c "ALTER USER accelerator WITH PASSWORD '${db_password}'" accelerate