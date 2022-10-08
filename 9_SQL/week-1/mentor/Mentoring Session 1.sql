-------------------------------------------- Mentoring Session 1 -------------------------------------------------
-- Using HR Employees dataset to answer the following questions:


## Question 1 
-- Create a HR Employees database. 

CREATE DATABASE HR_EMP;

use hr_emp;

## Question 2 
-- Write a query to view a structure of the table.

describe employees;


## Question 3
-- Display the details of all employees working in the company.

select * 
from employees;


## Question 4
-- Display employee id , first name, last name and hiring date of employees, who work in department no 38.

select employee_id, first_name, last_name, hire_date 
from employees 
where department_id = 38;


## Question 5
-- Retrieve the phone number, job id and salary of the employee whose name is 'Gopi Kumar'.

select phone_number,job_id, salary 
from employees 
where first_name = "Gopi" 
and last_name = "Kumar";



## Question 6
-- Retrieve all the distinct salary values from the dataset.

select distinct (salary) 
from employees;



## Question 7
-- Fetch employees who were hired before 1991 February 4th.

select * 
from employees
where (hire_date < '1991-02-04');



## Question 8
-- Write a SQL query to print details of the employees who joined the company in January 1983.(Order by hire date)

select * 
from employees 
where hire_date 
between '1983-01-01' 
and '1983-01-31'
order by hire_date;



## Question 9
-- Write a query to fetch employee details from department 77 and department 99.

select * 
from employees 
where department_id
in (77,99);



## Question 10
--  Write a query to fetch the details of the employees whose salary is in the range of 8000 to 9000.
 
 select * 
 from employees 
 where salary >= 8000
 and salary <= 9000;
 
 

 ## Question 11
 --  Write a SQL query to fetch the details of top 5 employees who earn the highest salary in the company.

select * 
from employees 
order by salary desc
limit 5;



## Question 12
-- Write a SQL query to print details of the employees whose first name starts with 'a' and contains only 4 alphabets.

select * 
from employees
where length(first_name) = 4
and first_name
like 'a___';



## Question 13
-- Write a SQL query to print details of the employees whose first_name ends with 'h' and contains only 6 alphabets. 

select * 
from employees
where first_name 
like '%h' 
and length(first_name) = 6;



## Question 14
-- Retrieve all the distinct salary values from dataset

select distinct salary 
from employees;


select * from employees;

## Question 15
-- Write a SQL query to print the first name from employees table after removing white spaces from the right side.

select RTRIM(first_name) as Name
from employees;



## Question 16
-- Write a SQL query to print the first name from employees table after replacing ‘a’ with ‘A’.

select replace(first_name,'a','A') as first_name
from employees;


## Question 17 
-- Write a SQL query to fetch, if there are any duplicate records in the table.

select first_name, last_name, department_id, count(*) 
as cnt
from employees
group by first_name, last_name, department_id
having count(*) > 1;


## Question 18 
-- Select the names of employees whose salary is greater than the average salary of all employees in department 42.


select first_name, last_name
from employees
where department_id = 42
group by salary
having salary > avg(salary);


## Question 19 
-- Write a sql query to fetch the details of an employee
-- Generate another as commission percentage column. And wherever there are null values in this column, convert it to 0.

select employee_id, first_name, salary, commission_pct,
coalesce(commission_pct,0)
from employees;


## Question 20
-- Find out how many employees are in department 99.

select count('first_name') 
as Number_of_Employees 
from `employees` 
where `department_id` = 99;


## Question 21
-- Write a query to get the number of employees with the same job.

select department_id, COUNT(*) as Number_of_Employees
from employees
group by department_id;


## Question 22
-- Write a query to get the difference between the highest and lowest salaries.

SELECT MAX(salary) - MIN(salary) DIFFERENCE
FROM employees;


## Question 23 
-- Write a query to get the department ID and the total salary payable in each department.

select department_id, SUM(salary)
from employees 
group by department_id;


## Question 24
-- Write a query to find the manager ID and the first name, last name and salary of the lowest-paid employee for that manager.

SELECT manager_id, first_name, last_name, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY MIN(salary) DESC;



## Question 25
-- Write a query to find the details of employees, who got hired very early and got commission percentage.

SELECT first_name, last_name, salary,commission_pct, min(hire_date)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY hire_date
ORDER BY MIN(hire_date) asc;



## Question 26
-- Write a query to get the job_id and related employee's id.

select job_id, GROUP_CONCAT(employee_id, ' ') as 'Employees ID' 
from employees 
group by job_id;




































