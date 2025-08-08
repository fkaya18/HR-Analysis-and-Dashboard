/*
===============================================================================
Silver Layer Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks on data in the 'silver' schema to ensure
    validity, integrity, and business rule compliance. It covers:
        - Primary key uniqueness
        - Null and format validations
        - Cross-field consistency (e.g. birthdate vs. age)
        - Business logic checks (e.g. employment status vs. exit date)
        - Referential integrity between tables

Usage Notes:
    - Run this script after transforming bronze data into silver tables.
    - Investigate any returned rows – these indicate potential data quality issues.
    - Should be executed before promoting data to the gold layer.
===============================================================================
*/


USE Employeedb;
GO


-- ====================================================================
-- Checking 'silver.Employees'
-- ====================================================================
SELECT *
FROM silver.Employees;


-- Duplicate Employee ID Check
-- Expected: No return (employee_id must be unique)
SELECT
	employee_id,
	COUNT(*) AS id_count
FROM silver.Employees
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- Email format check
-- Expected: Email field must be in the format first_name.last_name@bilearner.com
SELECT
	first_name,
	last_name,
	email,
	CONCAT(LOWER(first_name), '.', LOWER(last_name), '@bilearner.com') AS concated_mail
FROM silver.Employees
WHERE email <> CONCAT(LOWER(first_name), '.', LOWER(last_name), '@bilearner.com');


-- Birthdate format check (original data from bronze)
-- Expected: Should be in MM-DD-YYYY format
SELECT
	DISTINCT birthdate
FROM bronze.Employees
WHERE birthdate NOT LIKE '[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]';


-- Birth date range check
-- Expected: Must be within a reasonable birth date range (example: 1950–2005)
SELECT
	MIN(birthdate) AS earliest_birthdate,
	MAX(birthdate) AS latest_birthdate
FROM silver.Employees;


-- Age calculation consistency check
-- Expected: The value in the age column should match the age calculated from the date of birth.
SELECT
	age,
	DATEDIFF(YEAR, birthdate, GETDATE()) 
	- CASE
		WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate)  > GETDATE() THEN 1
		ELSE 0
	END AS age_calculated
FROM silver.Employees
WHERE age <> DATEDIFF(YEAR, birthdate, GETDATE()) 
				- CASE
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate)  > GETDATE() THEN 1
					ELSE 0
				END
;


-- Gender Values Check
-- Expected: Consistent and defined values (e.g., Male, Female, Other)
SELECT DISTINCT
	gender
FROM silver.Employees;


-- Race value check
-- Expected: There should be defined and proper categories
SELECT DISTINCT
	race
FROM silver.Employees;


-- Marital status check
-- Expected: Must contain valid definitions
SELECT DISTINCT
	marital_status
FROM silver.Employees;


-- State code check
-- Expected: Should contain consistent values, US state codes
SELECT DISTINCT
	state
FROM silver.Employees;


-- Location code length and number format check
-- Expected: Codes must be 4 or 5 digit numbers
SELECT 
	location_code
FROM silver.Employees
WHERE 
    (LEN(location_code) NOT IN (4, 5) OR TRY_CAST(location_code AS INT) IS NULL);


-- Check if the exit date is before the start date.
-- Expected: exit_date should be > start_date.
SELECT
	start_date,
	exit_date
FROM silver.Employees
WHERE exit_date < start_date;


-- Is the exit_date filled for active employees?
-- Expected: Exit_date should be NULL for active employees
SELECT *
FROM silver.Employees
WHERE employee_status = 'Active' AND exit_date IS NOT NULL


-- Is the exit_date missing for retirees?
-- Expected: Retired or terminated employees should have a full exit_date
SELECT *
FROM silver.Employees
WHERE employee_status IN('Retired', 'Involuntarily Terminated', 'Voluntarily Terminated') AND exit_date IS NULL


-- employee_status and termination_type relationship
-- Expected: Consistent matches
SELECT DISTINCT
	employee_status,
	termination_type
FROM silver.Employees
ORDER BY 1, 2;


