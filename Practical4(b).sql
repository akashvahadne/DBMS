-- **************************************
-- PRACTICAL 4(b): Calculate Area of Circle using PL/SQL Loop
-- **************************************

-- 1️⃣ Create table to store results
DROP TABLE Areas PURGE;

CREATE TABLE Areas (
    radius NUMBER(5,2),
    area NUMBER(10,2)
);

-- 2️⃣ PL/SQL Block
SET SERVEROUTPUT ON;

DECLARE
    v_radius NUMBER := 5;      -- starting value of radius
    v_area   NUMBER;           -- variable to store calculated area
    pi CONSTANT NUMBER := 3.14159;  -- define PI constant
BEGIN
    WHILE v_radius <= 9 LOOP
        -- Calculate area of circle
        v_area := pi * v_radius * v_radius;

        -- Insert into table
        INSERT INTO Areas VALUES (v_radius, v_area);

        -- Display on screen
        DBMS_OUTPUT.PUT_LINE('Radius: ' || v_radius || ' --> Area: ' || ROUND(v_area,2));

        -- Increment radius by 1
        v_radius := v_radius + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('✅ Data inserted into AREAS table successfully!');
END;
/
