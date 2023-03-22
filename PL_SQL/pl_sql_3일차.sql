-- ADD_JOB 프로시저를 생성, 컴파일, 호출하여 결과를 검토
CREATE TABLE JOB_SAMPLE AS SELECT * FROM JOBS;

CREATE OR REPLACE PROCEDURE ADD_JOB (
  P_JOBID JOBS.JOB_ID%TYPE,
  P_JOBTITLE JOBS.JOB_TITLE%TYPE) IS
BEGIN
  INSERT INTO JOB_SAMPLE (JOB_ID, JOB_TITLE)
  VALUES (P_JOBID, P_JOBTITLE);
  COMMIT;
END ADD_JOB;
/

EXECUTE ADD_JOB ('IT_DBA', 'Database Administrator')
SELECT * 
FROM JOB_SAMPLE
WHERE JOB_ID = 'IT_DBA';

-- JOB_SAMPLE 테이블의 직무를 수정하는 UPD_JOB 이라는 프로시저를 생성
CREATE OR REPLACE PROCEDURE UPD_JOB (
  P_JOBID IN JOBS.JOB_ID%TYPE,
  P_JOBTITLE IN JOBS.JOB_TITLE%TYPE) IS
BEGIN
  UPDATE JOB_SAMPLE 
  SET JOB_TITLE = P_JOBTITLE
  WHERE JOB_ID = P_JOBID;
  
  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20202, 'No job updated.');
  END IF;
END UPD_JOB;
/

EXECUTE UPD_JOB ('IT_DBA', 'Data Administrator')
SELECT * FROM JOB_SAMPLE
WHERE JOB_ID = 'IT_DBA';

-- 사원 ID를 제공할 경우 사원의 급여와 직무ID를 검색하는 GET_EMPLOYEES라는 프로시저를 생성
-- EMPLOYEES 테이블을 query

CREATE OR REPLACE PROCEDURE GET_EMPLOYEE
  (P_EMPID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
  P_SAL OUT EMPLOYEES.SALARY%TYPE,
  P_JOB OUT EMPLOYEES.JOB_ID%TYPE) IS
BEGIN
  SELECT SALARY, JOB_ID
  INTO P_SAL, P_JOB
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = P_EMPID;
END GET_EMPLOYEE;
/

VARIABLE V_SALARY NUMBER
VARIABLE V_JOB VARCHAR2(15)

EXECUTE GET_EMPLOYEE(100, :V_SALARY, :V_JOB)
PRINT V_SALARY V_JOB



/*
함수
- RETURN 필수, 타입 명시, 크기지정x
- 함수는 성능 저하
- 호스트or로컬 변수, 단일행 함수, sql표현식에 사용가능
- 표현식일때 제한사항
  함수는 데이터베이스에 저장해야 한다.
  함수 파라미터는 IN이어야 하며 적합한 SQL 데이터 유형이어야 한다.
  함수는 적합한 SQL 데이터 유형을 반환 (BOOLEAN, RECORD, TABLE 금지)
  CREATE TABLE 또는 ALTER TABLE 문의 CHECK 제약 조건 절에서 호출 X
  열 기본값을 지정하는 데 사용 X
*/
CREATE OR REPLACE FUNCTION get_avg 
  ( p_deptno	NUMBER )  
RETURN  NUMBER  IS 
  v_avg		NUMBER ; 
BEGIN 
  SELECT AVG(sal) INTO v_avg 
  FROM emp 
  WHERE deptno = p_deptno ; 

  RETURN ROUND(v_avg) ; 
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE (SQLERRM) ; 
END get_avg ; 
/

SELECT empno, ename, job, sal, deptno, GET_AVG(deptno) 
FROM emp 
WHERE job = 'CLERK' ; 

SELECT empno, ename, job, sal, deptno, GET_AVG( p_deptno => deptno) 
FROM emp 
WHERE job = 'CLERK' ; 

SET SERVEROUTPUT ON
EXECUTE DBMS_OUTPUT.PUT_LINE ( get_avg(20) ) 


CREATE OR REPLACE FUNCTION get_avg 
( p_deptno	NUMBER )  
RETURN  NUMBER  IS 
  v_avg		NUMBER ; 
BEGIN 
  SELECT /*+ TEST */ AVG(sal) INTO v_avg 
  FROM emp 
  WHERE deptno = p_deptno ; 

  RETURN ROUND(v_avg) ; 
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE (SQLERRM) ; 
END get_avg ; 
/

SELECT empno, ename, job, sal, deptno, GET_AVG(deptno) 
  FROM emp  ; 

