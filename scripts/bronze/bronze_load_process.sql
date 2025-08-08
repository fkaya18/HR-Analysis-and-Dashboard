/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================
Purpose:
    Loads raw data into bronze tables from local CSV files using BULK INSERT.
    Each table is truncated before loading to ensure fresh data ingestion.
    Execution time is logged for each step, and errors are caught with detailed messages.

Usage:
    EXEC bronze.load_bronze;
===============================================================================
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.Employees';
		TRUNCATE TABLE bronze.Employees;
		PRINT '>> Inserting Data Into: bronze.Employees';
		BULK INSERT bronze.Employees
		FROM 'C:\Users\Furkan\data_analysis\hr_analysis\employee_data.csv'
		WITH(
			FIELDTERMINATOR = ',',
			FIRSTROW = 2,
			TABLOCK
			);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.EngagementSurvey';
		TRUNCATE TABLE bronze.EngagementSurvey;

		PRINT '>> Inserting Data Into: bronze.EngagementSurvey';
		BULK INSERT bronze.EngagementSurvey
		FROM 'C:\Users\Furkan\data_analysis\hr_analysis\employee_engagement_survey_data.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.TrainingandDevelopment';
		TRUNCATE TABLE bronze.TrainingandDevelopment;
		PRINT '>> Inserting Data Into: bronze.TrainingandDevelopment';
		BULK INSERT bronze.TrainingandDevelopment
		FROM 'C:\Users\Furkan\data_analysis\hr_analysis\training_and_development_data.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';		

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END;
GO

EXEC bronze.load_bronze;

