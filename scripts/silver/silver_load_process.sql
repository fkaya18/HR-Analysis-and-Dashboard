/*
===============================================================================
Stored Procedure: silver.load_silver
===============================================================================
Purpose:
    Transforms and loads data from 'bronze' tables into 'silver' tables.
    Applies business rules, type conversions, field mappings, and filtering logic.
    Ensures only valid and transformed data is loaded into the silver layer.

Usage:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		PRINT '================================================';
		PRINT 'Loading Silver Layer';
		PRINT '================================================';

		-- Employees Table
		PRINT '>> Inserting Data Into: silver.Employees';
		INSERT INTO silver.Employees (
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
			location_code,
			start_date,
			exit_date,
			employee_status,
			employment_type,
			employee_classification_type,
			termination_type,
			title,
			supervisor,
			department,
			business_unit,
			payzone,
			performance_score,
			current_rating
		)
		SELECT
			employee_id,
			first_name,
			CASE 
				WHEN last_name = 'TRUE' THEN 'True'
				ELSE last_name
			END AS last_name,
			email,
			CONVERT(DATE, birthdate, 105) AS birthdate,
			DATEDIFF(YEAR, CONVERT(DATE, birthdate, 105), GETDATE()) 
			- CASE
				WHEN DATEADD(YEAR, DATEDIFF(YEAR, CONVERT(DATE, birthdate, 105), GETDATE()), CONVERT(DATE, birthdate, 105)) > GETDATE() THEN 1
				ELSE 0
			END AS age,
			gender,
			race,
			marital_status,
			state,
			location_code,
			start_date,
			exit_date,
			CASE 
				WHEN termination_type = 'Involuntary' THEN 'Involuntarily Terminated'
				WHEN termination_type = 'Voluntary' THEN 'Voluntarily Terminated'
				WHEN termination_type = 'Resignation' THEN 'Voluntarily Terminated'
				WHEN termination_type = 'Retirement' THEN 'Retired'
				WHEN termination_type = 'Unk' THEN 'Active'
				ELSE employee_status
			END AS employee_status,
			employment_type,
			CASE
				WHEN employment_type = 'Full-Time' AND employee_classification_type = 'Part-Time' THEN 'Full-Time'
				WHEN employment_type = 'Part-Time' AND employee_classification_type = 'Full-Time' THEN 'Part-Time'
				ELSE employee_classification_type
			END AS employee_classification_type,
			CASE
				WHEN termination_type = 'Unk' THEN NULL
				ELSE termination_type
			END AS termination_type,
			title,
			supervisor,
			CASE
				WHEN title IN('CIO', 'IT Manager - Infra', 'IT Manager - Support', 'IT Manager - DB', 'IT Director', 'IT Support', 
							  'Sr. Network Engineer', 'Network Engineer', 'Sr. DBA', 'Database Administrator') THEN 'IT'
				WHEN title IN('Principal Data Architect', 'Data Architect', 'BI Director', 'Senior BI Developer', 
							  'BI Developer', 'Data Analyst', 'Enterprise Architect') THEN 'Data & Analytics'
				WHEN title IN('Software Engineering Manager', 'Software Engineer') THEN 'Engineering'
				WHEN title IN('Director of Operations', 'Production Manager', 'Production Technician I', 
							  'Production Technician II') THEN 'Production & Operations'
				WHEN title IN('Sr. Accountant', 'Accountant I') THEN 'Finance & Accounting'
				WHEN title IN('Administrative Assistant', 'Shared Services Manager') THEN 'Administration'
				WHEN title = 'President & CEO' THEN 'Executive'
				WHEN title IN('Director of Sales', 'Sales Manager', 'Area Sales Manager') THEN 'Sales'
				ELSE department
			END AS department,
			business_unit,
			payzone,
			CASE
				WHEN current_rating = 5 THEN 'Exceeds'
				WHEN current_rating = 4 THEN 'Fully Meets'
				WHEN current_rating = 3 THEN 'Needs Improvement'
				ELSE 'Performance Improvement Plan'
			END AS performance_score,
			current_rating
		FROM bronze.Employees;

		-- Engagement Survey Table
		PRINT '>> Inserting Data Into: silver.EngagementSurvey';
		INSERT INTO silver.EngagementSurvey (
			employee_id,
			survey_date,
			satisfaction_score,
			engagement_score,
			work_life_balance_score,
			overall_avg_score
		)
		SELECT
			es.employee_id,
			CONVERT(DATE, es.survey_date, 105),
			es.satisfaction_score,
			es.engagement_score,
			es.work_life_balance_score,
			ROUND((es.satisfaction_score + es.engagement_score + es.work_life_balance_score) * 1.0 / 3, 2)
		FROM bronze.EngagementSurvey es
		JOIN bronze.Employees e ON es.employee_id = e.employee_id
		WHERE e.start_date < CONVERT(DATE, es.survey_date, 105)
		  AND (e.exit_date IS NULL OR e.exit_date > CONVERT(DATE, es.survey_date, 105))
		  AND CONVERT(DATE, es.survey_date, 105) <= '2023-08-05';

		-- Training and Development Table
		PRINT '>> Inserting Data Into: silver.TrainingandDevelopment';
		INSERT INTO silver.TrainingandDevelopment (
			employee_id,
			training_date,
			training_name,
			training_type,
			outcome,
			training_location,
			trainer,
			duration_days,
			cost
		)
		SELECT
			td.employee_id,
			td.training_date,
			td.training_name,
			td.training_type,
			CASE
				WHEN td.outcome = 'Completed' THEN 'Passed'
				WHEN td.outcome = 'Incomplete' THEN 'Failed'
				ELSE td.outcome
			END,
			td.training_location,
			td.trainer,
			td.duration_days,
			td.cost
		FROM bronze.TrainingandDevelopment td
		JOIN bronze.Employees e ON td.employee_id = e.employee_id
		WHERE e.start_date <= td.training_date
		  AND (e.exit_date IS NULL OR e.exit_date > td.training_date)
		  AND td.training_date <= '2023-08-05';

		PRINT '================================================';
		PRINT 'Silver Layer Load Completed Successfully';
		PRINT '================================================';
	END TRY
	BEGIN CATCH
		PRINT '================================================';
		PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================';
	END CATCH
END;
GO

-- Execute the procedure
EXEC silver.load_silver;
