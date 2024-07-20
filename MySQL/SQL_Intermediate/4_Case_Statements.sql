-- Case Statements

select first_name, 
last_name,
case
	when age <= 30 then 'Young'
    when age > 30 and age <= 50 then 'Middle Aged'
    when age > 50 then 'Old'
end as Label
from employee_demographics
order by label desc
;

-- Pay Increase and Bonus
-- if Salary <= 50000 then 5% increase
-- if Salary > 50000 then 7% increase
--  Finance Department then a bonus of 10%

select first_name, last_name, salary,
case
	when salary <= 50000 then salary + (salary * 0.05)
    when salary > 50000 then salary + (salary * 0.07)
end as New_Pay,
case
	when dept_id = '6' then salary * 0.10
end as bonus
from employee_salary;

