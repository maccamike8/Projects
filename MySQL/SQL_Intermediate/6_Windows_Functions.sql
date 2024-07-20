-- Windows Functions

-- Query using a select, join, and Group by

Select gender, avg(salary) as Avg_Salary
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
group by gender
;

--  Same query using the Windows Function

Select dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
;

Select dem.first_name, 
dem.last_name, gender, 
sum(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
;

-- Looking at a rolling total of Salaries

Select dem.first_name, 
dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.employee_id) as Rolling_total
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
;

-- Row Numbering


Select dem.employee_id, dem.first_name, 
dem.last_name, gender, salary,
row_number() over()
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
;

-- Same query but partitioning by gender and ranking salaries

Select dem.employee_id, dem.first_name, 
dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc)
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
;

-- Ranking

Select dem.employee_id, dem.first_name, 
dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) as Row_Numbers,
rank() over(partition by gender order by salary desc) as Rank_Number,
dense_rank() over(partition by gender order by salary desc) as Dense_Rank_Number
from employee_demographics dem
join employee_salary sal 
	on
		dem.employee_id = sal.employee_id
;


