SELECT * from tab;
SELECT * from employees;

# 테이블 구성정보 살펴보기
DESC employees;

SELECT * from DEPARTMENTs;
# 타입 조회
DESC departents;

SELECT * from tab;
SELECT * from locations;
# employees 테이블에서 이름, 급여조회
SELECT first_name, salary from employees;
# 급여순 조회
SELECT first_name, salary from employees order by salary ;

SELECT employee_id, first_name, last_name, department_id 
        from employees 
        order by department_id desc ;

SELECT min_salary from jobs order by min_salary;
# 중복제거
SELECT distinct min_salary from jobs order by min_salary;

SELECT distinct employee_id from job_history;
#----------------------------------------

select *from dept;
INSERT INTO DEPT VALUES	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES	(40,'OPERATIONS','BOSTON');
DROP TABLE DEPT;

# 데이터 만들기
CREATE TABLE DEPT
(   DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14) ,
	LOC VARCHAR2(13) 
) ;
    
DROP TABLE EMP;

CREATE TABLE EMP
(   EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT
);

INSERT INTO DEPT VALUES	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES	(40,'OPERATIONS','BOSTON');
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy')-85,3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-1987','dd-mm-yyyy')-51,1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
DROP TABLE BONUS;

CREATE TABLE BONUS
(   ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
);

DROP TABLE SALGRADE;

CREATE TABLE SALGRADE
(   GRADE NUMBER,
    LOSAL NUMBER,
    HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;
    
DESC EMP;

SELECT distinct DEPTNO from EMP;
# all로 중복되는 열 제거없이 출력
SELECT all job, DEPTNO from EMP;

# 테이블에 연산식 컬럼 삽입
select ename 이름 ,sal "급여",sal*12+comm as 연봉,comm from emp;

select distinct job from emp;

# 조건의 where
select *from emp;
# 부서번호가 30번인 직원 출력
select * from emp where deptno =30;

# 특정 급여 받는 사람 찾기
select ename from emp where sal=950;
# 특정 업무, 부서번호 직원의 레코드(전체데이터), 내용은
select * from emp where job='SALESMAN'; AND DEPTNC=30;
# 사원번호가(EMPNO) 7499, 부서번호(DEPTNO) 30인 사원정보
SELECT * FROM EMP WHERE EMPNO=7499 AND DEPTNO=30;
select * from emp where job='SALESMAN' OR deptno=20;

# 사원 번호를 기준으로 내림차순 정렬
# 부서번호가 30번인 직원 데이터 모두를 출력
# 월급을 $950 받는 직원의 이름
# 사원번호(EMPNO)가 7499이고 부서번호(DEPTNO)가 30번인 사원 정보
# 부서번호 20번 이거나(or) 직업이 'SALESMAN'인 사원의 정보
select * from emp order by empno desc;
select * from emp where  deptno=30;
select ename from emp where  sal=950;
select * from emp where  deptno=30 and empno=7499;
select * from emp where  deptno=20 or job='SALESMAN';

# 산술 연산자를 사용한 예
select *from emp where sal >= 3000;
select *from emp where sal >= 2500 and job='ANALYST';

# 문자 대소비교 연산자 비교
select *from emp where ename <='B';
# 제외
select *from emp where sal!=3000;
select *from emp where sal <> 3000;
select *from emp where sal ^= 3000;
select *from emp where not sal = 3000;

# 지정된 조건에 맞는 데이터 찾기
# IN
select * from emp where job not in ('MANAGER','SALESMAN','CLERK');
select * from emp where job in ('MANAGER','SALESMAN','CLERK');
# between
select * from emp where 2000<=sal and sal<=3000; 
select * from emp where sal between 2000 and 3000; 
# like 문자열 검색
select * from emp where ename like 'S%';
select * from emp where ename like '_L%';
select * from emp where ename like '%AM%';
select * from emp where ename not like '%AM%';


# 등가비교 연산자 null 로 비교
select ename,sal,comm from emp where comm = NULL;   # = 틀림
select ename,sal,comm from emp where comm is NULL;  # is

# and 연산자와 is null 연산자
select * from emp where sal > null or comm is null;

# 집합 union
# 1
select ename,sal,comm from emp where deptno =10;
# 2
select ename,sal,comm from emp where deptno =20;
# 1 + 2     (같은거 2개 묶을땐 union all)
select ename,sal,comm from emp where deptno =10
union
select ename,sal,comm from emp where deptno =20;

# minus 집합 빼기
select ename,sal,comm from emp 
minus
select ename,sal,comm from emp where deptno=10;

# intersect 교집합
select empno,ename,sal,deptno from emp
intersect
select empno,ename,sal,deptno from emp where deptno=10;