-- Employment type vs. classification mismatch check
-- Expected: Consistent matches
SELECT
	employment_type,
	employee_classification_type
FROM silver.Employees
WHERE (employment_type = 'Part-Time' AND employee_classification_type = 'Full-Time') OR 
(employment_type = 'Full-Time' AND employee_classification_type = 'Part-Time');


-- Department and title matches
-- Expected: Consistent matches
SELECT DISTINCT
	department,
	title
FROM silver.Employees
ORDER BY 1,2;


-- Check business unit values
-- Expected: Consistent business unit definitions
SELECT DISTINCT
	business_unit
FROM silver.Employees
ORDER BY 1;


-- Performance score and evaluation score match check
-- Expected: There should be a correct match between the score and rating
SELECT DISTINCT
	performance_score,
	current_rating
FROM silver.Employees
ORDER BY 2;



-- ====================================================================
-- Checking 'silver.EngagementSurvey'
-- ====================================================================

SELECT *
FROM silver.EngagementSurvey;


-- Duplicate record check
-- Expected: There should be only 1 record for employee_id
SELECT
	employee_id,
	COUNT(*) AS id_count
FROM silver.EngagementSurvey
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- Survey date null check
-- Expected: survey_date should not be NULL
SELECT *
FROM silver.EngagementSurvey
WHERE survey_date IS NULL;


-- Are the survey dates between the employee's start and finish dates?
-- Expected: survey_date must be within this range
SELECT
	e.employee_id,
	e.start_date,
	e.exit_date,
	es.survey_date
FROM silver.Employees e
JOIN silver.EngagementSurvey es
ON e.employee_id = es.employee_id
WHERE e.start_date >= es.survey_date
OR e.exit_date <= es.survey_date;


-- Orphan record check (IDs not in the employee table)
-- Expected: No return (referential integrity)
SELECT
	employee_id
FROM silver.EngagementSurvey
WHERE employee_id NOT IN (SELECT employee_id FROM silver.Employees);


-- Employees who did not have survey
-- Expected: There may be employees who did not participate in the survey.
SELECT
	employee_id,
	start_date
FROM silver.Employees
WHERE employee_id NOT IN (SELECT employee_id FROM silver.EngagementSurvey)
ORDER BY 2;


-- Survey score value range check
-- Expected: Should be between 0–5
SELECT
	engagement_score,
	satisfaction_score,
	work_life_balance_score
FROM silver.EngagementSurvey
WHERE engagement_score > 5 OR engagement_score < 0
OR satisfaction_score > 5 OR satisfaction_score < 0
OR work_life_balance_score > 5 OR work_life_balance_score < 0;




-- ====================================================================
-- Checking 'silver.TrainingandDevelopment'
-- ====================================================================


SELECT *
FROM silver.TrainingandDevelopment;


-- Duplicate record check
-- Expected: No returns
SELECT
	employee_id,
	COUNT(*) AS id_count
FROM silver.TrainingandDevelopment
GROUP BY employee_id
HAVING COUNT(*) > 1


-- Is the training date before the employee starts work?
-- Expected: The training date should be after the start_date
SELECT
	e.employee_id,
	e.start_date,
	e.exit_date,
	t.training_date
FROM silver.Employees e
JOIN silver.TrainingandDevelopment t
ON e.employee_id = t.employee_id
WHERE e.start_date > t.training_date
OR e.exit_date <= t.training_date;


-- Check training names
-- Expected: One of the followings; Project Management, Customer Service, Communication Skills or Leadership Development
SELECT DISTINCT
	training_name
FROM silver.TrainingandDevelopment;


-- Control of training types
--Expected: Internal or External
SELECT DISTINCT
	training_type
FROM silver.TrainingandDevelopment;


-- Educational results control
--Expected: Passed or Failed
SELECT DISTINCT
	outcome
FROM silver.TrainingandDevelopment;


-- Controlling training time and cost
-- Expected: Both should be positive
SELECT
	duration_days,
	cost
FROM silver.TrainingandDevelopment
WHERE duration_days <= 0 OR cost < 0;