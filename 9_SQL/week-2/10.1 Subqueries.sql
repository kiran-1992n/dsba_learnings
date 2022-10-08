USE hr_emp;

-- Single row subquery

-- Fetch all employees in 'Human Resources' dept.
select * from employees
where department_id = (
select department_id from departments
where department_name='Human Resources');



-- Multiple  row subquery

-- Fetch all employees in 'Finance','Executive' dept.
select * from employees
where department_id in (
select department_id from departments
where department_name in('Finance','Executive'));


select * from employees
where salary> (select avg(salary) from employees);

-- correlated subquery 
select * from employees eo
where exists  (select avg(salary) from employees ei
where ei.department_id = eo.department_id);


-- Nested subquery

select * from employees where department_id in(
select department_id from departments where location_id in (
select location_id from locations  where city='panaji'));


----------------------------------------------------------------------------

-- correlated subquery 

-- Here we get all employees whose salary is greater than overall average salary.
select * from employees where salary > ( 
select avg(salary) from employees);

-- Here we get all employees whose salary is greater than average salary of their department.
select * from employees eo
where salary >  (select avg(salary) from employees ei
where ei.department_id = eo.department_id);

----------------------------------------------------------------------------

-- Sub queries with Exists and not EXISTS

-- while using sub queries we can't use 'in' and 'not in' so we use Exists and not EXISTS

-- List all departments in which employees are present.
select * from departments d where EXISTS
(select department_id from employees e
where e.department_id = d.department_id);

-- List all departments in which employees are not present.
select * from departments d where not EXISTS
(select department_id from employees e
where e.department_id = d.department_id);

----------------------------------------------------------------------------

-- Sub Queries with aggregate functions

select department_id, avg(salary) from employees
group by department_id
having avg(salary) > = (select avg(salary) from employees where department_id = 70);

----------------------------------------------------------------------------

-- Sub Queries with joins

select e.*, d.department_name from employees e
inner join departments d on e.department_id = d.department_id
where e.department_id in ( select department_id from departments
where department_name = 'Human Resources');