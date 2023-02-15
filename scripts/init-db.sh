#!/bin/bash
echo "Hello World, I am a script that connects to a Database and create a table"
echo "I am going to create a table called 'test' in the database 'votes'"
echo "Creating votes table"
psql -w --host=db --port=5432 -d $PGDATABASE -c 'CREATE TABLE IF NOT EXISTS votes (id VARCHAR(255) NOT NULL UNIQUE, vote VARCHAR(255) NOT NULL, created_at timestamp default NULL)'
echo "Creating votes2 table"
psql -w --host=db --port=5432 -d $PGDATABASE -c 'CREATE TABLE IF NOT EXISTS votes2 (id VARCHAR(255) NOT NULL UNIQUE, vote VARCHAR(255) NOT NULL, created_at timestamp default NULL)'
# successful exit code
exit 0
sleep 5