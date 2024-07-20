-- WHERE CLAUSE

SELECT *
from employee_demographics
WHERE gender = "male"
;

SELECT *
from employee_salary
WHERE salary >= 50000
;

SELECT *
from employee_demographics
WHERE gender != "Female"
;

SELECT *
from employee_demographics
WHERE birth_date > "1980-03-25"
;

-- Logical Operators NOT, AND, OR


SELECT *
from employee_demographics
WHERE birth_date > "1980-03-25"
AND gender = 'Male'
;

SELECT 
    *
FROM
    employee_demographics
WHERE
    birth_date > '1980-03-25'
        OR NOT gender = 'Male'
;

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR AGE > 55
;

-- LIKE STATEMENT eg % and _

SELECT *
FROM employee_demographics
WHERE first_name LIKE '%a%'
;

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__'
;

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___%'
;