SELECT * FROM V$SQL     -- 관리자용 
WHERE SQL_TEXT LIKE 'SELECT /*+ TEST%' ; 


SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY) ;

CREATE OR REPLACE FUNCTION GET_JOB (p_job_id IN JOBS.JOB_ID%TYPE)
  RETURN JOBS.JOB_TITLE%TYPE
  IS v_title JOBS.JOB_TITLE%TYPE;
BEGIN
    SELECT JOB_TITLE INTO v_title
    FROM JOBS
    WHERE JOB_ID = p_job_id;
    
    RETURN v_title;
END;
/

VARIABLE b_title VARCHAR2(35);
execute :b_title := GET_JOB('SA_REP');
PRINT b_title;


CREATE OR REPLACE FUNCTION get_annual_comp(
  p_sal IN employees.salary%TYPE,
  p_comm IN employees.commission_pct%TYPE)
RETURN NUMBER IS
BEGIN
  RETURN (NVL(p_sal,0) * 12 + (NVL(p_comm,0) * nvl(p_sal,0) * 12));
END get_annual_comp;
/

SELECT employee_id, last_name,
  get_annual_comp(salary,commission_pct) as "Annual Compensation"
FROM employees
WHERE department_id=30 ;

ALTER SESSION SET NLS_DATE_LANGUAGE=KOREAN ;    -- 한글 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD' ;   -- 날짜형식 변경

rollback;
/*
패키지
 - 논리적으로 관련된 PL/SQL 유형, 변수 및 서브프로그램을 그룹화
 - spec 만들고 body 만들기
 - Spec은 패키지 외부에서 참조할 수 있는 유형, 변수 상수, 예외 커서 및 서브 프로그램을 선언(desc 로 보이는거)
 - Body는 커서에 대한 Query와 서브 프로그램에 대한 코드를 정의, 정보 숨기기 가능
*/
-- spec 먼저 선언
CREATE OR REPLACE PACKAGE comm_pkg IS
  v_std_comm	NUMBER := 0.1 ;         -- 변수 
  PROCEDURE	reset_comm(p_new_comm   NUMBER);    -- 공용 프로시저
END comm_pkg;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(COMM_PKG.v_std_comm) ;

-- body 선언
CREATE OR REPLACE PACKAGE BODY comm_pkg IS 
  v_priv_comm	NUMBER := 0.2 ; 
  FUNCTION validate(p_comm NUMBER) RETURN BOOLEAN IS 
    v_max_comm	employees.commission_pct%TYPE ;
  BEGIN
    SELECT MAX(commission_pct) INTO v_max_comm
    FROM employees ;
    RETURN (p_comm BETWEEN 0.0 AND v_max_comm) ;
  END validate ;

  PROCEDURE reset_comm (p_new_comm NUMBER) IS 
  BEGIN
    IF validate(p_new_comm) THEN
      v_std_comm := p_new_comm ;
    ELSE
      RAISE_APPLICATION_ERROR(-20210, 'Bad Commission');
    END IF;
  END reset_comm;

END comm_pkg;
/


CREATE OR REPLACE PACKAGE comm_pkg IS
  PRAGMA SERIALLY_REUSABLE ;
  v_std_comm	NUMBER := 0.1 ; 
  PROCEDURE	reset_comm(p_new_comm 	NUMBER);
END comm_pkg;
/


CREATE OR REPLACE PACKAGE BODY comm_pkg IS 
  PRAGMA SERIALLY_REUSABLE ;

  FUNCTION validate(p_comm NUMBER) RETURN BOOLEAN IS 
    v_max_comm	employees.commission_pct%TYPE ;
  BEGIN
    SELECT MAX(commission_pct) INTO v_max_comm
    FROM employees ;
    RETURN (p_comm BETWEEN 0.0 AND v_max_comm) ;
  END validate ;

  PROCEDURE reset_comm (p_new_comm NUMBER) IS 
  BEGIN
    IF validate(p_new_comm) THEN
      v_std_comm := p_new_comm ;
    ELSE
      RAISE_APPLICATION_ERROR(-20210, 'Bad Commission');
    END IF;
  END reset_comm;

END comm_pkg;
/

EXECUTE comm_pkg.reset_comm (0.2) 

EXECUTE DBMS_OUTPUT.PUT_LINE ( 'COMM : ' || comm_pkg.v_std_comm );


CREATE OR REPLACE PACKAGE comm_pkg IS
  v_std_comm	NUMBER := 0.1 ; 
  PROCEDURE	reset_comm(p_new_comm 	NUMBER);
