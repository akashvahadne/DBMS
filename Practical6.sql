-- **************************************
-- PRACTICAL 6: PARAMETERIZED CURSOR (MERGING TABLE DATA)
-- **************************************

-- Step 1️⃣: Create both tables
DROP TABLE N_RollCall PURGE;
DROP TABLE O_RollCall PURGE;

CREATE TABLE O_RollCall (
    roll_no NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    class VARCHAR2(20)
);

CREATE TABLE N_RollCall (
    roll_no NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    class VARCHAR2(20)
);

-- Step 2️⃣: Insert data into Old RollCall
INSERT INTO O_RollCall VALUES (1, 'Akash', 'FY');
INSERT INTO O_RollCall VALUES (2, 'Neha', 'SY');
INSERT INTO O_RollCall VALUES (3, 'Rohan', 'TY');

-- Step 3️⃣: Insert data into New RollCall (some duplicate, some new)
INSERT INTO N_RollCall VALUES (2, 'Neha', 'SY');
INSERT INTO N_RollCall VALUES (3, 'Rohan', 'TY');
INSERT INTO N_RollCall VALUES (4, 'Meera', 'FY');
INSERT INTO N_RollCall VALUES (5, 'Saurabh', 'TY');

COMMIT;

-- Step 4️⃣: Enable Output
SET SERVEROUTPUT ON;

-- Step 5️⃣: PL/SQL Block with Parameterized Cursor
DECLARE
    -- Parameterized cursor: accepts roll number
    CURSOR c_new(p_roll N_RollCall.roll_no%TYPE) IS
        SELECT roll_no, name, class
        FROM N_RollCall
        WHERE roll_no = p_roll;

    v_roll N_RollCall.roll_no%TYPE;
    v_name N_RollCall.name%TYPE;
    v_class N_RollCall.class%TYPE;
    v_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Merge Operation ---');

    -- Loop through each record from New RollCall table
    FOR rec IN (SELECT roll_no FROM N_RollCall) LOOP
        -- Check if roll number already exists in Old table
        SELECT COUNT(*) INTO v_count
        FROM O_RollCall
        WHERE roll_no = rec.roll_no;

        IF v_count = 0 THEN
            -- Open parameterized cursor for the current roll number
            OPEN c_new(rec.roll_no);
            FETCH c_new INTO v_roll, v_name, v_class;

            -- Insert new record into Old RollCall
            INSERT INTO O_RollCall VALUES (v_roll, v_name, v_class);

            DBMS_OUTPUT.PUT_LINE('Inserted Roll No: ' || v_roll || ' | Name: ' || v_name);

            CLOSE c_new;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Skipped Duplicate Roll No: ' || rec.roll_no);
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('✅ Merge Completed Successfully!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Error: ' || SQLERRM);
END;
/
SELECT * FROM O_RollCall;
