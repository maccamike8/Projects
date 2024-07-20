-- Temp Tables

CREATE TEMPORARY TABLE Temp_Table
(first_name varchar(50),
last_name varchar(50),
favourite_movie varchar(100)
);

select *
from Temp_Table;

insert into Temp_Table 
values('Michael', 'McCauley', 'Heat');

DROP TABLE Temp_Table;

-- Another Way to Create a Temp Table from an existing table

select *
from employee_salary;

CREATE TEMPORARY TABLE Salary_over_50K
select *
from employee_salary
where salary >= 50000
;

select *
from Salary_over_50K;
