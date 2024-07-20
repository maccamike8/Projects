-- Stored Procedures

select *
from employee_salary
where salary >= 50000;

create procedure Large_Salaries()
select *
from employee_salary
where salary >= 50000;

CALL Large_Salaries();


DELIMITER $$
CREATE PROCEDURE Large_Salaries2()
BEGIN
	select *
	from employee_salary
	where salary >= 50000;
	select *
	from employee_salary
	where salary >= 10000;
END $$
DELIMITER ;

call Large_Salaries2();

-- using the inbuilt Create Stored Procedure from Left Menu

call new_procedure();

-- Importing Prameters into the stored procedure



call Large_Salaries3(1)