/*
===============================================================================
Gold Layer View Definitions
===============================================================================
Script Purpose:
    This script creates views for the 'gold' layer HR analytics model 
    (gold.Employees, gold.EngagementSurvey, gold.TrainingandDevelopment).
    These views present clean, business-ready datasets derived from the 
    corresponding 'silver' layer tables.
    They serve as the primary source for reporting, dashboards, and 
    advanced analytics in the HR domain.

Usage Notes:
    - Execute this script after populating the 'silver' layer with transformed data.
    - Dropping and recreating views ensures the latest structure is always in use.
    - These views enforce a standardized schema for analytical consumption.
===============================================================================
*/


USE Employeedb;
GO


IF OBJECT_ID('gold.Employees', 'V') IS NOT NULL
	DROP VIEW gold.Employees;
GO

CREATE VIEW gold.Employees AS 
SELECT
	employee_id,
	first_name,
	last_name,
	email,
	birthdate,
	age,
	gender,
	race,
	marital_status,
	state,
	start_date,
	exit_date,
	employee_status,
	employment_type,
	employee_classification_type,
	termination_type,
	title,
	department,
	payzone,
	performance_score,
	current_rating
FROM silver.Employees;
GO



IF OBJECT_ID('gold.EngagmentSurvey', 'V') IS NOT NULL
	DROP VIEW gold.EngagmentSurvey;
GO

CREATE VIEW gold.EngagmentSurvey AS 
SELECT
	employee_id,
	survey_date,
	engagement_score,
	satisfaction_score,
	work_life_balance_score,
	overall_avg_score
FROM silver.EngagementSurvey;
GO


IF OBJECT_ID('gold.TrainingandDevelopment', 'V') IS NOT NULL
	DROP VIEW gold.TrainingandDevelopment;
GO

CREATE VIEW gold.TrainingandDevelopment AS 
SELECT
	employee_id,
	training_date,
	training_name,
	training_type,
	outcome,
	duration_days,
	cost
FROM silver.TrainingandDevelopment