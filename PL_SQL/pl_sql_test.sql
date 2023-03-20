begin
  update emp
    set sal = sal *1.1
  where empno =7788;
end;
/

rollback;

set serveroutput on;  -- DBMS_OUTPUT �����ϰ�

BEGIN
  DBMS_OUTPUT.put_Line('nowuk'); 
END;
/       -- �� �� ǥ�� / 

DECLARE 
amount INTEGER(10); 
BEGIN 
DBMS_OUTPUT.PUT_LINE(amount); 
END;
/


DECLARE               -- ���� ����
  v_hiredate 	DATE ;
  v_deptno 	  NUMBER(2) NOT NULL 	default 10;       -- NOT NULL�̸� �ʱⰪ �ʼ�
  v_location 	VARCHAR2(13) 		    := 'Atlanta';
  c_comm 	    CONSTANT NUMBER 	  := 1400 ;         -- CONSTANT ���, ������
BEGIN 
  DBMS_OUTPUT.PUT_LINE ( v_hiredate ) ; 
  DBMS_OUTPUT.PUT_LINE ( v_deptno ) ; 
  DBMS_OUTPUT.PUT_LINE ( v_location ) ; 
  DBMS_OUTPUT.PUT_LINE ( c_comm ) ; 
END ; 
/

/* 
  PL/SQL ����
- ��Į��	���ϰ�
- ����	������ġ ����Ű�� ������ ��
- LOB	���� ��ü�� ��ġ�� �����ϴ� ��ġ�ڶ�� ��
- ����	PL/SQL �÷��ǰ� ���ڵ� ������ ���� ���

��Į�� ������ Ÿ�� ��
number(2,4) �� �ִ� 0.0099
number(4,-1)�� �ִ� 99990.0
BINARY_INTEGER ���� PLS_INTEGER �� �� ����
*/

/*
���� �Ӽ�
%TYPE
*/
DECLARE 
  V_ENAME  EMP.ENAME%TYPE ; 
BEGIN 
  SELECT EMPNO, ENAME
    FROM EMP
END;
/

/*
��PL/SQL ����: ���ε� ����
VARIABLE �� ����
: �� ���� (ȣ��Ʈ ���� ǥ��)
PRINT ����
*/
VARIABLE B_SAL  NUMBER

BEGIN 
  SELECT SAL INTO :B_SAL 
  FROM EMP 
  WHERE EMPNO = 7788 ;
END;
/
PRINT B_SAL


/*
����Į ���� - ����� ����, �ĺ���,������,���ͷ�,�ּ�

���ν��������� DECODE, �׷��Լ�(�ܵ�) ��� �Ұ�

��ø��Ͽ��� ���� ������ �������� ��밡��, ������� ����� ���� ������ �����
<<���̺��̸�>> ���� ���̺� ����
��������  ���̺��̸�.����  ���
*/
BEGIN <<outer>>
DECLARE
 v_father_name VARCHAR2(20):='Patrick';
 v_date_of_birth DATE:='1972-04-20';
BEGIN
 DECLARE
 v_child_name VARCHAR2(20):='Mike';
 v_date_of_birth DATE:='2002-12-12'; 
BEGIN
  DBMS_OUTPUT.PUT_LINE('Father''s Name: ' ||v_father_name);
  DBMS_OUTPUT.PUT_LINE('Date of Birth: ' ||outer.v_date_of_birth);
  DBMS_OUTPUT.PUT_LINE('Child''s Name: ' ||v_child_name);
  DBMS_OUTPUT.PUT_LINE('Date of Birth: ' ||v_date_of_birth);
 END;
END;
END outer;

--ex)
DECLARE
  weight NUMBER(3) := 600;
  message VARCHAR2(255) := 'Product 10012';
BEGIN
  DECLARE
    weight NUMBER(3) := 1;
    message VARCHAR2(255) := 'Product 11001';
    new_locn VARCHAR2(50) := 'Europe';
  BEGIN
    weight := weight + 1;
    new_locn := 'Western ' || new_locn;
  END;
  weight := weight + 1;
  message := message || ' is in stock';
  new_locn := 'Western ' || new_locn;
END;
/


