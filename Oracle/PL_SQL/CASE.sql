DECLARE
SCORE NUMBER :=80;

BEGIN

CASE SCORE
WHEN >= 90 THEN
    DBMS_OUTPUT.PUT_LINE('A등급');
WHEN SCORE >= 80 THEN
    DBMS_OUTPUT.PUT_LINE('B등급');
ELSE
     DBMS_OUTPUT.PUT_LINE('C등급');
END CASE;

END;