END comm_pkg;
/

CREATE OR REPLACE PACKAGE BODY comm_pkg IS 

  PROCEDURE reset_comm (p_new_comm NUMBER) IS 
  BEGIN
    IF validate(p_new_comm) THEN
      v_std_comm := p_new_comm ;
    ELSE
      RAISE_APPLICATION_ERROR(-20210, 'Bad Commission');
    END IF;
  END reset_comm;

  FUNCTION validate(p_comm NUMBER) RETURN BOOLEAN IS 
    v_max_comm	employees.commission_pct%TYPE ;
  BEGIN
    SELECT MAX(commission_pct) INTO v_max_comm
    FROM employees ;
    RETURN (p_comm BETWEEN 0.0 AND v_max_comm) ;
  END validate ;

END comm_pkg;
/



CREATE OR REPLACE PACKAGE BODY comm_pkg IS 

  FUNCTION validate(p_comm NUMBER) RETURN BOOLEAN ; 

  PROCEDURE reset_comm (p_new_comm NUMBER) IS 
  BEGIN
    IF validate(p_new_comm) THEN
      v_std_comm := p_new_comm ;

    ELSE
      RAISE_APPLICATION_ERROR(-20210, 'Bad Commission');
    END IF;
  END reset_comm;

  FUNCTION validate(p_comm NUMBER) RETURN BOOLEAN IS 
    v_max_comm	employees.commission_pct%TYPE ;
  BEGIN
    SELECT MAX(commission_pct) INTO v_max_comm
    FROM employees ;
    
    RETURN (p_comm BETWEEN 0.0 AND v_max_comm) ;
  END validate ;

END comm_pkg;
/

-----------------------------------------------------
※ Overloading 사용

CREATE OR REPLACE PACKAGE dept_pkg IS
  PROCEDURE add_department(p_deptno NUMBER, 
                           p_name   VARCHAR2 := 'unknown', 
                           p_loc 	  NUMBER := 1700);

  PROCEDURE add_department(p_name   VARCHAR2 := 'unknown', 
                           p_loc    NUMBER := 1700);
END dept_pkg;
/

CREATE OR REPLACE PACKAGE BODY dept_pkg  IS
  PROCEDURE add_department (p_deptno 	NUMBER, 
                            p_name 	VARCHAR2 := 'unknown', 
                            p_loc 		NUMBER := 1700) IS
  BEGIN
    INSERT INTO departments(department_id, department_name, location_id) 
    VALUES  (p_deptno, p_name, p_loc);
  END add_department;

  PROCEDURE add_department (p_name 	VARCHAR2 := 'unknown', 
                            p_loc 	NUMBER := 1700)  IS
  BEGIN
    INSERT INTO departments (department_id, department_name, location_id)
    VALUES (departments_seq.NEXTVAL, p_name, p_loc);
  END add_department;
 END dept_pkg;
/

EXECUTE dept_pkg.add_department(980,'Education',2500)

SELECT * 
  FROM departments
 WHERE department_id = 980;

EXECUTE dept_pkg.add_department ('Training', 1700)

SELECT * 
  FROM departments
 WHERE department_name = 'Training';

ROLLBACK ;


※ 예외 표준화

CREATE OR REPLACE PACKAGE error_pkg IS
  e_fk_err 	    EXCEPTION;
  e_seq_nbr_err	EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_fk_err, -2292);
  PRAGMA EXCEPTION_INIT (e_seq_nbr_err, -2277);
END error_pkg;
/

SET SERVEROUTPUT ON
BEGIN
  DELETE FROM departments
  WHERE department_id = 10 ;
EXCEPTION
WHEN error_pkg.e_fk_err THEN
  DBMS_OUTPUT.PUT_LINE (SQLERRM) ;
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE (SQLERRM) ;
END;
/

※ 패키지 초기화 블록

CREATE OR REPLACE PACKAGE avg_pkg IS 
  v_std_avg	NUMBER ; 
  PROCEDURE	proc1 (p_empno		NUMBER) ; 
END avg_pkg ;
/

CREATE OR REPLACE PACKAGE BODY avg_pkg IS 
  PROCEDURE proc1 (p_empno	NUMBER) IS 
  BEGIN 
    NULL ; 
  END ;

  BEGIN 
    SELECT AVG(sal) INTO v_std_avg 
    FROM emp  ;
END avg_pkg ;
/


