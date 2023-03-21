/*
조합데이터
하나 이상의 필드를 가진 변수
Record
Collection

*/
-- 레코드 예
SET SERVEROUTPUT ON
DECLARE
  TYPE t_rec IS RECORD
     (v_sal number(8),
     v_minsal number(8) default 1000,
     v_hire_date employees.hire_date%type,
     v_rec1 employees%rowtype);
   v_myrec t_rec;
BEGIN
   v_myrec.v_sal := v_myrec.v_minsal + 500;
   v_myrec.v_hire_date := sysdate;
   SELECT * INTO v_myrec.v_rec1
   FROM employees
   WHERE employee_id = 100;
   DBMS_OUTPUT.PUT_LINE(v_myrec.v_rec1.last_name||' '||
   to_char(v_myrec.v_hire_date)||' '||
   to_char(v_myrec.v_sal));
END;
/
-- 통체로 업뎃
UPDATE retired_emps 
SET ROW = v_emp_rec     -- row  , %ROWTYPE
WHERE empno = v_employee_number;

DECLARE
  v_c varchar2(20) := 'CA';
  v_c_r countries%ROWTYPE;
begin
  select * into v_c_r
  from countries
  where country_id = UPPER(v_c);
    DBMS_OUTPUT.PUT_LINE ('Country Id: ' ||
    v_c_r.country_id ||
    ' Country Name: ' || v_c_r.country_name
    || ' Region: ' || v_c_r.region_id);
END;
/

/*
명시적 커서
*/
DECLARE 
  emp_rec	emp%ROWTYPE ; 
BEGIN 
  SELECT * INTO emp_rec         -- 행이 많아 오류
  FROM emp
  WHERE deptno = 10 ;

  DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 
END ;
/

DECLARE 
  CURSOR emp_cur IS         -- 커서 선언
    SELECT * FROM emp WHERE deptno = 10 ; 
  emp_rec	emp%ROWTYPE ; 
BEGIN 
  OPEN emp_cur ;        -- 실행 후 

--  FETCH emp_cur INTO emp_rec ;     -- 현재 행을 변수에 로드
--  DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 
--
--  FETCH emp_cur INTO emp_rec ;      -- 루프 안하면 개수 만큼 작성
--  DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 

  LOOP 
    FETCH emp_cur INTO emp_rec ; 
    EXIT WHEN emp_cur%NOTFOUND ;        -- 루프 나올 각
    DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 
  END LOOP ; 
  
  CLOSE emp_cur ;     -- 결과 행 집합 해제
END ;
/

/*
커서 FOR LOOP
- OPEN, FETCH, END, CLOSE 작업이 암시적으로 발생
- RECORD는 암시적으로 선언
*/
DECLARE
  CURSOR c_emp_cursor IS 
  SELECT employee_id, last_name 
  FROM employees
  WHERE department_id =30; 
BEGIN
  FOR emp_record IN c_emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' ' ||emp_record.last_name); 
  END LOOP; 
END;
/

/*
명시적 커서 속성
%ISOPEN - 커서가 열려 있으면 TRUE로 평가, if 로 확인 가능
%NOTFOUND - 가장 최근 패치(fetch)가 행을 반환하지 않으면 TRUE로 평가
%FOUND - 가장 최근 패치(fetch)가 행을 반환하면 TRUE로 평가
%ROWCOUNT - 지금까지 반환된 총 행 수로 평가
*/

DECLARE
  v_deptno NUMBER := 10;
  CURSOR c_emp_cursor IS
    SELECT last_name, salary,manager_id
    FROM employees
    WHERE department_id = v_deptno;
BEGIN
  FOR emp_record IN c_emp_cursor LOOP
    IF emp_record.salary < 5000 
      AND (emp_record.manager_id=101 OR emp_record.manager_id=124) 
    THEN
      DBMS_OUTPUT.PUT_LINE (emp_record.last_name || ' Due for a raise');
    ELSE
      DBMS_OUTPUT.PUT_LINE (emp_record.last_name || ' Not Due for a raise');
    END IF;
  END LOOP;
END;
/

