<img width="2549" height="890" alt="LMS ERdiagram" src="https://github.com/user-attachments/assets/5db9b2ba-63e2-4dc9-ae58-c56f0cb72bf6" /># Library Management System


[![Data Analytics](https://img.shields.io/badge/Data_Analytics-Professional-orange)](https://www.coursera.org/professional-certificates/google-data-analytics)
[![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-Completed-success)]()

A **Library Management System** built entirely with **SQL** to simulate and analyze library operations.  
It manages books, members, employees, branches, issue/return tracking, and rental incomes — while performing **data analysis to generate valuable business insights**.

---

## 🗂 Database Structure

| Table Name       | Description |
|------------------|-------------|
| **books**        | Details of all books (ISBN, title, category, price, availability, author, publisher) |
| **members**      | Member details including registration date and address |
| **issued_status**| Tracks book issues (issuing employee & member) |
| **return_status**| Tracks returned books and return dates |
| **employees**    | Employee details (position, salary, branch) |
| **branch**       | Library branch details, including manager info |

## **ER Diagram**
*<img width="2647" height="3840" alt="Library Management System ER Diagram" src="https://github.com/user-attachments/assets/7e6a5ad3-e2e6-4f54-b84c-9d49b5b83d20" />*  

## **ER Diagram**
erDiagram
    BOOKS {
        string isbn PK
        string book_title
        string category
        float rental_price
        string status
        string author
        string publisher
    }

    ISSUED_STATUS {
        int issued_id PK
        int issued_member_id FK
        string issued_book_name
        string issued_date
        string issued_book_isbn FK
        int issued_emp_id FK
    }

    RETURN_STATUS {
        int return_id PK
        int issued_id FK
        string return_book_name
        string return_date
        string return_book_isbn
    }

    EMPLOYEES {
        int emp_id PK
        string emp_name
        string position
        float salary
        int branch_id FK
    }

    MEMBERS {
        int member_id PK
        string member_name
        string member_address
        string reg_date
    }

    BRANCH {
        int branch_id PK
        int manager_id
        string branch_address
        string contact_no
    }

    BOOK_ISSUED_CNT {
        string isbn PK
        string book_title
        int issue_count
    }

    EXPENSIVE_BOOKS {
        string isbn
        string book_title
        string category
        float rental_price
        string status
        string author
        string publisher
    }

    BOOKS ||--o{ ISSUED_STATUS : "has"
    MEMBERS ||--o{ ISSUED_STATUS : "issues"
    EMPLOYEES ||--o{ ISSUED_STATUS : "handles"
    ISSUED_STATUS ||--o{ RETURN_STATUS : "returns"
    EMPLOYEES ||--o{ BRANCH : "works_at"
    BRANCH ||--|| EMPLOYEES : "managed_by"
---



## 🗂 Key SQL Features
1️⃣ CRUD Operations
## Key Findings and Insights
- Create: Add new books, members, employees
- Read: Retrieve with filters, sorting, aggregation
- Update: Modify member addresses, book statuses, etc.
- Delete: Remove outdated records or issue entries

2️⃣ Business Queries
- Top 3 employees by books issued
- Members who issued >3 books
- Total rental income by category
- Books never issued
- Overdue books & days overdue
- Branch performance metrics
- Average salary per branch

3️⃣ Analytical Tables (CTAS)
- book_issued_cnt – Times each book was issued
- expensive_books – Books above average price
- active_members – Members active in the last 2 months

4️⃣ Advanced SQL
- Window Functions: Avg salary comparison by branch
- CTEs: Employees with above-average salaries
- Date Functions: Recent issues, overdue returns, seasonal trends
- Joins: Combine tables for richer insights

### Example SQL Queries
 1️⃣ Top 3 employees who issued the most books
```sql
SELECT e.employee_id, e.name, COUNT(i.issue_id) AS total_issued
FROM employees e
JOIN issued_status i ON e.employee_id = i.employee_id
GROUP BY e.employee_id, e.name
ORDER BY total_issued DESC
LIMIT 3;
```
 2️⃣ Members who issued more than 3 books
 ```sql
SELECT m.member_id, m.name, COUNT(i.issue_id) AS books_issued
FROM members m
JOIN issued_status i ON m.member_id = i.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(i.issue_id) > 3;
```
3️⃣ Total rental income by category
```sql
SELECT b.category, SUM(b.price) AS total_income
FROM books b
JOIN issued_status i ON b.ISBN = i.ISBN
JOIN return_status r ON i.issue_id = r.issue_id
GROUP BY b.category
ORDER BY total_income DESC; 
```

4️⃣ Books never issued
```sql
SELECT b.ISBN, b.title
FROM books b
LEFT JOIN issued_status i ON b.ISBN = i.ISBN
WHERE i.issue_id IS NULL; 
```

## 🗂 Learning Outcomes
- Understand database schema design for a library system
- Write efficient SQL queries for real-world problems
- Use aggregate, analytical, and date functions
- Create reports for business decision-making
- Gain confidence in SQL for data analysis

## 🗂 Use Cases
- Hospital Management System
- Hotel Reservation System
- Student performance evaluation
- Car Rental System

## 🗂 Tech Stack
- SQL (PostgreSQL / MySQL / SQL Server compatible)
- Relational Database Design
- Analytical & Reporting Queries
