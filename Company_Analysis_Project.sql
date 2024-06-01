---1. Retrieve the first name and last name of all employees.

SELECT first_name, last_name
FROM CompanyProject.dbo.Employees$;


---2. Find the department numbers and names.

SELECT dep_no, dep_name
FROM CompanyProject.dbo.departments$;


---3. Get the total number of employees.

SELECT COUNT(emp_no) AS TotalEmployees
FROM CompanyProject.dbo.Employees$;


---4. Find the average salary of all employees.

SELECT AVG(salary) AS AverageSalary
FROM CompanyProject.dbo.salaries$;


---5. Retrieve the birth date and hire date of employee with emp_no 10003.

SELECT birth_date, hire_date
FROM CompanyProject.dbo.Employees$
WHERE emp_no = 10003;


---6. Find the titles of all Employees.

SELECT title
FROM CompanyProject.dbo.employee_titles$

--OR To find the titles of all employees, you can join the employee_titles table with the Employees table on the employee number (emp_no)
SELECT e.emp_no, e.first_name, e.last_name, et.title
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.employee_titles$ as et ON e.emp_no = et.emp_no;

---7. Get the total number of departments.
SELECT COUNT(dep_no) AS TotalDepartments
FROM CompanyProject.dbo.departments$;


---8. Retrieve the department number and name where employee with emp_no 10004 works.
--To retrieve the department number and name where the employee with emp_no 10004 works, you can join the dept_emp$ and departments$ tables 
--based on the department number (dep_no). 

SELECT d.dep_no, d.dep_name
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_emp$ as de 
ON d.dep_no = de.dept_no
WHERE de.emp_no = 10004;


---9. Find the gender of employee with emp_no 10007.
--To find the gender of the employee with emp_no 10007, you can directly query the Employees$ table based on the provided employee 

SELECT gender
FROM CompanyProject.dbo.Employees$
WHERE emp_no = 10007;


---10. Get the highest salary among all employees.
--To get the highest salary among all employees, you can use the MAX() function.

SELECT MAX(salary) AS HighestSalary
FROM CompanyProject.dbo.salaries$;


---11. Retrieve the names of all managers along with their department names.
--To retrieve the names of all managers along with their department names, you can join the Employees$, dept_manager$, and 
--departments$ tables based on the employee number (emp_no) and department number (dept_no). 

SELECT e.first_name, e.last_name, d.dep_name
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.dept_manager$ as dm ON e.emp_no = dm.emp_no
JOIN CompanyProject.dbo.departments$ d ON dm.dept_no = d.dep_no;


---12. Find the department with the highest number of employees.
--This query simply counts the number of employees in each department, orders the result by the count in descending order, 
--and selects only the first row (department) with the highest number of employees using TOP 1.
--'TOP' keyword in SQL is used to limit the number of rows returned by a query.
--'TOP 1' ensures that only the first row (department) with the highest number of employees is returned. 

SELECT TOP 1 d.dep_no, d.dep_name, COUNT(de.emp_no) AS NumberOfEmployees
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_emp$ as de ON d.dep_no = de.dept_no
GROUP BY d.dep_no, d.dep_name
ORDER BY COUNT(de.emp_no) DESC;


---13. Retrieve the employee number, first name, last name, and salary of employees earning more than $60,000.
--e is an alias for the Employees$ table.
--s is an alias for the salaries$ table.

SELECT e.emp_no, e.first_name, e.last_name, s.salary 
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.salaries$ as s ON e.emp_no = s.emp_no
WHERE s.salary > 60000;


---14. Get the average salary for each department.

SELECT d.dep_no, d.dep_name, AVG(s.salary) AS AverageSalary
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_emp$ as de ON d.dep_no = de.dept_no
JOIN CompanyProject.dbo.salaries$ as s ON de.emp_no = s.emp_no
GROUP BY d.dep_no, d.dep_name;


