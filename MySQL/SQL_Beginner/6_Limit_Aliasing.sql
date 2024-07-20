--  Limit and Aliasing

select *
from employee_demographics
order by age desc
limit 3
;

select *
from employee_demographics
order by age desc
limit 2, 1
;

-- Aliasing

select gender, avg(age) as Average_Age
from employee_demographics
group by gender
having Average_Age > 40
;