begin
  update emp
    set sal = sal *1.1
  where empno =7788;
end;
/

rollback;

set serveroutput on;  -- DBMS_OUTPUT 가능하게

BEGIN
  DBMS_OUTPUT.put_Line('nowuk'); 
END;
/       -- 블럭 끝 표시 / 

DECLARE 
amount INTEGER(10); 
BEGIN 
DBMS_OUTPUT.PUT_LINE(amount); 
END;
/


DECLARE               -- 변수 선언
  v_hiredate 	DATE ;
  v_deptno 	  NUMBER(2) NOT NULL 	default 10;       -- NOT NULL이면 초기값 필수
  v_location 	VARCHAR2(13) 		    := 'Atlanta';
  c_comm 	    CONSTANT NUMBER 	  := 1400 ;         -- CONSTANT 상수, 값고정
BEGIN 
  DBMS_OUTPUT.PUT_LINE ( v_hiredate ) ; 
  DBMS_OUTPUT.PUT_LINE ( v_deptno ) ; 
  DBMS_OUTPUT.PUT_LINE ( v_location ) ; 
  DBMS_OUTPUT.PUT_LINE ( c_comm ) ; 
END ; 
/

/* 
  PL/SQL 변수
- 스칼라	단일값
- 참조	저장위치 가르키는 포인터 값
- LOB	대형 객체의 위치를 지정하는 위치자라는 값
- 조합	PL/SQL 컬렉션과 레코드 변수를 통해 사용

스칼라 데이터 타입 팁
number(2,4) 의 최댓값 0.0099
number(4,-1)의 최댓값 99990.0
BINARY_INTEGER 보다 PLS_INTEGER 가 더 빠름
*/

/*
참조 속성
%TYPE
*/
DECLARE 
  V_ENAME  EMP.ENAME%TYPE ;   -- emp의 ename 과 같은 타입
BEGIN 
  SELECT EMPNO, ENAME
    FROM EMP
END;
/

/*
비PL/SQL 변수: 바인드 변수
VARIABLE 로 생성
: 로 참조 (호스트 변수 표시)
PRINT 가능
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
렉시칼 단위 - 블록의 구조, 식별자,구분자,리터럴,주석

프로시저문에서 DECODE, 그룹함수(단독) 사용 불가

중첩블록에서 상위 변수는 하위에서 사용가능, 하위블록 종료시 내부 변수도 사라짐
<<레이블이름>> 으로 레이블 가능
하위에서  레이블이름.변수  사용
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
명령문 I,U,D 와 달리 select는 변수를 받아야함(INTO 로 받) 
INTO는 단일행만 무조건 반환 해야함
DDL(C,A,D,T),DCL(G,R) 은 실행시 동적 sql 사용, 직접 실행x
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

-- F10 실행계획
/*
cursor 결과값을 저장하는 전용 메모리 공간
sql%found 반환 유무, 부울속성
sql%rowcount 영향 받은 행수
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
-- BULK COLLECT INTO 데이터 양이 많을 때 한번에 바인딩 
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
if 시 null 값은 else 쪽
*/

-- &,: 입력값 넣는 창 나옴, &은 치환변수, :은 바인드변수
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
-- case 문이면 end case; 로 끝
-- then에서 값이 아닌 작업이 있으면 문

/*
범위에 null 불가
LOOP 적어도 1번은 실행
WHILE 조건 LOOP 
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
  FOR I IN [REVERSE] 1..3 LOOP  -- 리버스 시 321
   INSERT INTO locations
    (location_id, city, country_id)
   VALUES((v_loc_id+i), v_new_city, v_countryid));
  END LOOP;
  
for 안의 I는 출력 불가
  */
END;
/

/*
중첩 LOOP 내부에서 외부만 종료 가능
<<레이블이름>>
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
한국신용평가에서 'AA' 등급의 평가를 받고 2000년 이후 설립된 법인 차주가 개설한 대출 계좌 정보를 검색하세요.
테이블	: TACCT (계좌정보), TID (차주정보), TCREDIT (신용등급정보) 사용 
검색		: lnact, lnact_seq, branch, lnid, ln_dt, exp_dt, ln_amt
조건1	: 대출 계좌 (tacct.lmt_typ IS NULL)
조건2	: 2000년 이후 설립된 차주 (tid.bthday >= TO_DATE('2000/01/01','YYYY/MM/DD'))
조건3	: 한국신용평가 (tcredit.acode = '01') 
조건4	: 'AA' 등급 (tcredit.code = '03') 
정렬		: 계좌번호(lnact), 계좌일련번호(lnact_seq) 기준 오름차순 
LNID 으로 조인

*/

-- 일반적인 풀이, 중복제거,조인 느림
SELECT DISTINCT
      TACCT.LNACT, 
      TACCT.LNACT_SEQ, 
      TACCT.BRANCH, 
      TACCT.LNID, 
      TACCT.LN_DT, 
      TACCT.EXP_DT, 
      TACCT.LN_AMT
FROM TCREDIT, TID, TACCT
WHERE TCREDIT.LNID = TID.LNID AND TID.LNID = TACCT.LNID
  AND TACCT.LMT_TYP IS NULL
  AND TID.BTHDAY >= TO_DATE('2000/01/01','YYYY/MM/DD')
  AND TCREDIT.ACODE = '01'
  AND TCREDIT.CODE = '03'
ORDER BY LNACT, LNACT_SEQ;

-- 서브쿼리 사용, 좀 더 정확
SELECT LNACT, LNACT_SEQ, BRANCH, LNID, LN_DT, EXP_DT, LN_AMT
  FROM TACCT 
 WHERE LMT_TYP IS NULL
   AND LNID IN (SELECT LNID 
                  FROM TID 
                 WHERE BTHDAY >= TO_DATE('2000/01/01','YYYY/MM/DD')
                   AND LNID IN (SELECT LNID 
                                  FROM TCREDIT 
                                 WHERE ACODE = '01' 
                                   AND CODE  = '03')) 
ORDER BY LNACT, LNACT_SEQ ;


-- 조인 (중복 제거 필요)
SELECT DISTINCT D.* 
  FROM EMP E, DEPT D 
 WHERE E.DEPTNO = D.DEPTNO ; 
-- 서브쿼리
SELECT *
  FROM DEPT 
 WHERE DEPTNO IN (SELECT DEPTNO FROM EMP) ;
