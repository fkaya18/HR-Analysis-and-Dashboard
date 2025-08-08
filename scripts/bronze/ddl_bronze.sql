/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    Drops and recreates tables in the 'bronze' schema of the 'Employeedb' 
    database. Use this script to reset the DDL structure of raw data tables.
===============================================================================
*/


USE Employeedb;
GO


IF OBJECT_ID('bronze.Employees', 'U') IS NOT NULL
	DROP TABLE bronze.Employees;
GO

CREATE TABLE bronze.Employees(
	employee_id INT PRIMARY KEY,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	start_date DATE,
	exit_date DATE,
	title NVARCHAR(50),
	supervisor NVARCHAR(50),
	email NVARCHAR(50),
	business_unit NVARCHAR(50),
	employee_status NVARCHAR(50),
	employment_type NVARCHAR(50),
	payzone NVARCHAR(50),
	employee_classification_type NVARCHAR(50),
	termination_type NVARCHAR(50),
	termination_desc NVARCHAR(50),
	department NVARCHAR(50),
	division NVARCHAR(50),
	birthdate NVARCHAR(50),
	state NVARCHAR(50),
	job_function NVARCHAR(50),
	gender NVARCHAR(50),
	location_code NVARCHAR(50),
	race NVARCHAR(50),
	marital_status NVARCHAR(50),
	performance_score NVARCHAR(50),
	current_rating INT
);
GO


IF OBJECT_ID('bronze.EngagementSurvey', 'U') IS NOT NULL
	DROP TABLE bronze.EngagementSurvey;
GO

CREATE TABLE bronze.EngagementSurvey(
	employee_id INT PRIMARY KEY,
	survey_date NVARCHAR(50),
	engagement_score INT,
	satisfaction_score INT,
	work_life_balance_score INT
);
GO


IF OBJECT_ID('bronze.TrainingandDevelopment', 'U') IS NOT NULL
	DROP TABLE bronze.TrainingandDevelopment;
GO

CREATE TABLE bronze.TrainingandDevelopment(
	employee_id INT PRIMARY KEY,
	training_date DATE,
	training_name NVARCHAR(50),
	training_type NVARCHAR(50),
	outcome NVARCHAR(50),
	training_location NVARCHAR(50),
	trainer NVARCHAR(50),
	duration_days INT,
	cost FLOAT
);
