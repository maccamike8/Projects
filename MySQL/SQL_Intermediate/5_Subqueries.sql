-- Sub Queries

-- Subqueries in a Where Statement

select *
from employee_demographics
where  employee_id in
	(select employee_id
    from employee_salary
    where dept_id = 1)
 ;

-- Subqueries in a Select Statement

select first_name, last_name, salary, 
(select avg(salary)
from employee_salary) as Average_Salary
from employee_salary
;

-- Subqueries in the From statement

select *
from
(select gender, avg(age), min(age), max(age), count(age) 
from employee_demographics
group by gender) as Agg_Table
;

-- Further refined

select gender, avg(`max(age`)
from
(select gender, avg(age), min(age), max(age), count(age) 
from employee_demographics
group by gender) as Agg_Table
group by gender
;

--  Still Further Refined

select avg(Max_Age) as Avg_Max_Age
from
(select gender, avg(age) as Avg_Age, min(age) as Min_Age, max(age) as Max_Age, count(age) 
from employee_demographics
group by gender) as Agg_Table
;


