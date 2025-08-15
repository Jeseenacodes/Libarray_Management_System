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

---

## 🖼 Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    books {
        string ISBN PK
        string title
        string category
        decimal price
        string availability
        string author
        string publisher
    }
    members {
        int member_id PK
        string name
        date registration_date
        string address
    }
    issued_status {
        int issue_id PK
        date issue_date
        int employee_id FK
        int member_id FK
        string ISBN FK
    }
    return_status {
        int return_id PK
        date return_date
        int issue_id FK
    }
    employees {
        int employee_id PK
        string name
        string position
        decimal salary
        int branch_id FK
    }
    branch {
        int branch_id PK
        string branch_name
        string manager_name
    }

    books ||--o{ issued_status : "issued"
    members ||--o{ issued_status : "requests"
    issued_status ||--o{ return_status : "returned"
    employees ||--o{ issued_status : "handles"
    branch ||--o{ employees : "employs"
