-- String Functions

select length('Skyfall');


select first_name, length(first_name)
from employee_demographics
order by 2
;

select upper(first_name)
from employee_demographics
;

select lower(last_name)
from employee_demographics
;

-- Trim eg Left Trim, Right Trim

select trim('               SkyFall               ');
select ltrim('               SkyFall               ');
select rtrim('               SkyFall               ');

-- LEFT, RIGHT

select (first_name),
   LEFT(first_name, 4) as First_4_Char,
   RIGHT(first_name, 4) as Last_4_Char
from employee_demographics
;

-- Substring

select first_name,
   LEFT(first_name, 4) as First_4_Char,
   RIGHT(first_name, 4) as Last_4_Char,
   substring(first_name, 2, 3) as Portion,
   birth_date,
   substring(birth_date, 6, 2) as Month
from employee_demographics
;

-- Replace

select last_name, replace(last_name, last_name, upper(last_name)) as Uppercase_Lastname
from employee_demographics;

-- Locate

select locate('x', 'Alexander');

select first_name, locate('An', first_name)
from employee_demographics
;

-- CONCAT

select first_name, last_name,
concat(first_name, '  ', last_name) as Full_Name
from employee_demographics
;