-- ex)
CREATE OR REPLACE PACKAGE JOB_PKG IS    -- spec 생성
  PROCEDURE ADD_JOB (P_JOBID JOBS.JOB_ID%TYPE, P_JOBTITLE JOBS.JOB_TITLE%TYPE);
  PROCEDURE UPD_JOB (P_JOBID IN JOBS.JOB_ID%TYPE, P_JOBTITLE IN JOBS.JOB_TITLE%TYPE);
  PROCEDURE DEL_JOB (P_JOBID JOBS.JOB_ID%TYPE);
  FUNCTION GET_JOB(P_JOBID IN JOBS.JOB_ID%TYPE) RETURN JOBS.JOB_TITLE%TYPE;
END JOB_PKG;
/

CREATE OR REPLACE PACKAGE BODY JOB_PKG IS   -- body 생성
  -- ADD_JOB 프로시저는 id,title 받아 행 추가
  PROCEDURE ADD_JOB (P_JOBID JOBS.JOB_ID%TYPE,  P_JOBTITLE JOBS.JOB_TITLE%TYPE) IS 
  BEGIN 
    INSERT INTO JOBS (JOB_ID, JOB_TITLE) 
              VALUES (P_JOBID, P_JOBTITLE); 
    COMMIT; 
  END ADD_JOB;
  -- UPD_JOB 프로시저는 id,title 받아 id 에 해당하는 title 변경
  PROCEDURE UPD_JOB(P_JOBID IN JOBS.JOB_ID%TYPE, P_JOBTITLE IN JOBS.JOB_TITLE%TYPE) IS 
  BEGIN 
    UPDATE JOBS 
    SET JOB_TITLE = P_JOBTITLE 
    WHERE JOB_ID = P_JOBID; 
    
    IF SQL%NOTFOUND THEN 
      RAISE_APPLICATION_ERROR(-20202, 'No job updated.'); 
    END IF; 
  END UPD_JOB; 
  -- DEL_JOB 프로시저는 id를 받아 해당하는 행 삭제
  PROCEDURE DEL_JOB (P_JOBID JOBS.JOB_ID%TYPE) IS 
  BEGIN 
    DELETE FROM JOBS 
    WHERE JOB_ID = P_JOBID; 
    
    IF SQL%NOTFOUND THEN 
      RAISE_APPLICATION_ERROR(-20203, 'No jobs deleted.'); 
    END IF; 
  END DEL_JOB; 
  -- GET_JOB 함수는 id를 받아 해당하는 title 반환
  FUNCTION GET_JOB (P_JOBID IN JOBS.JOB_ID%TYPE) 
  RETURN JOBS.JOB_TITLE%TYPE IS 
    V_TITLE JOBS.JOB_TITLE%TYPE; 
  BEGIN 
    SELECT JOB_TITLE 
    INTO V_TITLE 
    FROM JOBS 
    WHERE JOB_ID = P_JOBID;
    
    RETURN V_TITLE; 
  END GET_JOB; 
END JOB_PKG;
/

-- 프록시저 호출
EXECUTE JOB_PKG.ADD_JOB('IT_ADMIN','DATA ADMIN') ;  
SELECT * FROM JOBS ; 
EXECUTE JOB_PKG.UPD_JOB('IT_ADMIN','Ddatabase Administrator') ; 
SELECT * FROM JOBS ; 
EXECUTE JOB_PKG.DEL_JOB('IT_ADMIN') ; 
SELECT * FROM JOBS ;


/*
https://docs.oracle.com/database/121/TDDDG/tdddg_triggers.htm#TDDDG50000
트리거
- 조건 발생시 자동 실행
- DML, DDL 문
유형
-단순트리거
 - before
 - after
 - instead of  뷰에 사용
-혼합

*/
CREATE TABLE logt 
  (username	  VARCHAR2(30), 
  event_date  DATE, 
  empno		NUMBER(4),
  sal     NUMBER(7,2)) ;

CREATE OR REPLACE TRIGGER logt_emp
  BEFORE INSERT OR DELETE OR UPDATE ON emp
BEGIN
  INSERT INTO logt(username,event_date)
  VALUES (user,sysdate) ; 
END ;
/
UPDATE emp 
SET sal = sal * 1.1 
WHERE deptno = 20 ; 

SELECT * FROM logt ; 
 ROLLBACK;

-- 행트리거
CREATE OR REPLACE TRIGGER logt_emp   
  BEFORE INSERT OR DELETE OR UPDATE ON emp
  FOR EACH ROW      -- 행 트리거
BEGIN
  INSERT INTO logt(username,event_date,empno,sal)
  VALUES (user,sysdate,:NEW.empno, :NEW.sal) ; 
END ;
/

