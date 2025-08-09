/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    Drops and recreates cleaned and transformed tables in the 'silver' schema.
    This layer structures refined data for analysis, such as type conversions, 
    calculated fields (e.g. age, overall_avg_score), and consistency improvements.
===============================================================================
*/

USE Employeedb;
GO

IF OBJECT_ID('silver.Employees', 'U') IS NOT NULL
	DROP TABLE silver.Employees;
GO

CREATE TABLE silver.Employees(
	employee_id INT PRIMARY KEY,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	email NVARCHAR(50),
	birthdate DATE,
	age INT,
	gender NVARCHAR(50),
	race NVARCHAR(50),
	marital_status NVARCHAR(50),
	state NVARCHAR(50),
	location_code NVARCHAR(50),
	start_date DATE,
	exit_date DATE,
	employee_status NVARCHAR(50),
	employment_type NVARCHAR(50),
	employee_classification_type NVARCHAR(50),
	termination_type NVARCHAR(50),
	title NVARCHAR(50),
	supervisor NVARCHAR(50),
	department NVARCHAR(50),
	business_unit NVARCHAR(50),
	payzone NVARCHAR(50),
	performance_score NVARCHAR(50),
	current_rating INT
);
GO


IF OBJECT_ID('silver.EngagementSurvey', 'U') IS NOT NULL
	DROP TABLE silver.EngagementSurvey;
GO

CREATE TABLE silver.EngagementSurvey(
	employee_id INT,
	survey_date DATE,
	engagement_score INT,
	satisfaction_score INT,
	work_life_balance_score INT,
	overall_avg_score FLOAT,
	PRIMARY KEY(employee_id, survey_date)
);
GO


IF OBJECT_ID('silver.TrainingandDevelopment', 'U') IS NOT NULL
	DROP TABLE silver.TrainingandDevelopment;
GO

CREATE TABLE silver.TrainingandDevelopment(
	employee_id INT,
	training_date DATE,
	training_name NVARCHAR(50),
	training_type NVARCHAR(50),
	outcome NVARCHAR(50),
	training_location NVARCHAR(50),
	trainer NVARCHAR(50),
	duration_days INT,
	cost FLOAT,
	PRIMARY KEY(employee_id, training_date, training_name)
)