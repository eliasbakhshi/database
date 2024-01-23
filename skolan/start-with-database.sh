#!/bin/bash

echo "Preparing the database"
sudo mariadb --table < create-database.sql
sudo mariadb --table skolan < ddl-larare.sql
sudo mariadb --table skolan < insert-larare.sql
sudo mariadb --table skolan < ddl-alter.sql
sudo mariadb --table skolan < dml-update.sql
sudo mariadb --table skolan < dml-update-lonerevision.sql

echo "Database is ready to use."