DECLARE
  v_basic_percent NUMBER:=45/100;
  v_pf_percent NUMBER:=12/100;
  v_fname VARCHAR2(15);
  v_emp_sal NUMBER(10);
BEGIN 
  SELECT first_name, salary 
  INTO v_fname, v_emp_sal
  FROM employees 
  WHERE employee_id=110;
    DBMS_OUTPUT.PUT_LINE('Hello '|| v_fname);
    DBMS_OUTPUT.PUT_LINE('YOUR SALARY IS : '|| v_emp_sal);
    DBMS_OUTPUT.PUT_LINE('YOUR CONTRIBUTION TOWARDS PF: ' || v_emp_sal * v_basic_percent * v_pf_percent); 
END;
/

-- sp (server process)
/*
��ɹ� I,U,D �� �޸� select�� ������ �޾ƾ���(INTO �� ��) 
INTO�� �����ุ ������ ��ȯ �ؾ���
DDL(C,A,D,T),DCL(G,R) �� ����� ���� sql ���, ���� ����x
*/
BEGIN 
  UPDATE EMP 
  SET SAL = 5000
  WHERE EMPNO = 7788 ; 
END ; 
/ 
SELECT * 
FROM EMP 
WHERE EMPNO = 7788 ; 

rollback;

select count(*) from tacct;
select * from tacct;

-- F10 �����ȹ
/*
cursor ������� �����ϴ� ���� �޸� ����
sql%found ��ȯ ����, �ο�Ӽ�
sql%rowcount ���� ���� ���
*/
IF SQL%FOUND THEN 
  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT ||' row updated'); 
 END IF ;

declare 
  max_deptno number;
begin
  select max(department_id)
  into max_deptno
  from departments;
  DBMS_OUTPUT.PUT_LINE(max_deptno);
end;
/
-- BULK COLLECT INTO ������ ���� ���� �� �ѹ��� ���ε� 
select *
  from departments;

DECLARE
  v_max_deptno NUMBER;
  v_dept_name departments.department_name%TYPE := 'Education';
  v_dept_id NUMBER;
BEGIN
  SELECT MAX(department_id) 
  INTO v_max_deptno 
  FROM departments;
  v_dept_id := 10 + v_max_deptno;
  
  INSERT INTO departments (department_id, department_name, location_id)
  VALUES (v_dept_id, v_dept_name, NULL);
  
  DBMS_OUTPUT.PUT_LINE (' SQL%ROWCOUNT gives ' || SQL%ROWCOUNT);
END;
/
SELECT * 
FROM departments;


/*
if �� null ���� else ��
*/

-- &,: �Է°� �ִ� â ����, &�� ġȯ����, :�� ���ε庯��
-- &CONDITION  
DECLARE
  v_grade CHAR(1) := UPPER('&grade'); 
  v_appraisal VARCHAR2(20);
BEGIN
  v_appraisal := CASE v_grade 
    WHEN 'A' THEN 'Excellent'
    WHEN 'B' THEN 'Very Good'
    WHEN 'C' THEN 'Good'
    ELSE 'No such grade'
  END ;
DBMS_OUTPUT.PUT_LINE ('Grade: '|| v_grade || ' Appraisal ' || v_appraisal);
END;
/
-- case ���̸� end case; �� ��
-- then���� ���� �ƴ� �۾��� ������ ��

/*
������ null �Ұ�
LOOP ��� 1���� ����
WHILE ���� LOOP 
*/
DECLARE
   v_countryid locations.country_id%TYPE := 'CA';
   v_loc_id locations.location_id%TYPE;
   v_counter NUMBER(2) := 1;
   v_new_city locations.city%TYPE := 'Montreal';
BEGIN
  SELECT MAX(location_id)
  INTO v_loc_id 
  FROM locations
  WHERE country_id = v_countryid;
  
  LOOP
    INSERT INTO locations
      (location_id, city, country_id) 
    VALUES((v_loc_id + v_counter), v_new_city, v_countryid);
   v_counter := v_counter + 1;
   EXIT WHEN v_counter > 3;
   END LOOP;
   
   /*
   WHILE v_counter <= 3 LOOP
    INSERT INTO locations
      (location_id, city, country_id) 
    VALUES((v_loc_id + v_counter), v_new_city, v_countryid);
   v_counter := v_counter + 1;
   END LOOP;
  */
  
  /*
  FOR I IN [REVERSE] 1..3 LOOP  -- ������ �� 321
   INSERT INTO locations
    (location_id, city, country_id)
   VALUES((v_loc_id+i), v_new_city, v_countryid));
  END LOOP;
  
for ���� I�� ��� �Ұ�
  */