UPDATE emp 
SET sal = sal * 1.1 
WHERE deptno = 20 ; 

-- 문장 트리거 (기본값)
CREATE OR REPLACE TRIGGER secure_emp
  BEFORE INSERT ON emp
BEGIN
  IF (TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN')) OR
     (TO_CHAR(SYSDATE,'HH24:MI') NOT BETWEEN '08:00' AND '18:00') THEN
  
     RAISE_APPLICATION_ERROR(-20500, 'You may insert into EMP table only during business hours.');
  END IF;
END;
/

INSERT INTO emp(empno, ename, deptno) 
VALUES (1234,'abc',30) ;

SELECT empno, ename, deptno
FROM emp 
WHERE empno = 1234 ;

-- old 트리거 처리할 값 원래 값
-- new 새 값

/*
트리거 상태
Enabled 
Disabled 
*/
ALTER TRIGGER 트리거이름 DISABLE | ENABLE;
ALTER TABLE 테이블이름 DIABLE | ENABLE ALL TRIGGERS;
ALTER TRIGGER 트리거이름 COMPILE;  -- 수정한 트리거 넣기
DROP TRIGGER 트리거이름;   -- 트리거 제거

-- ex)
CREATE TABLE NEW_EMPLOYEES AS SELECT * FROM EMPLOYEES;

CREATE OR REPLACE PROCEDURE CHECK_SALARY(
  P_JOB VARCHAR2,
  P_SALARY NUMBER)
  AS
  V_MINSAL JOBS.MIN_SALARY%TYPE;
  V_MAXSAL JOBS.MAX_SALARY%TYPE;
BEGIN
  SELECT MIN_SALARY, MAX_SALARY 
  INTO V_MINSAL, V_MAXSAL
  FROM JOBS
  WHERE JOB_ID = UPPER(P_JOB);
  
  IF P_SALARY NOT BETWEEN V_MINSAL AND V_MAXSAL THEN
    RAISE_APPLICATION_ERROR(-20100, 
    'Invalid salary $' ||P_SALARY ||'. '||
    'Salaries for job '|| P_JOB || 
    ' must be between $'|| V_MINSAL ||' and $' || V_MAXSAL);
   END IF;
END;
/

create OR REPLACE TRIGGER CHECK_SALARY_TRG
  BEFORE INSERT OR UPDATE OF job_id, salary 
  ON new_employees
  FOR EACH ROW
  BEGIN
    check_salary(:new.job_id, :new.salary);
END;
/
INSERT INTO NEW_EMPLOYEES(last_name, first_name, salary, email, hire_date, job_id)
VALUES('Eleanor', 'Beh', 30, 'eleanor@test.com', sysdate, 'SA_REP');


/*
컴파일시 텍스트로 저장, 실행시 동작
EXECUTE IMMEDIATE
*/
CREATE OR REPLACE PROCEDURE rename_col 
( p_tab_name	VARCHAR2, 
 p_old_name	VARCHAR2,
 p_new_name	VARCHAR2 ) IS 
BEGIN 
 EXECUTE IMMEDIATE 
  'ALTER TABLE ' || p_tab_name || ' RENAME COLUMN ' || p_old_name || ' TO ' || p_new_name;
END ;
/
EXECUTE rename_col ( 'emp', 'empno', 'id' )


/*
Native Dynamic SQL 사용

SQL 명령문의 처리 과정 
1. PARSE : 실행 계획 확보 
2. BIND  : 바인드 변수에 값 입력 
3. EXECUTE : 실행 
4. FETCH : select 명령문만, 검색 결과 인출 

밑이 더 빠름
*/
SET TIMING ON
DECLARE 
v_cnt		NUMBER ;
BEGIN
  FOR i IN 1..10000 LOOP
     EXECUTE IMMEDIATE 
     'select /* test1 */ count(*) 
     from emp 
     where empno = '|| i INTO v_cnt ; 
  END LOOP ;
END ;
/

DECLARE 
v_cnt		NUMBER ;
BEGIN
  FOR i IN 1..10000 LOOP
     select /* test2 */ count(*)   INTO v_cnt
       from emp 
      where empno = i ; 
  END LOOP ;
END ;
/

DECLARE 
v_cnt		NUMBER ;
BEGIN
  FOR i IN 1..10000 LOOP
     EXECUTE IMMEDIATE      -- select은 동적 안 써도됨,
     'select /* test3 */ count(*) 
     from emp 
     where empno = :1' INTO v_cnt USING i ;   -- using 으로 계획 재생성 안하게
  END LOOP ;
END ;
/
