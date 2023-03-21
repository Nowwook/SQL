/*
���յ�����
�ϳ� �̻��� �ʵ带 ���� ����
Record
Collection

*/
-- ���ڵ� ��
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
-- ��ü�� ����
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
����� Ŀ��
*/
DECLARE 
  emp_rec	emp%ROWTYPE ; 
BEGIN 
  SELECT * INTO emp_rec         -- ���� ���� ����
  FROM emp
  WHERE deptno = 10 ;

  DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 
END ;
/

DECLARE 
  CURSOR emp_cur IS         -- Ŀ�� ����
    SELECT * FROM emp WHERE deptno = 10 ; 
  emp_rec	emp%ROWTYPE ; 
BEGIN 
  OPEN emp_cur ;        -- ���� �� 

--  FETCH emp_cur INTO emp_rec ;     -- ���� ���� ������ �ε�
--  DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 
--
--  FETCH emp_cur INTO emp_rec ;      -- ���� ���ϸ� ���� ��ŭ �ۼ�
--  DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 

  LOOP 
    FETCH emp_cur INTO emp_rec ; 
    EXIT WHEN emp_cur%NOTFOUND ;        -- ���� ���� ��
    DBMS_OUTPUT.PUT_LINE ( emp_rec.empno || ' ' || emp_rec.ename ) ; 
  END LOOP ; 
  
  CLOSE emp_cur ;     -- ��� �� ���� ����
END ;
/

/*
Ŀ�� FOR LOOP
- OPEN, FETCH, END, CLOSE �۾��� �Ͻ������� �߻�
- RECORD�� �Ͻ������� ����
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
����� Ŀ�� �Ӽ�
%ISOPEN - Ŀ���� ���� ������ TRUE�� ��, if �� Ȯ�� ����
%NOTFOUND - ���� �ֱ� ��ġ(fetch)�� ���� ��ȯ���� ������ TRUE�� ��
%FOUND - ���� �ֱ� ��ġ(fetch)�� ���� ��ȯ�ϸ� TRUE�� ��
%ROWCOUNT - ���ݱ��� ��ȯ�� �� �� ���� ��
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
����ó�� Exception
���ϳ��� �۾� �߰��� �������� ��ü�۾� ���, ���ܽ� �������� �� �۾��� �����ϰ� ���� ����
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

-- ���� ���
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
 ���� ���� ���� Ʈ��
*/

BEGIN
  UPDATE dept
  SET dname = 'Testing' 
  WHERE deptno = 50 ;

  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR ( -20001, 'No such department id.',true ) ; 
    -- ���� ������ ���� �ڵ� ���, true ���� �ڵ嵵 ������, false �ȳ�����
    -- -20000 ~ 20999 ����
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
�͸���                              ���ν���
�̸��� �������� ���� PL/SQL ���        ���� PL/SQL ���
�Ź� ������                           �� ���� ������ ��
�����ͺ��̽� ������� ����              �����ͺ��̽��� �����
�ٸ� ���� ���α׷����� ȣ�� �� ������    �̸��� �����Ƿ� �ٸ� ���� ���α׷����� ȣ���� �� ����
���� ��ȯ���� ����                     �Լ��� ���� ��ȯ�ؾ� ��
�Ķ���͸� ����� �� ����               �Ķ���͸� ����� �� ����
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
-- �⺻�� ������
EXECUTE proc1(1,B);      -- ��ġ ���� ���   
EXECUTE proc1 (p3 => B); -- �̸� ���� ���
-- ���� �� �� ��ġ���� ������ ����
