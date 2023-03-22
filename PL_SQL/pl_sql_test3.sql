-- ADD_JOB ���ν����� ����, ������, ȣ���Ͽ� ����� ����
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

-- JOB_SAMPLE ���̺��� ������ �����ϴ� UPD_JOB �̶�� ���ν����� ����
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

-- ��� ID�� ������ ��� ����� �޿��� ����ID�� �˻��ϴ� GET_EMPLOYEES��� ���ν����� ����
-- EMPLOYEES ���̺��� query

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
�Լ�
- RETURN �ʼ�, Ÿ�� ���, ũ������x
- �Լ��� ���� ����
- ȣ��Ʈor���� ����, ������ �Լ�, sqlǥ���Ŀ� ��밡��
- ǥ�����϶� ���ѻ���
  �Լ��� �����ͺ��̽��� �����ؾ� �Ѵ�.
  �Լ� �Ķ���ʹ� IN�̾�� �ϸ� ������ SQL ������ �����̾�� �Ѵ�.
  �Լ��� ������ SQL ������ ������ ��ȯ (BOOLEAN, RECORD, TABLE ����)
  CREATE TABLE �Ǵ� ALTER TABLE ���� CHECK ���� ���� ������ ȣ�� X
  �� �⺻���� �����ϴ� �� ��� X
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

SELECT * FROM V$SQL     -- �����ڿ� 
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

ALTER SESSION SET NLS_DATE_LANGUAGE=KOREAN ;    -- �ѱ� ����
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD' ;   -- ��¥���� ����

rollback;
/*
��Ű��
 - �������� ���õ� PL/SQL ����, ���� �� �������α׷��� �׷�ȭ
 - spec ����� body �����
 - Spec�� ��Ű�� �ܺο��� ������ �� �ִ� ����, ���� ���, ���� Ŀ�� �� ���� ���α׷��� ����(desc �� ���̴°�)
 - Body�� Ŀ���� ���� Query�� ���� ���α׷��� ���� �ڵ带 ����, ���� ����� ����
*/
-- spec ���� ����
CREATE OR REPLACE PACKAGE comm_pkg IS
  v_std_comm	NUMBER := 0.1 ;         -- ���� 
  PROCEDURE	reset_comm(p_new_comm   NUMBER);    -- ���� ���ν���
END comm_pkg;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(COMM_PKG.v_std_comm) ;

-- body ����
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
�� Overloading ���

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


�� ���� ǥ��ȭ

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

�� ��Ű�� �ʱ�ȭ ���

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
CREATE OR REPLACE PACKAGE JOB_PKG IS    -- spec ����
  PROCEDURE ADD_JOB (P_JOBID JOBS.JOB_ID%TYPE, P_JOBTITLE JOBS.JOB_TITLE%TYPE);
  PROCEDURE UPD_JOB (P_JOBID IN JOBS.JOB_ID%TYPE, P_JOBTITLE IN JOBS.JOB_TITLE%TYPE);
  PROCEDURE DEL_JOB (P_JOBID JOBS.JOB_ID%TYPE);
  FUNCTION GET_JOB(P_JOBID IN JOBS.JOB_ID%TYPE) RETURN JOBS.JOB_TITLE%TYPE;
END JOB_PKG;
/

CREATE OR REPLACE PACKAGE BODY JOB_PKG IS   -- body ����
  -- ADD_JOB ���ν����� id,title �޾� �� �߰�
  PROCEDURE ADD_JOB (P_JOBID JOBS.JOB_ID%TYPE,  P_JOBTITLE JOBS.JOB_TITLE%TYPE) IS 
  BEGIN 
    INSERT INTO JOBS (JOB_ID, JOB_TITLE) 
              VALUES (P_JOBID, P_JOBTITLE); 
    COMMIT; 
  END ADD_JOB;
  -- UPD_JOB ���ν����� id,title �޾� id �� �ش��ϴ� title ����
  PROCEDURE UPD_JOB(P_JOBID IN JOBS.JOB_ID%TYPE, P_JOBTITLE IN JOBS.JOB_TITLE%TYPE) IS 
  BEGIN 
    UPDATE JOBS 
    SET JOB_TITLE = P_JOBTITLE 
    WHERE JOB_ID = P_JOBID; 
    
    IF SQL%NOTFOUND THEN 
      RAISE_APPLICATION_ERROR(-20202, 'No job updated.'); 
    END IF; 
  END UPD_JOB; 
  -- DEL_JOB ���ν����� id�� �޾� �ش��ϴ� �� ����
  PROCEDURE DEL_JOB (P_JOBID JOBS.JOB_ID%TYPE) IS 
  BEGIN 
    DELETE FROM JOBS 
    WHERE JOB_ID = P_JOBID; 
    
    IF SQL%NOTFOUND THEN 
      RAISE_APPLICATION_ERROR(-20203, 'No jobs deleted.'); 
    END IF; 
  END DEL_JOB; 
  -- GET_JOB �Լ��� id�� �޾� �ش��ϴ� title ��ȯ
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

-- ���Ͻ��� ȣ��
EXECUTE JOB_PKG.ADD_JOB('IT_ADMIN','DATA ADMIN') ;  
SELECT * FROM JOBS ; 
EXECUTE JOB_PKG.UPD_JOB('IT_ADMIN','Ddatabase Administrator') ; 
SELECT * FROM JOBS ; 
EXECUTE JOB_PKG.DEL_JOB('IT_ADMIN') ; 
SELECT * FROM JOBS ;


/*
https://docs.oracle.com/database/121/TDDDG/tdddg_triggers.htm#TDDDG50000
Ʈ����
- ���� �߻��� �ڵ� ����
- DML, DDL ��
����
-�ܼ�Ʈ����
 - before
 - after
 - instead of  �信 ���
-ȥ��

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

-- ��Ʈ����
CREATE OR REPLACE TRIGGER logt_emp   
  BEFORE INSERT OR DELETE OR UPDATE ON emp
  FOR EACH ROW      -- �� Ʈ����
BEGIN
  INSERT INTO logt(username,event_date,empno,sal)
  VALUES (user,sysdate,:NEW.empno, :NEW.sal) ; 
END ;
/

UPDATE emp 
SET sal = sal * 1.1 
WHERE deptno = 20 ; 

-- ���� Ʈ���� (�⺻��)
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

-- old Ʈ���� ó���� �� ���� ��
-- new �� ��

/*
Ʈ���� ����
Enabled 
Disabled 
*/
ALTER TRIGGER Ʈ�����̸� DISABLE | ENABLE;
ALTER TABLE ���̺��̸� DIABLE | ENABLE ALL TRIGGERS;
ALTER TRIGGER Ʈ�����̸� COMPILE;  -- ������ Ʈ���� �ֱ�
DROP TRIGGER Ʈ�����̸�;   -- Ʈ���� ����

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
�����Ͻ� �ؽ�Ʈ�� ����, ����� ����
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
Native Dynamic SQL ���

SQL ��ɹ��� ó�� ���� 
1. PARSE : ���� ��ȹ Ȯ�� 
2. BIND  : ���ε� ������ �� �Է� 
3. EXECUTE : ���� 
4. FETCH : select ��ɹ���, �˻� ��� ���� 

���� �� ����
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
     EXECUTE IMMEDIATE      -- select�� ���� �� �ᵵ��,
     'select /* test3 */ count(*) 
     from emp 
     where empno = :1' INTO v_cnt USING i ;   -- using ���� ��ȹ ����� ���ϰ�
  END LOOP ;
END ;
/
