--Library management system 

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

--1.  Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books;

--2.  Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

--3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE   issued_id =   'IS121';

-- 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status WHERE issued_emp_id = 'E101'

--5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT * FROM issued_status;

SELECT issued_emp_id, COUNT(*) AS total_book_issued FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

--CTAS (Create Table As Select)
-- 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count FROM issued_status as ist
JOIN books as b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

--Data Analysis & Findings
--The following SQL queries were used to address specific questions:
-- 7. Retrieve All Books in a Specific Category 'Classic':
SELECT * FROM books WHERE category = 'Classic';

--8: Find Total Rental Income by Category:
SELECT * FROM issued_status;
SELECT * FROM books;

SELECT category, SUM(rental_price) FROM books
GROUP BY 1 

SELECT b.category, SUM(b.rental_price) AS Total_rental_price, COUNT(*)
FROM issued_status as ist
JOIN books as b ON b.isbn = ist.issued_book_isbn
GROUP BY 1
ORDER BY Total_rental_price DESC

--List Members Who Registered in the Last 180 Days:
INSERT INTO members(member_id, member_name, member_address, reg_date) 
VALUES
('C130', 'SAM', '133 Main St', '2024-06-01'),
('C131', 'Bobby', '576 Elm St', '2024-05-01');

SELECT * FROM members WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

--10.List Employees with Their Branch Manager's Name and their branch details:
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name as manager
FROM employees as e1
JOIN branch as b ON e1.branch_id = b.branch_id    
JOIN employees as e2 ON e2.emp_id = b.manager_id

SELECT * FROM branch; 
SELECT * FROM employees; 

--11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books WHERE rental_price > 7.00;

--12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN return_status as rs ON rs.issued_id = ist.issued_id WHERE rs.return_id IS NULL;

--Advanced SQL Operations
--13: Identify Members with Overdue Books assuming a 30-day return period.
--Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1

-- 14: Update Book Status on Return
--Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
SELECT * FROM return_status
SELECT * FROM issued_status
SELECT * FROM books	

UPDATE books
SET status = 'Yes'
WHERE isbn IN (
    SELECT i.issued_book_isbn
    FROM issued_status i
    INNER JOIN return_status r ON i.issued_id = r.issued_id
);

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

-- 15: Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of books issued, 
--the number of books returned, and the total revenue generated from book rentals.
SELECT
b.branch_id,
COUNT(i.issued_id) AS books_issued, 
COUNT(r.return_id) AS books_returned, 
sum(bk.rental_price) AS rental_income
FROM issued_status AS i
JOIN employees AS e ON e.emp_id = i.issued_emp_id  
JOIN branch AS b ON e.branch_id = b.branch_id
LEFT JOIN return_status AS r ON r.issued_id = i.issued_id
JOIN books AS bk ON i.issued_book_isbn = bk.isbn
GROUP BY b.branch_id

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;

-- 16: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;

-- 17: Find the top 3 employees who issued the most books, showing their name, books processed, and branch.
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN employees as e ON e.emp_id = ist.issued_emp_id
JOIN branch as b ON e.branch_id = b.branch_id
GROUP BY 1, 2
limit 3

SELECT
    e.emp_name, e.branch_id,
    COUNT(i.issued_id) AS books_issued
FROM employees AS e
JOIN issued_status AS i ON i.issued_emp_id = e.emp_id
GROUP BY e.emp_name, e.branch_id
ORDER BY books_issued DESC
LIMIT 3;

-- Find the total number of members registered each year.
SELECT 
    COUNT(*) AS members_registered, 
    EXTRACT(YEAR FROM reg_date) AS reg_year
FROM members
GROUP BY reg_year
ORDER BY members_registered DESC;

-- Show the names of employees along with the branch address where they work.
SELECT  e.emp_name, b.branch_address
FROM employees AS e
JOIN branch AS b ON e.branch_id = b.branch_id;

-- Find all books issued but not yet returned
SELECT i.issued_id, i.issued_book_name
FROM issued_status AS i
LEFT JOIN return_status AS r ON r.issued_id = i.issued_id
WHERE r.issued_id IS NULL;

-- List members who have issued more than 3 books.
SELECT m.*, COUNT(i.issued_id) AS books_issued
FROM members AS m
JOIN issued_status AS i ON i.issued_member_id = m.member_id
GROUP BY m.member_id
HAVING COUNT(i.issued_id) > 3
ORDER BY books_issued DESC;

