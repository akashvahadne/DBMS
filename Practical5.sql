-- **************************************
-- PRACTICAL 5: PL/SQL STORED PROCEDURE (proc_Grade)
-- **************************************

-- Step 1️⃣: Create Tables
DROP TABLE Stud_Marks PURGE;
DROP TABLE Result PURGE;

CREATE TABLE Stud_Marks (
    roll NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    total_marks NUMBER(5)
);

CREATE TABLE Result (
    roll NUMBER,
    name VARCHAR2(50),
    class VARCHAR2(30)
);

-- Step 2️⃣: Insert Sample Data
INSERT INTO Stud_Marks VALUES (1, 'Akash', 1450);
INSERT INTO Stud_Marks VALUES (2, 'Neha', 940);
INSERT INTO Stud_Marks VALUES (3, 'Rohan', 870);
INSERT INTO Stud_Marks VALUES (4, 'Meera', 780);
COMMIT;

-- Step 3️⃣: Create Stored Procedure
CREATE OR REPLACE PROCEDURE proc_Grade (
    p_roll Stud_Marks.roll%TYPE,
    p_name Stud_Marks.name%TYPE,
    p_marks Stud_Marks.total_marks%TYPE
) AS
    v_class VARCHAR2(30);
BEGIN
    -- Determine class based on marks
    IF p_marks BETWEEN 990 AND 1500 THEN
        v_class := 'Distinction';
    ELSIF p_marks BETWEEN 900 AND 989 THEN
        v_class := 'First Class';
    ELSIF p_marks BETWEEN 825 AND 899 THEN
        v_class := 'Higher Second Class';
    ELSE
        v_class := 'Fail';
    END IF;

    -- Insert result into Result table
    INSERT INTO Result VALUES (p_roll, p_name, v_class);

    -- Display output message
    DBMS_OUTPUT.PUT_LINE('Student: ' || p_name || ' | Class: ' || v_class);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_roll Stud_Marks.roll%TYPE;
    v_name Stud_Marks.name%TYPE;
    v_marks Stud_Marks.total_marks%TYPE;
    CURSOR c1 IS SELECT roll, name, total_marks FROM Stud_Marks;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_roll, v_name, v_marks;
        EXIT WHEN c1%NOTFOUND;
        proc_Grade(v_roll, v_name, v_marks);
    END LOOP;
    CLOSE c1;
    DBMS_OUTPUT.PUT_LINE('✅ Grades inserted successfully in Result table.');
END;
/

SELECT * FROM Result;