---15. Retrieve the employee number, first name, last name, and title of all employees who are currently managers.
--To retrieve the employee number, first name, last name, and title of all employees who are currently managers, 
--you can join the Employees$, dept_manager$, and employee_titles$ tables.
--This query retrieves the employee number (emp_no), first name, last name, and title from the Employees$ table for 
--employees who are currently managers. It joins the Employees$, dept_manager$, and employee_titles$ tables based on the 
--employee number (emp_no) and ensures to select only the current managers by filtering for to_date equals '9999-01-01'.

SELECT e.emp_no, e.first_name, e.last_name, et.title
FROM CompanyProject.dbo.Employees$ e
JOIN CompanyProject.dbo.dept_manager$ dm ON e.emp_no = dm.emp_no
JOIN CompanyProject.dbo.employee_titles$ et ON e.emp_no = et.emp_no
WHERE dm.to_date = '9999-01-01';


---16. Find the total number of employees in each department.
--This query joins the departments$ and dept_emp$ tables based on the department number (dep_no). 
--It counts the number of employees in each department using the COUNT() function and groups the result by 
--department number and name. The WHERE clause ensures only current employees are counted by checking for to_date equals '9999-01-01'.

SELECT d.dep_no, d.dep_name, COUNT(de.emp_no) AS NumberOfEmployees
FROM CompanyProject.dbo.departments$ d
JOIN CompanyProject.dbo.dept_emp$ de ON d.dep_no = de.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dep_no, d.dep_name;



---17. Retrieve the department number and name where the most recently hired employee works.
--To retrieve the department number and name where the most recently hired employee works, you need to find the employee with the 
--latest hire date and then determine the department they are currently assigned to.
--This query uses a Common Table Expression (CTE) named MostRecentHire to find the most recently hired employee. 
--It then joins the result with the dept_emp$ and departments$ tables to determine the department number and name where this employee currently works.
-- First, find the most recently hired employee

WITH MostRecentHire AS (
    SELECT TOP 1 emp_no, hire_date
    FROM CompanyProject.dbo.Employees$
    ORDER BY hire_date DESC
)

-- Then, find the department where this employee works
SELECT d.dep_no, d.dep_name
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_emp$ de ON d.dep_no = de.dept_no
JOIN MostRecentHire mrh ON de.emp_no = mrh.emp_no
WHERE de.to_date = '9999-01-01';


---18. Get the department number, name, and average salary for departments with more than 3 employees.
--To get the department number, name, and average salary for departments with more than 3 employees, 
--you can use a combination of the AVG() and HAVING clauses along with GROUP BY.
--This query:
--Joins the departments$ and dept_emp$ tables on the department number (dep_no).
--Joins the resulting table with the salaries$ table on the employee number (emp_no).
--Filters to include only current employees (where to_date is '9999-01-01').
--Groups the results by department number and name.
--Calculates the average salary for each department.
--Uses the HAVING clause to include only those departments with more than 3 employees. 


SELECT d.dep_no, d.dep_name, AVG(s.salary) AS AverageSalary
FROM CompanyProject.dbo.departments$ d
JOIN CompanyProject.dbo.dept_emp$ de ON d.dep_no = de.dept_no
JOIN CompanyProject.dbo.salaries$ s ON de.emp_no = s.emp_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dep_no, d.dep_name
HAVING COUNT(de.emp_no) > 3;


---19. Retrieve the employee number, first name, last name, and title of all employees hired in 2005.
--To retrieve the employee number, first name, last name, and title of all employees hired in 2005, 
--you can filter the Employees$ table based on the hire_date and join it with the employee_titles$ table to get the titles.

SELECT e.emp_no, e.first_name, e.last_name, et.title
FROM CompanyProject.dbo.Employees$ e
JOIN CompanyProject.dbo.employee_titles$ et ON e.emp_no = et.emp_no
WHERE YEAR(e.hire_date) = 2005;


