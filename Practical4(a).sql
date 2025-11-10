-- Create Borrower table
CREATE TABLE Borrower (
    Roll_no NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    DateofIssue DATE,
    NameofBook VARCHAR2(50),
    Status CHAR(1) CHECK (Status IN ('I','R'))
);

-- Create Fine table
CREATE TABLE Fine (
    Roll_no NUMBER,
    Date_ DATE,
    Amt NUMBER(10,2)
);

-- Insert sample data
INSERT INTO Borrower VALUES (1, 'Akash', TO_DATE('10-OCT-2024','DD-MON-YYYY'), 'DBMS', 'I');
INSERT INTO Borrower VALUES (2, 'Neha', TO_DATE('20-OCT-2024','DD-MON-YYYY'), 'Java', 'I');
COMMIT;
SELECT * FROM Borrower;

SET SERVEROUTPUT ON;

DECLARE
    v_roll Borrower.Roll_no%TYPE;
    v_book Borrower.NameofBook%TYPE;
    v_dateissue Borrower.DateofIssue%TYPE;
    v_days NUMBER;
    v_fine NUMBER := 0;
    v_status Borrower.Status%TYPE;
    e_not_found EXCEPTION;
BEGIN
    v_roll := &Roll_no;
    v_book := '&NameofBook';

    SELECT DateofIssue, Status INTO v_dateissue, v_status
    FROM Borrower
    WHERE Roll_no = v_roll AND NameofBook = v_book;

    IF v_status = 'R' THEN
        RAISE e_not_found;
    END IF;

    v_days := TRUNC(SYSDATE - v_dateissue);

    IF v_days <= 15 THEN
        v_fine := 0;
    ELSIF v_days > 15 AND v_days <= 30 THEN
        v_fine := (v_days - 15) * 5;
    ELSE
        v_fine := (v_days - 30) * 50 + (15 * 5);
    END IF;

    UPDATE Borrower
    SET Status = 'R'
    WHERE Roll_no = v_roll AND NameofBook = v_book;

    IF v_fine > 0 THEN
        INSERT INTO Fine VALUES (v_roll, SYSDATE, v_fine);
        DBMS_OUTPUT.PUT_LINE('Fine imposed: Rs. ' || v_fine);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No fine applicable.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Book Returned Successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ Invalid Roll_no or Book Name.');
    WHEN e_not_found THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Book already returned earlier.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Unexpected error: ' || SQLERRM);
END;
/


SELECT * FROM Borrower;
SELECT * FROM Fine;
