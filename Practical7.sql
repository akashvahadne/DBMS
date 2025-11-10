-- **************************************
-- PRACTICAL 7: DATABASE TRIGGER (AUDIT ON UPDATE/DELETE)
-- **************************************

-- Step 1️⃣: Create main Library table
DROP TABLE Library PURGE;
CREATE TABLE Library (
    book_id NUMBER PRIMARY KEY,
    book_name VARCHAR2(100),
    author VARCHAR2(50),
    price NUMBER(8,2)
);

-- Step 2️⃣: Create Library_Audit table for logging old data
DROP TABLE Library_Audit PURGE;
CREATE TABLE Library_Audit (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
    book_id NUMBER,
    book_name VARCHAR2(100),
    author VARCHAR2(50),
    price NUMBER(8,2),
    operation_type VARCHAR2(20),
    operation_date DATE
);

-- Step 3️⃣: Insert initial records
INSERT INTO Library VALUES (1, 'DBMS Concepts', 'Korth', 500);
INSERT INTO Library VALUES (2, 'Operating System', 'Galvin', 450);
INSERT INTO Library VALUES (3, 'Computer Networks', 'Tanenbaum', 600);
COMMIT;

-- Step 4️⃣: Create Trigger to track UPDATE and DELETE operations
CREATE OR REPLACE TRIGGER trg_library_audit
AFTER UPDATE OR DELETE ON Library
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        INSERT INTO Library_Audit (book_id, book_name, author, price, operation_type, operation_date)
        VALUES (:OLD.book_id, :OLD.book_name, :OLD.author, :OLD.price, 'UPDATE', SYSDATE);
        DBMS_OUTPUT.PUT_LINE('🔄 Book Updated: ' || :OLD.book_name);
    ELSIF DELETING THEN
        INSERT INTO Library_Audit (book_id, book_name, author, price, operation_type, operation_date)
        VALUES (:OLD.book_id, :OLD.book_name, :OLD.author, :OLD.price, 'DELETE', SYSDATE);
        DBMS_OUTPUT.PUT_LINE('❌ Book Deleted: ' || :OLD.book_name);
    END IF;
END;
/

SET SERVEROUTPUT ON;

-- Update operation
UPDATE Library SET price = 550 WHERE book_id = 1;

-- Delete operation
DELETE FROM Library WHERE book_id = 2;

COMMIT;

SELECT * FROM Library_Audit;
