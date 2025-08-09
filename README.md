# HR-Analysis-and-Dashboard

## Project Overview

This project implements a comprehensive HR Analytics data pipeline using SQL Server, following a medallion architecture (Bronze → Silver → Gold) to transform raw HR data into analysis-ready datasets. The pipeline processes employee information, engagement surveys, and training data through multiple layers of validation and transformation.

To reach out raw datasets used in this project please click [here](data/raw/)

## Project Architecture

### Medallion Architecture Layers

##### Bronze Layer (Raw Data)

* Raw data ingestion from CSV files

* Minimal processing, preserving original data structure

* Serves as the source of truth for all transformations

The SQL definitions for creating Bronze layer tables are available in [here](scripts/bronze/ddl_bronze.sql)

SQL queries for loading raw source data into the Bronze layer can be found in [here](scripts/bronze/bronze_load_process.sql)

##### Silver Layer (Cleaned & Transformed)

* Data cleaning and standardization

* Type conversions and business rule applications

* Calculated fields and data quality improvements
  
* Filtered datasets based on business logic

The SQL definitions for creating Silver layer tables can be found in [here](scripts/silver/ddl_silver.sql)

The transformation logic that refines Bronze data into the Silver layer is outlined in [here](scripts/silver/silver_load_process.sql)
  
##### Gold Layer (Analytics-Ready)

* Business-ready views for reporting and analytics

* Standardized schema for downstream consumption

* Optimized for dashboard and BI tool integration

The SQL definitions for creating Gold layer analytics-ready views are available in [here](scripts/ddl_gold.sql)

## Data Model Structure

![Data Model Structure](docs/data_model.png)

The HR Analytics data model follows an employee-centric design with:

* **Employees:** Central employee table containing comprehensive employee information including personal details, employment status, organizational hierarchy, and performance metrics

* **EngagementSurvey:** Employee engagement data capturing survey responses and satisfaction metrics

* **TrainingandDevelopment:** Training participation records with outcomes, costs, and program details

Key relationships:

Each engagement survey record in **EngagementSurvey** references an employee through `employee_id`

Each training record in **TrainingandDevelopment** references an employee through `employee_id`

The Employees table serves as the central hub, enabling analysis of employee engagement and development patterns

Composite primary keys in EngagementSurvey (`employee_id`, `survey_date`) and TrainingandDevelopment (`employee_id`, `training_date`, `training_name`) support multiple records per employee over time

You can find detailed information about the tables and their contents [here](docs/data_catalog.md).

## Data Quality and Validation

Comprehensive data quality checks are implemented across both silver and gold layers to ensure data integrity and business rule compliance. The validation framework includes primary key uniqueness verification, referential integrity checks between employee and related records, cross-field consistency validation (age calculation, employment date logic), business rule enforcement (email format, performance score alignment, employment status consistency), and temporal validation ensuring survey and training dates fall within employment periods. These quality assurance measures guarantee high data accuracy and reliability throughout the pipeline for trustworthy HR analytics.

The data quality and integrity checks for the Silver layer are implemented in [here](test/quality_check_silver.sql)

The final data quality and integrity checks for the Gold layer are implemented in [here](test/quality_check_gold.sql)

