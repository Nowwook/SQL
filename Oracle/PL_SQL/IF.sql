DECLARE
SCORE NUMBER :=80;  -- 변수선언

BEGIN

IF SCORE >= 90 THEN                   -- 조건1
    DBMS_OUTPUT.PUT_LINE('A등급');    
ELSIF SCORE >=80 THEN                 -- 조건2
    DBMS_OUTPUT.PUT_LINE('B등급');
ELSE                                  -- 나머지
     DBMS_OUTPUT.PUT_LINE('C등급');
END IF;                               -- if 종료 선언

END;