-- Find the employee who has issued the most books.
SELECT e.*,   COUNT(i.issued_id) AS books_issued
FROM employees AS e
JOIN issued_status AS i ON i.issued_emp_id = e.emp_id
GROUP BY e.emp_id
ORDER BY books_issued DESC
LIMIT 1;

-- Calculate the average salary of employees in each branch.
SELECT AVG(salary) AS avg_salary, branch_id
FROM employees
GROUP BY branch_id
ORDER BY avg_salary DESC;

-- Find the branch that has issued the highest number of books.
SELECT e.branch_id,  COUNT(i.issued_id) AS books_issued
FROM employees AS e
JOIN issued_status AS i ON i.issued_emp_id = e.emp_id
GROUP BY e.branch_id
ORDER BY books_issued DESC;

-- List the details of books that have never been issued.
SELECT bk.* FROM books AS bk
LEFT JOIN issued_status AS i ON bk.isbn = i.issued_book_isbn
WHERE i.issued_book_isbn is null

-- Show the total rental price for all books issued by each employee.
SELECT i.issued_emp_id, sum(bk.rental_price) AS rental_price
FROM issued_status AS i
JOIN books AS bk ON bk.isbn = i.issued_book_isbn
GROUP BY i.issued_emp_id
ORDER BY rental_price desc

-- Retrieve the list of members along with the number of books they have returned
SELECT m.member_id, m.member_name, COUNT(r.issued_id) AS books_returned
FROM members m
JOIN issued_status i ON i.issued_member_id = m.member_id
JOIN return_status r ON r.issued_id = i.issued_id
GROUP BY m.member_id, m.member_name
ORDER BY books_returned desc;

-- Find the top 5 most frequently issued book titles.
SELECT issued_book_name, COUNT(issued_id) AS issue_frequency
FROM issued_status
GROUP BY issued_book_name
ORDER BY issue_frequency desc
LIMIT 5

-- Show the details of members who have never returned any book.
SELECT m.*
SEOM members AS m
JOIN issued_status AS i ON i.issued_member_id = m.member_id
LEFT JOIN  return_status AS r ON r.issued_id = i.issued_id
WHERE r.issued_id IS null

-- Find the overdue books assuming books should be returned within 30 days of issue date.
SELECT  bk.*, i.issued_date, r.return_date,(r.return_date - i.issued_date) as overdue
FROM books AS bk
JOIN issued_status AS i ON i.issued_book_isbn = bk.isbn
JOIN return_status AS r ON r.issued_id = i.issued_id
WHERE (r.return_date - i.issued_date) > 30;

-- find the average rental price for each category
SELECT  category, ROUND(AVG(rental_price)::numeric, 2) AS avg_price
FROM books
GROUP BY category
ORDER BY avg_price DESC;

-- Show the number of books issued per month for the current year.
SELECT * from books
SELECT * from issued_status

SELECT COUNT(issued_book_name) AS books_count,
EXTRACT (month from issued_date) AS issued_month
FROM issued_status
WHERE EXTRACT(YEAR FROM issued_date) = extract(year from current_date)
GROUP BY issued_month
ORDER BY books_count

-- Display employees earning above the average salary of their branch.
SELECT * FROM employees;

WITH high_salary_emp AS (
	SELECT branch_id, emp_id, emp_name, salary,
	AVG(salary) OVER(partition by branch_id) AS avg_salary
	FROM employees )
SELECT * FROM high_salary_emp
WHERE salary > avg_salary

-- Retrieve books issued in the last 7 days along with the issuing employee's name.
SELECT  i.issued_book_isbn,  i.issued_book_name, e.emp_name
FROM issued_status AS i
JOIN employees AS e ON e.emp_id = i.issued_emp_id
WHERE i.issued_date >= current_date - INTERVAL '7 days';

-- Find the member who spent the most on rental prices (sum of rental_price for all issued books).
SELECT m.member_id, m.member_name, SUM(bk.rental_price) AS total_spent
FROM members AS m
JOIN issued_status AS i ON i.issued_member_id = m.member_id
JOIN books AS bk ON bk.isbn = i.issued_book_isbn
GROUP BY m.member_id, m.member_name
ORDER BY total_spent desc
LIMIT 1

-- Show branches with no employees assigned
SELECT b.branch_id, b.branch_address
FROM branch AS b
LEFT JOIN employees AS e  ON e.branch_id = b.branch_id
WHERE e.branch_id IS NULL;



