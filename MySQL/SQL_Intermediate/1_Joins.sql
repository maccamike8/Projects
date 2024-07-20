-- Joins

select *
from employee_demographics;

select *
from employee_salary;

select *
from employee_demographics
inner join employee_salary
	on employee_demographics.employee_id = employee_salary.employee_id
;

select demo.employee_id, age, occupation
from employee_demographics demo
inner join employee_salary sal
	on demo.employee_id = sal.employee_id
;

--  OUTER JOINS
select *
from employee_demographics demo
LEFT OUTER join employee_salary sal
	on demo.employee_id = sal.employee_id
;

select *
from employee_demographics demo
LEFT OUTER join employee_salary sal
	on demo.employee_id = sal.employee_id
;

select *
from employee_demographics demo
RIGHT OUTER JOIN employee_salary sal
	on demo.employee_id = sal.employee_id
;

-- SELF JOIN

SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id = emp2.employee_id
;

-- A good secret Santa idea

SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- Joining Multiple Tables together

select *
from employee_demographics demo
inner join employee_salary sal
	on demo.employee_id = sal.employee_id
inner join parks_departments pd
	on sal.dept_id = pd.department_id
;

select *
from parks_departments;


