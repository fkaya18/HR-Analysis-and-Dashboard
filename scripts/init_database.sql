/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Employeedb' after checking 
    whether it already exists. If 'Employeedb' exists, it is forcefully 
    dropped by setting it to SINGLE_USER mode and rolling back any active 
    connections. A new database is then created with case-sensitive 
    collation (Latin1_General_CS_AS).

    After the database is created, three schemas 'bronze', 'silver' and 'gold'
    are created to organize the data into layers, typically for staging 
    and cleaned/processed data.

WARNING:
    Running this script will completely delete the 'Employeedb' database 
    if it already exists. All objects and data within it will be permanently 
    lost. Ensure that you have appropriate backups before executing this script.
*/


USE master;
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'Employeedb')
BEGIN
	ALTER DATABASE Employeedb SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE Employeedb
END;
GO

CREATE DATABASE Employeedb
COLLATE Latin1_General_CS_AS;
GO

USE Employeedb;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
