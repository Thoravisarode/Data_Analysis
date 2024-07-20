create database PwC;
use PwC;

-- Cards
-- 1. Total Employees
select count(`Employee ID`) as "Total Employees"
from `03 diversity-inclusion-dataset`;

-- 2. Total Female 
select count(`Employee ID`) as "Female Employees"
 from `03 diversity-inclusion-dataset` 
where Gender = "Female";

-- 3. Total Male 
select count(`Employee ID`) as "male Employees"
 from `03 diversity-inclusion-dataset` 
where Gender = "male";

-- 4. Avg age
select round(avg(`Age @01.07.2020`),0) as "Average Age"
from `03 diversity-inclusion-dataset`;

-- 5. Female Turnover 
SELECT 
    Gender,
    `In base group for Promotion FY21`,
    COUNT(`Employee ID`) AS Employee,
    CONCAT(ROUND((COUNT(if(Gender = "Female",1,0)) 
    /
	(SELECT COUNT(`Employee ID`) FROM `03 diversity-inclusion-dataset`
	WHERE `In base group for Promotion FY21` = 'Yes')) * 100,2),'%'
) AS "Female Turnover"
FROM 
    `03 diversity-inclusion-dataset`
where
     Gender="Female" and `In base group for Promotion FY21`="Yes"
GROUP BY 
    Gender, `In base group for Promotion FY21`;

-- 6. male Turnover 
SELECT 
    Gender,
    `In base group for Promotion FY21`,
    COUNT(`Employee ID`) AS Employee,
    CONCAT(ROUND((COUNT(if(Gender = "male",1,0)) 
    /
	(SELECT COUNT(`Employee ID`) FROM `03 diversity-inclusion-dataset`
	WHERE `In base group for Promotion FY21` = 'Yes')) * 100,2),'%'
) AS "male Turnover"
FROM 
    `03 diversity-inclusion-dataset`
where
     Gender="male" and `In base group for Promotion FY21`="Yes"
GROUP BY 
    Gender, `In base group for Promotion FY21`;
    
-- 7. % Female Promotion
select Gender, count(case when `Promotion in FY20?`="Y" then `Employee ID` end) as Employees_20,
count(case when `Promotion in FY21?`="Yes" then `Employee ID` end) as Employees_21,
concat(round(count(case when `Promotion in FY20?`="Y" then `Employee ID` end)
/
(select count(`Employee ID`) from `03 diversity-inclusion-dataset`)*100,2),"%") as "% Employees 20",
concat(round(count(case when `Promotion in FY21?`="Yes" then `Employee ID` end)
/
(select count(`Employee ID`) from `03 diversity-inclusion-dataset`)*100,2),"%") as "% Employees 21"
from `03 diversity-inclusion-dataset`
where Gender = "Female"
group by Gender;
    

-- 8. % Male Promotion
select Gender,count(case when `Promotion in FY20?`="Y" then `Employee ID` End),
count(case when `Promotion in FY21?`="Yes" then `Employee ID` End),
concat(round(count(case when `Promotion in FY20?`="Y" then `Employee ID` End)
/
(select count(`Employee ID`) from `03 diversity-inclusion-dataset`)*100,2),"%") as "% Employees 20",
concat(round(count(case when `Promotion in FY21?`="Yes" then `Employee ID` End)
/
(select count(`Employee ID`) from `03 diversity-inclusion-dataset`)*100,2),"%") as "% Employees 21"
from `03 diversity-inclusion-dataset`
where Gender = "Male"
group by Gender
;





-- KPI's 
-- 1. Age group wise employees
select `Age group`,Gender,count(`Employee ID`) as Employees 
from `03 diversity-inclusion-dataset`
group by Gender,`Age group`
order by count(`Employee ID`) desc;

-- 2. Department wise age 
select 
`Age group`,`Department @01.07.2020`,count(`Employee ID`) as Employee,
concat(round(count(`Employee ID`)
/
(select count(`Employee ID`)
from `03 diversity-inclusion-dataset` as d2	
where d2.`Department @01.07.2020` = d1.`Department @01.07.2020`)*100,2),"%") as "% Employees"
from `03 diversity-inclusion-dataset` as d1
group by `Age group`,`Department @01.07.2020`
order by `Age group`, Employee desc;


-- 3. Promotion for year 20 & 21
-- 3.1. Department wise Promotion
select `Department @01.07.2020`,Gender, 
count(case when`Promotion in FY20?`="Y" then `Employee ID` end) as Employees_20,
count(case when`Promotion in FY21?`="Yes" then `Employee ID` end) as Employees_21
from `03 diversity-inclusion-dataset`
group by `Department @01.07.2020`,Gender
order by Employees_20 and Employees_21 desc;

-- 3.2. Job level wise Promotion
select `Job Level after FY20 promotions`,`Job Level after FY21 promotions`, Gender, 
count(case when`Promotion in FY20?`="Y" then `Employee ID` end) as Employees_20,
count(case when`Promotion in FY21?`="Yes" then `Employee ID` end) as Employees_21
from `03 diversity-inclusion-dataset`
group by Gender,`Job Level after FY20 promotions`,`Job Level after FY21 promotions`
order by `Job Level after FY20 promotions`,`Job Level after FY21 promotions`;

-- 3.3. Gender wise Promotion
select Gender, count(case when`Promotion in FY20?`="Y" then `Employee ID` end) as Employees_20,
count(case when`Promotion in FY21?`="Yes" then `Employee ID` end) as Employees_21
from `03 diversity-inclusion-dataset`
group by Gender;

-- 4. Turnover KPI
-- 4.1. Year 20
select gender,`Job Level after FY20 promotions`,
count(case when `In base group for turnover FY20` = "Y" then `Employee ID` end) as Turnover
from `03 diversity-inclusion-dataset`
group by `Job Level after FY20 promotions`,Gender
order by Gender;	

