/*
DECLARE 변수이름 데이터타입;
DECLARE 변수이름 데이터타입 := 넣을값;
DECLARE 변수이름 데이터타입 DEFAULT 기본값;
*/
--ex) 
DECLARE NAME VARCHAR2(10) := '욱욱';

--ex) 선언, 출력
DECLARE NAME VARCHAR2(20) := '욱';
BEGIN
  DBMS_OUTPUT.put_Line('이효리'|| NAME); -- 출력
END;
