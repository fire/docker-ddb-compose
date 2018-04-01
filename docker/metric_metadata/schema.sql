-- CREATE DATABASE metric_metadata;
CREATE USER ddb WITH PASSWORD 'ddb' SUPERUSER;
CREATE DATABASE metric_metadata OWNER ddb;
GRANT ALL ON DATABASE metric_metadata TO ddb;
