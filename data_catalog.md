# Data Catalog for Gold Layer

## Overview

The HR Data Layer represents consolidated and well-structured employee-related information, designed specifically to support workforce analysis and reporting, including employee records, engagement survey results, and training activity details.

---

### gold.Employees

**Purpose:** Stores core demographic, personal, and employment details for all employees in the organization.

**Columns:**

| Column Name                      | Data Type | Description |
|----------------------------------|-------------|-------------|
| employee_id                      | int         | Unique identifier for each employee in the organization. |
| first_name                       | nvarchar    | The first name of the employee. |
| last_name                        | nvarchar    | The last name of the employee. |
| email                            | nvarchar    | The email address associated with the employee’s communication within the organization. |
| birthdate                        | date        | The date of birth of the employee. |
| age                              | int         | The age of the employee. |
| gender                           | nvarchar    | The gender of the employee. |
| race                             | nvarchar    | The racial or ethnic background of the employee. |
| marital_status                   | nvarchar    | The marital status of the employee (e.g., Single, Married, Divorced). |
| state                            | nvarchar    | The state or region where the employee is located. |
| location_code                    | nvarchar    | The code representing the physical location or office where the employee is based. |
| start_date                       | date        | The date when the employee started working for the organization. |
| exit_date                        | date        | The date when the employee left the organization (if applicable). |
| employee_status                  | nvarchar    | The current employment status (e.g., Active, Retired, Involuntarily Terminated, Voluntarily Terminated). |
| employment_type                  | nvarchar    | The type of employment (e.g., Full-time, Part-time, Contract). |
| employee_classification_type     | nvarchar    | The classification type of the employee (e.g., Full-time, Part-time, Temporary). |
| termination_type                 | nvarchar    | The type of termination if the employee has left the organization (e.g., Resignation, Retirement). |
| title                            | nvarchar    | The job title or position of the employee within the organization. |
| department                       | nvarchar    | The broader category or type of department the employee’s work is associated with. |
| payzone                          | nvarchar    | The pay zone or salary band to which the employee’s compensation falls. |
| performance_score                | nvarchar    | A score indicating the employee’s performance level (e.g., Exceeds, Fully Meets, Needs Improvement). |
| current_rating                   | int         | The current rating or evaluation of the employee’s overall performance. |

---

### gold.EngagementSurvey

**Purpose:** Records employee engagement survey results to measure workplace satisfaction, engagement, and work-life balance

**Columns:**

| Column Name               | Data Type | Description |
|---------------------------|-----------|-------------|
| employee_id               | int       | A unique identifier assigned to each employee who participated in the employee engagement survey. |
| survey_date               | date      | The date on which the engagement survey was administered to employees. |
| engagement_score          | int       | A numerical score representing the level of employee engagement based on survey responses. |
| satisfaction_score        | int       | A numerical score indicating employee satisfaction with various aspects of their job and workplace. |
| work_life_balance_score   | int       | A numerical score reflecting employee perceptions of the balance between work and personal life. |
| overall_avg_score         | float     | A numerical score calculated by averaging the engagement, satisfaction, and work-life balance scores. |

---

### gold.TrainingandDevelopment

**Purpose:** Tracks details of employee training programs, including type, duration, outcomes, and costs.

**Columns:**

| Column Name      | Data Type | Description |
|------------------|-----------|-------------|
| employee_id      | int       | A unique identifier for each employee who participated in the training program. |
| training_date    | date      | The date on which the training session took place. |
| training_name    | nvarchar  | The name or title of the training program attended by the employee. |
| training_type    | nvarchar  | The categorization of the training, indicating its purpose or focus (e.g., Technical, Soft Skills, Safety). |
| outcome          | nvarchar  | The observed outcome or result of the training for the employee (e.g., Completed, Partial Completion, Not Completed). |
| duration_days    | int       | The duration of the training program in days. |
| cost             | float     | The cost associated with organizing and conducting the training program. |