/*
예외처리 Exception
블럭하나의 작업 중간에 오류나면 전체작업 취소, 예외시 오류나도 전 작업은 실행하고 정상 종료
*/
DECLARE 
  EMP_REC   EMP%ROWTYPE ; 
BEGIN 
   UPDATE EMP   
      SET SAL   = 2450 
    WHERE EMPNO = 7782 ; 
    
   SELECT * INTO EMP_REC 
     FROM EMP 
    WHERE DEPTNO = 10 ; 
END ; 
/
SELECT * FROM EMP WHERE EMPNO = 7782 ;

-- 예외 사용
BEGIN 
  UPDATE emp 
  SET sal = 3000 
  WHERE empno = 7782 ; 

  UPDATE emp 
  SET sal = 0 
  WHERE empno = 7934 ; 

EXCEPTION 
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE ( SQLERRM ) ;
END ; 
/

/*
 유저 정의 예외 트랩
*/

BEGIN
  UPDATE dept
  SET dname = 'Testing' 
  WHERE deptno = 50 ;

  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR ( -20001, 'No such department id.',true ) ; 
    -- 원래 나오는 에러 코드 대신, true 기존 코드도 나오게, false 안나오게
    -- -20000 ~ 20999 범위
  END IF;
END;
/

create table emp_result(
  ename varchar2(30), 
  sal number, 
  message varchar2(100));
  
DECLARE
  v_ename employees.last_name%type;
  v_emp_sal  employees.salary%type := 6000;
begin
  SELECT ename into v_ename
  from emp_result
  where sal=v_emp_sal;
  
  INSERT INTO emp_result (ename, sal) VALUES (v_ename , v_emp_sal);
EXCEPTION
  WHEN no_data_found THEN
    INSERT INTO emp_result (message)
    VALUES ('No employee with a salary of '|| TO_CHAR(v_emp_sal));
  WHEN too_many_rows THEN
    INSERT INTO emp_result (message)
    VALUES ('More than one employee with a salary of '|| TO_CHAR(v_emp_sal));
  WHEN others THEN
    INSERT INTO emp_result (message)
    VALUES ('Some other error occurred.');
end;
/


/*
익명블록                              프로시저
이름이 지정되지 않은 PL/SQL 블록        명명된 PL/SQL 블록
매번 컴파일                           한 번만 컴파일 됨
데이터베이스 저장되지 않음              데이터베이스에 저장됨
다른 응용 프로그램에서 호출 할 수없음    이름이 있으므로 다른 응용 프로그램에서 호출할 수 있음
값을 반환하지 않음                     함수는 값을 반환해야 함
파라미터를 사용할 수 없음               파라미터를 사용할 수 있음
*/

ROLLBACK;

CREATE TABLE EMP_SUM 
AS 
SELECT  DEPTNO, SUM(SAL) AS SUM_SAL 
FROM EMP 
GROUP BY DEPTNO ;

SELECT * FROM EMP_SUM ;

CREATE OR REPLACE PROCEDURE delete_emp
( p_empno   NUMBER ) 
IS
  emp_rec   emp%ROWTYPE ;
BEGIN 
  SELECT * INTO emp_rec 
  FROM emp
  WHERE empno = p_empno ; 

  DELETE emp
  WHERE empno = p_empno ; 

  UPDATE emp_sum
  SET sum_sal = sum_sal - emp_rec.sal 
  WHERE deptno = emp_rec.deptno ; 
  -- COMMIT ;
EXCEPTION 
  WHEN OTHERS THEN 
    -- ROLLBACK ;
    DBMS_OUTPUT.PUT_LINE (SQLERRM) ; 
END delete_emp ;
/

select * from emp;
EXECUTE DELETE_EMP(7788);
ROLLBACK;

/*
IN OUT INOUT
*/

CREATE OR REPLACE PROCEDURE proc1
( p1	  IN	NUMBER := 10 , 
  p2		IN	NUMBER := 20 ,
  p3		OUT	NUMBER ) 
IS 
BEGIN 
  p3 := p1 + p2 ; 
END proc1 ; 
/
-- 기본값 있을때
EXECUTE proc1(1,B);      -- 위치 지정 방식   
EXECUTE proc1 (p3 => B); -- 이름 지정 방식
-- 같이 쓸 시 위치지정 무조건 먼저
