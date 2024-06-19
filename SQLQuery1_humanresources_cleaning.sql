
select * from  HR_Data..[Human Resources]

-- Rename the column
EXEC sp_rename 'HR_Data..[Human Resources].ID', 'emp_id', 'COLUMN';

-- Change the column type
ALTER TABLE HR_Data..[Human Resources] 
ALTER COLUMN emp_id VARCHAR(20) NULL;

select birthdate from HR_Data..[Human Resources]

select termdate from HR_Data..[Human Resources]

select hire_date from HR_Data..[Human Resources]

UPDATE HR_Data..[Human Resources]
SET termdate = CONVERT(VARCHAR(10), REPLACE(termdate, ' UTC', ''), 120)
WHERE termdate IS NOT NULL AND termdate != ' ';

ALTER TABLE HR_Data..[Human Resources]
ALTER COLUMN termdate DATE;

-- Update the hire_date column to ensure all dates are in 'YYYY-MM-DD' format
UPDATE HR_Data..[Human Resources]
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN CONVERT(VARCHAR(10), CAST(hire_date AS DATE), 120)
    WHEN hire_date LIKE '%-%' THEN CONVERT(VARCHAR(10), CAST(hire_date AS DATE), 120)
    ELSE hire_date
END;

-- Modify the column type to DATE
ALTER TABLE HR_Data..[Human Resources]
ALTER COLUMN hire_date DATE;

-- Add the age column
ALTER TABLE HR_Data..[Human Resources] ADD age INT;

-- Update the age column
UPDATE HR_Data..[Human Resources]
SET age = DATEDIFF(YEAR, birthdate, GETDATE());

select age from HR_Data..[Human Resources]


--make sure there is no invalid data [age <18] in age column 
SELECT count(*) FROM HR_Data..[Human Resources] WHERE age < 18;

-- Select count of records where termdate is greater than the current date
SELECT COUNT(*) as greater_than_currentDATE
FROM HR_Data..[Human Resources]
WHERE termdate > CAST(GETDATE() AS DATE);

-- Count rows where termdate is NULL
SELECT COUNT(*)
FROM HR_Data..[Human Resources]
WHERE termdate IS NULL;

-- Alter the column type to VARCHAR
ALTER TABLE HR_Data..[Human Resources]
ALTER COLUMN termdate VARCHAR(10);

-- Update NULL values in termdate to '0000-00-00'
UPDATE HR_Data..[Human Resources]
SET termdate = '0000-00-00'
WHERE termdate IS NULL;

select termdate from HR_Data..[Human Resources]


