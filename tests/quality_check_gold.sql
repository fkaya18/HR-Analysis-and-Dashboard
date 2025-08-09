/*
===============================================================================
Gold Layer Quality Checks
===============================================================================
Script Purpose:
    This script performs final quality validation checks on the 'gold' layer 
    HR analytics model (gold.Employees, gold.EngagementSurvey, gold.TrainingandDevelopment). 
    It includes checks for:
    - Primary key uniqueness and completeness.
    - Duplicate record detection.
    - Referential integrity between fact-like and dimension-like tables.
    - Cross-table relationship validation for model connectivity.
Usage Notes:
    - Run these checks after gold layer creation and population.
    - Ensure no duplicates or missing keys exist before enabling reporting and analysis.
    - Confirms readiness of the HR analytics data model for business intelligence use.
===============================================================================
*/


USE Employeedb;
GO

-- ====================================================================
-- Checking 'gold.Employees'
-- ====================================================================
SELECT *
FROM gold.Employees;


-- Duplicate Employee ID Check
-- Expected: No return (employee_id must be unique)
SELECT
	employee_id,
	COUNT(*) AS id_count
FROM gold.Employees
GROUP BY employee_id
HAVING COUNT(*) > 1;



-- ====================================================================
-- Checking 'gold.EngagementSurvey'
-- ====================================================================

SELECT *
FROM gold.EngagementSurvey;


-- Duplicate record check
-- Expected: There should be only 1 record for employee_id
SELECT
	employee_id,
	COUNT(*) AS id_count
FROM gold.EngagementSurvey
GROUP BY employee_id
HAVING COUNT(*) > 1;



-- ====================================================================
-- Checking 'gold.TrainingandDevelopment'
-- ====================================================================


SELECT *
FROM gold.TrainingandDevelopment;


-- Duplicate record check
-- Expected: No returns
SELECT
	employee_id,
	COUNT(*) AS id_count
FROM gold.TrainingandDevelopment
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- Check the data model connectivity between tables
SELECT *
FROM gold.Employees e
LEFT JOIN gold.EngagementSurvey es
ON e.employee_id = es.employee_id
LEFT JOIN gold.TrainingandDevelopment t
ON e.employee_id = t.employee_id
ORDER BY e.employee_id;
