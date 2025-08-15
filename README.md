# Libarray_Management_System


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


## 🗂 Key SQL Features
1️⃣ CRUD Operations

🔸 Create: Add new books, members, employees

🔸 Read: Retrieve with filters, sorting, aggregation

🔸 Update: Modify member addresses, book statuses, etc.

🔸 Delete: Remove outdated records or issue entries

2️⃣ Business Queries

Top 3 employees by books issued

Members who issued >3 books

Total rental income by category

Books never issued

Overdue books & days overdue

Branch performance metrics

Average salary per branch

3️⃣ Analytical Tables (CTAS)

book_issued_cnt – Times each book was issued

expensive_books – Books above average price

active_members – Members active in the last 2 months

4️⃣ Advanced SQL

Window Functions: Avg salary comparison by branch

CTEs: Employees with above-average salaries

Date Functions: Recent issues, overdue returns, seasonal trends

Joins: Combine tables for richer insights

  