---20. Find the department with the highest average salary.
--To find the department with the highest average salary, you need to calculate the average salary for each department 
--and then select the department with the highest average. 
--In this query:
--The WITH clause (CTE) named DepartmentAverageSalaries calculates the average salary for each department by joining the departments$, 
--dept_emp$, and salaries$ tables.
--The main query selects the department with the highest average salary by ordering the results in descending order of AverageSalary and 
--using TOP 1 to get the highest value.

-- Calculate the average salary for each department
WITH DepartmentAverageSalaries AS (
    SELECT d.dep_no, d.dep_name, AVG(s.salary) AS AverageSalary
    FROM CompanyProject.dbo.departments$ d
    JOIN CompanyProject.dbo.dept_emp$ de ON d.dep_no = de.dept_no
    JOIN CompanyProject.dbo.salaries$ s ON de.emp_no = s.emp_no
    WHERE de.to_date = '9999-01-01'
    GROUP BY d.dep_no, d.dep_name
)

-- Select the department with the highest average salary
SELECT TOP 1 dep_no, dep_name, AverageSalary
FROM DepartmentAverageSalaries
ORDER BY AverageSalary DESC;


---21. Retrieve the employee number, first name, last name, and salary of employees hired before the year 2005.
--To retrieve the employee number, first name, last name, and salary of employees hired before the year 2005, 
--you can filter the Employees$ table based on the hire_date and join it with the salaries$ table to get the salary information.

SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM CompanyProject.dbo.Employees$ e
JOIN CompanyProject.dbo.salaries$ s ON e.emp_no = s.emp_no
WHERE e.hire_date < '2005';


---22. Get the department number, name, and total number of employees for departments with a female manager
--To get the department number, name, and total number of employees for departments with a female manager, 
--you need to join several tables and apply appropriate filters.

SELECT d.dep_no, d.dep_name, COUNT(de.emp_no) AS NumberOfEmployees
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_manager$ dm ON d.dep_no = dm.dept_no
JOIN CompanyProject.dbo.Employees$ as e ON dm.emp_no = e.emp_no
JOIN CompanyProject.dbo.dept_emp$ as de ON d.dep_no = de.dept_no
WHERE e.gender = 'F'
AND dm.to_date = '9999-01-01'
AND de.to_date = '9999-01-01'
GROUP BY d.dep_no, d.dep_name;


---23. Retrieve the employee number, first name, last name, and department name of employees who are currently working in the Finance department.
--To retrieve the employee number, first name, last name, and department name of employees who are currently working in the 
--Finance department, you can join the Employees$, dept_emp$, and departments$ tables.

SELECT e.emp_no, e.first_name, e.last_name, d.dep_name
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.dept_emp$ as de ON e.emp_no = de.emp_no
JOIN CompanyProject.dbo.departments$ as d ON de.dept_no = d.dep_no
WHERE d.dep_name = 'Finance'
AND de.to_date = '9999-01-01';


---24. Find the employee with the highest salary in each department.
--To find the employee with the highest salary in each department, you can use a Common Table Expression (CTE) to first 
--identify the highest salary within each department and then join this result back to get the employee details

WITH DepartmentMaxSalaries AS (
    SELECT de.dept_no, MAX(s.salary) AS MaxSalary
    FROM CompanyProject.dbo.dept_emp$ de
    JOIN CompanyProject.dbo.salaries$ s ON de.emp_no = s.emp_no
    WHERE de.to_date = '9999-01-01'
    GROUP BY de.dept_no
)
SELECT e.emp_no, e.first_name, e.last_name, d.dep_name, s.salary
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.dept_emp$ as de ON e.emp_no = de.emp_no
JOIN CompanyProject.dbo.departments$ as d ON de.dept_no = d.dep_no
JOIN CompanyProject.dbo.salaries$ as s ON e.emp_no = s.emp_no
JOIN DepartmentMaxSalaries as dms ON de.dept_no = dms.dept_no AND s.salary = dms.MaxSalary
WHERE de.to_date = '9999-01-01';