END;
/

/*
��ø LOOP ���ο��� �ܺθ� ���� ����
<<���̺��̸�>>
*/
DECLARE 
  x	NUMBER := 3 ;
  y	NUMBER ;
BEGIN 
  <<OUTER_LOOP>> LOOP
    y := 1 ;
    EXIT WHEN x > 5 ; 
    <<INNER_LOOP>> LOOP 
      DBMS_OUTPUT.PUT_LINE ( x || ' * ' || y || ' = ' || x * y ) ;
      EXIT OUTER_LOOP WHEN x*y > 15 ;
      y := y + 1 ; 
      EXIT WHEN y > 5 ; 
    END LOOP INNER_LOOP ; 
    x := x + 1 ; 
  END LOOP OUTER_LOOP ; 
END ;
/

create table messages(result number);
select * from messages;


/*
Q1
�ѱ��ſ��򰡿��� 'AA' ����� �򰡸� �ް� 2000�� ���� ������ ���� ���ְ� ������ ���� ���� ������ �˻��ϼ���.
���̺�	: TACCT (��������), TID (��������), TCREDIT (�ſ�������) ��� 
�˻�		: lnact, lnact_seq, branch, lnid, ln_dt, exp_dt, ln_amt
����1	: ���� ���� (tacct.lmt_typ IS NULL)
����2	: 2000�� ���� ������ ���� (tid.bthday >= TO_DATE('2000/01/01','YYYY/MM/DD'))
����3	: �ѱ��ſ��� (tcredit.acode = '01') 
����4	: 'AA' ��� (tcredit.code = '03') 
����		: ���¹�ȣ(lnact), �����Ϸù�ȣ(lnact_seq) ���� �������� 
LNID ���� ����
Q2
'AA' ����� �򰡸� �ް� 2000�� ���� ������ ���� ���ְ� ������ ���� ���� ������ �˻��ϼ���.
���̺�	: TACCT (��������), TID (��������), TCREDIT (�ſ�������) ��� 
�˻�		: lnact, lnact_seq, branch, lnid, ln_dt, exp_dt, ln_amt
����1	: ���� ���� (tacct.lmt_typ IS NULL)
����2	: 2000�� ���� ������ ���� (tid.bthday >= TO_DATE('2000/01/01','YYYY/MM/DD'))
����3	: 'AA' ��� (tcredit.code = '03') 
����		: ���¹�ȣ(lnact), �����Ϸù�ȣ(lnact_seq) ���� �������� 
*/

--Q1
SELECT TACCT.LNACT, 
      TACCT.LNACT_SEQ, 
      TACCT.BRANCH, 
      TACCT.LNID, 
      TACCT.LN_DT, 
      TACCT.EXP_DT, 
      TACCT.LN_AMT
FROM TCREDIT, TID, TACCT
WHERE TCREDIT.LNID = TID.LNID
  AND TID.LNID = TACCT.LNID
  AND TACCT.LMT_TYP IS NULL
  AND TID.BTHDAY >= TO_DATE('2000/01/01','YYYY/MM/DD')
  AND TCREDIT.ACODE = '01'
  AND TCREDIT.CODE = '03'
ORDER BY LNACT, LNACT_SEQ;

--Q2
SELECT TACCT.LNACT, 
      TACCT.LNACT_SEQ, 
      TACCT.BRANCH, 
      TACCT.LNID, 
      TACCT.LN_DT, 
      TACCT.EXP_DT, 
      TACCT.LN_AMT
FROM TCREDIT, TID, TACCT
WHERE TCREDIT.LNID = TID.LNID
  AND TID.LNID = TACCT.LNID
  AND TACCT.LMT_TYP IS NULL
  AND TID.BTHDAY >= TO_DATE('2000/01/01','YYYY/MM/DD')
  AND TCREDIT.CODE = '03'
ORDER BY LNACT, LNACT_SEQ;
