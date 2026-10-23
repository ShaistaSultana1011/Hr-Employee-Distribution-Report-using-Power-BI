use projects;

select * from hr;

Alter table hr
change column ï»¿id emp_id varchar(20) null;

describe hr;
       
select birthdate from hr;

set sql_safe_updates=0;

 
update hr 
set hire_date= case
   when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
   when hire_date like '%-%'then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
   else null
end;

alter table hr
modify column hire_date date;

select hire_date from hr;


UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT * from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

Alter table hr
add column age int;

update hr
set age=timestampdiff(year,birthdate,curdate());

select birthdate,age
from hr;

select min(age) as youngest,
max(age) as oldest
from hr;
       
       
select count(*) from hr
where age <18;


SELECT COUNT(*) FROM hr WHERE termdate > CURDATE();

SELECT COUNT(*)
FROM hr
WHERE termdate = '0000-00-00';

SELECT location FROM hr;

-- Questions

-- 1.What is the gender breakdown of employees in the company?
select gender,count(*) as count
from hr
where age<18 and termdate='0000-00-00'
group by gender;

-- 2.what is the race/ethnicity breakdown of employees in the company?
select race,count(*) as count
from hr
where age<18 and termdate='0000-00-00'
group by race
order by count(*) desc;

-- 3.What is the age distribution of employees in the company?
select min(age) as youngest,
max(age) as oldest
from hr
where age>=18 and termdate='0000-00-00';

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group,gender,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group,gender
ORDER BY age_group,gender;

-- 4.How many employees work at headquarters versus remote locations?
select location,count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by location;

-- 5.What is the average lentgh of employment for employees who have been terminated?
select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employment
from hr
where termdate <=curdate() and termdate<>'0000-00-00' and age>=18;

-- 6.How does gender distribution vary across departments and job titles?
select department,gender,count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by department,gender
order by department;

-- 7.What is the distribution of job titles across the company?
select jobtitle,count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by jobtitle
order by jobtitle desc;

-- 8.Which department has the highest turnover rate?
SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

-- 9.What is the distribution of employees across locations and state?
select location_state,count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by location_state
order by count desc;

-- 10.How has the company's employee count changed over time based on hire and term dates?
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
    
-- 11.What is the tenure distribution for each department?
select department,round(avg(datediff(termdate,hire_date)/365),0) avg_tenure
from hr
where termdate<=curdate() and termdate <>'0000-00-00' and age>=18
group by department;

