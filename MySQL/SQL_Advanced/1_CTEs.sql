-- CTE's

with CTE_Example as
(
Select gender, avg(salary) as Avg_Salary, max(salary) as Max_Salary, min(salary) as Min_Salary, Count(salary) as Count_Salary
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
group by gender
)
select *
from CTE_Example;

with CTE_Example as
(
Select gender, avg(salary) as Avg_Salary, max(salary) as Max_Salary, min(salary) as Min_Salary, Count(salary) as Count_Salary
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_Salary)
from CTE_Example;

-- More Complex CTE Queries creating 2 CTE's within a Single CTE

with CTE_Example as
(
Select employee_id, gender, birth_date
from employee_demographics
where birth_date > '1984-01-01'
),
CTE_Example2 as
(
select employee_id, salary
from employee_salary
where salary > 50000
)
select *
from CTE_Example
join CTE_Example2 on
	CTE_Example.employee_id = CTE_Example2.employee_id;
    
    
with CTE_Example (gender, Avg_Salary, Max_Salary, Min_Salary, Count_Salary) as
(
Select gender, avg(salary) as Avg_Salary, max(salary) as Max_Salary, min(salary) as Min_Salary, Count(salary) as Count_Salary
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
group by gender
)
select *
from CTE_Example
;