---25. Retrieve the employee number, first name, last name, and department name of employees who have held a managerial position.
--To retrieve the employee number, first name, last name, and department name of employees who have held a managerial position, 
--you can join the Employees$, dept_manager$, and departments$ tables

SELECT e.emp_no, e.first_name, e.last_name, d.dep_name
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.dept_manager$ as dm ON e.emp_no = dm.emp_no
JOIN CompanyProject.dbo.departments$ as d ON dm.dept_no = d.dep_no;


---26. Get the total number of employees who have held the title "Senior Manager."

--To get the total number of employees who have held the title "Senior Manager," you can use the COUNT() function to count 
--the number of occurrences of this title in the employee_titles$ table.

SELECT COUNT(*) AS TotalSeniorManagers
FROM CompanyProject.dbo.employee_titles$
WHERE title = 'Senior Manager';


---27. Retrieve the department number, name, and the number of employees who have worked there for more than 5 years.
--To retrieve the department number, name, and the number of employees who have worked there for more than 5 years, 
--you can join the Employees$ and dept_emp$ tables and use a filter on the hire_date. 

--The expression DATEDIFF(YEAR, e.hire_date, GETDATE()) calculates the difference in years between the hire_date of an 
--employee (e.hire_date) and the current date (GETDATE()).
--The condition DATEDIFF(YEAR, e.hire_date, GETDATE()) > 5 then checks if the difference in years between the hire_date and 
--the current date is greater than 5, meaning the employee has worked for more than 5 years.
--This condition is used in the WHERE clause to filter out employees who have worked for more than 5 years.

SELECT d.dep_no, d.dep_name, COUNT(e.emp_no) AS NumberOfEmployees_morethan5yrs
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_emp$ as de ON d.dep_no = de.dept_no
JOIN CompanyProject.dbo.Employees$ as e ON de.emp_no = e.emp_no
WHERE DATEDIFF(YEAR, e.hire_date, GETDATE()) > 5
AND de.to_date = '9999-01-01'
GROUP BY d.dep_no, d.dep_name;


---28. Find the employee with the longest tenure in the company.
--To find the employee with the longest tenure in the company, you can use the ORDER BY clause to sort the employees based on 
--their tenure and then select the top 1 employee. 

SELECT TOP 1 emp_no, first_name, last_name, hire_date
FROM CompanyProject.dbo.Employees$
ORDER BY hire_date;


---29. Retrieve the employee number, first name, last name, and title of employees whose hire date is between '2005-01-01' and '2006-01-01'.

SELECT e.emp_no, e.first_name, e.last_name, et.title
FROM CompanyProject.dbo.Employees$ as e
JOIN CompanyProject.dbo.employee_titles$ as et ON e.emp_no = et.emp_no
WHERE e.hire_date >= '2005-01-01' AND e.hire_date < '2006-01-01';


---30. Get the department number, name, and the oldest employee's birth date for each department.
--To get the department number, name, and the oldest employee's birth date for each department, you can use a subquery or a Common Table Expression (CTE) 
--to first find the oldest employee's birth date for each department, and then join this result with the departments$ table to get the department details. 

SELECT d.dep_no, d.dep_name, e.birth_date AS OldestEmployeeBirthDate
FROM CompanyProject.dbo.departments$ as d
JOIN CompanyProject.dbo.dept_emp$ as de ON d.dep_no = de.dept_no
JOIN CompanyProject.dbo.Employees$ as e ON de.emp_no = e.emp_no
WHERE e.birth_date = (
    SELECT MIN(e2.birth_date)
    FROM CompanyProject.dbo.Employees$ e2
    JOIN CompanyProject.dbo.dept_emp$ de2 ON e2.emp_no = de2.emp_no
    WHERE de2.dept_no = de.dept_no
);






















