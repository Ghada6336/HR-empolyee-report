-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
select gender , count(*) as "count of gender"  from HR_Data..[Human Resources]
where age>=18 and termdate='0000-00-00'
group by gender 

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race , count(*) as "count of race/ethnicity"  from HR_Data..[Human Resources]
where age>=18 and termdate='0000-00-00'
group by race
order by count(*) DESC 

-- 3. What is the age distribution of employees in the company?
SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM HR_Data..[Human Resources]
where age>=18 and termdate='0000-00-00'

SELECT CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 60 THEN '55-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS "count age range"
FROM HR_Data..[Human Resources]
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 60 THEN '55-60'
        ELSE '60+'
    END
ORDER BY age_group;


-- 4. How many employees work at headquarters versus remote locations?
select location , count(*) as "count of location" from HR_Data..[Human Resources]
WHERE age >= 18 AND termdate = '0000-00-00'
group by location


-- 5. What is the average length of employment for employees who have been terminated?
-- not accurate 
SELECT AVG(DATEDIFF(day, hire_date, termdate))/365.0 AS avg_length_employment
FROM HR_Data..[Human Resources]
WHERE termdate != '0000-00-00'; 

-- 6. How does the gender distribution vary across departments and job titles?
select department,gender , count(*) as "count for each gender and department" 
from HR_Data..[Human Resources]
WHERE age >= 18 AND termdate = '0000-00-00'
group by department, gender
order by department

-- 7. What is the distribution of job titles across the company?
select jobtitle , count(*) as "count for each jobtitle" 
from HR_Data..[Human Resources]
WHERE age >= 18 AND termdate = '0000-00-00'
group by jobtitle
order by count(*) DESC

-- 8. Which department has the highest turnover rate?

select department , 
total_count,
terminated_count,
(cast(terminated_count as float) / cast(total_count as float)) as termination_rate  
from (
select department,
count(*) as total_count,
sum(case when termdate != '0000-00-00' and termdate <= GETDATE() then 1 else 0 end )as terminated_count
from HR_Data..[Human Resources]
WHERE age >= 18 
GROUP BY department
) as subquery 
order by  termination_rate desc

-- 9. What is the distribution of employees across locations by city and state?
--by state
select location_state , count(*) as "count for location by state" 
from HR_Data..[Human Resources]
WHERE age >= 18 AND termdate = '0000-00-00'
group by location_state
order by count(*) Desc

--by city
select location_city , count(*) as "count for location by city" 
from HR_Data..[Human Resources]
WHERE age >= 18 AND termdate = '0000-00-00'
group by location_city
order by count(*) Desc

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year, hires, terminations, 
       ROUND((CAST(hires - terminations AS FLOAT) / CAST(hires AS FLOAT)) * 100, 2) AS net_change_percent
FROM (
    SELECT YEAR(hire_date) AS year,
           COUNT(*) AS hires,
           SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS terminations
    FROM HR_Data..[Human Resources]
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;


-- 11. What is the tenure distribution for each department?
select department, avg(DATEDIFF(day,hire_date, termdate)/365) as "average tenure"
from HR_Data..[Human Resources]
WHERE age >= 18 AND termdate != '0000-00-00'
group by department