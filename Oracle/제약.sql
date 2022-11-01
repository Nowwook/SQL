# 제약
# UNIQUE, PRIMARY KEY, FOREIGN KEY

# 테이블 생성 제약
CREATE TABLE TALBE_NOT
(   LOGIN_ID VARCHAR2(20) NOT NULL,
    LOGIN_PWD VARCHAR2(20) NOT NULL,
    TEL       VARCHAR2(20)
    );
SELECT *FROM TALBE_NOT;    # (값 넣기 전까지 오류)

INSERT INTO TALBE_NOT(LOGIN_ID,LOGIN_PWD)
VALUES('LOGIN_ID_01','1234');

UPDATE TALBE_NOT
SET LOGIN_PWD = NULL
WHERE LOGIN_ID ='LOGIN_ID_01';  # 오류

#####################
# SQL 2.0
SELECT OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME
FROM USER_CONSTRAINTS;

select * from locations;

# 제약조건 이름 지정
CREATE TABLE TABLE_NOTNULL2
(   login_it    VARCHAR2(20) CONSTRAINT tblnn2_lgnid_nn NOT NULL,
    login_pwd   VARCHAR2(20) CONSTRAINT tblnn2_lgnpwd_nn NOT NULL,
    tel         VARCHAR2(20)
);

# 이미 지정된 제약조건 추가 ,수정
# 추가
SELECT * FROM TALBE_NOT;

ALTER TABLE TALBE_NOT
MODIFY(TEL NOT NULL);

# NULL 제거
UPDATE TALBE_NOT
SET TEL = '010-1234-5678'
WHERE login_id = 'LOGIN_ID_01';

# 이름지정 후 수정
ALTER TABLE TABLE_NOTNULL2
MODIFY(tel constraint tblnn_tel_nn NOT NULL);

select owner,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME
from user_CONSTRAINTs;

# 테이블 구조 확인
DESC table_notnull2;

# 이미 이름이 생성된 제약조건 이름변경
ALTER TABLE table_notnull2
RENAME CONSTRAINT tblnn_tel_nn TO tblnn2_tel_nn; 

# 제약조건 삭제
ALTER TABLE table_notnull2
DROP CONSTRAINT TBLNN2_TEL_NN;

# NOT NULL 제약조건 추가
ALTER TABLE table_notnull2
MODIFY(TEL CONSTRAINT MY_01 NOT NULL);

# UNIQUE
create table table_unique
(   login_id    varchar2(20) unique,
    login_pwd   varchar2(20) not null,
    tel         varchar2(20)
);    

desc table_unique;

select*from table_pk;
insert into table_unique
values (null,'pwd','010-1234');

# PRIMARY KEY
create table table_pk
(   login_id    varchar2(20) constraint my_1 primary key,
    login_pwd   varchar2(20) constraint my_2 not null,
    tel         varchar2(20)
);

drop table table_pk;

# 생성한 기본키 확인
select owner,CONSTRAINT_name, CONSTRAINT_type,table_name
from user_CONSTRAINts
where table_name like 'TABLE_PK%';

insert into table_pk
values ('id','pwd','010-1234');



# 한발더 나가기
CREATE TABLE table_ppk
(   login_id    VARCHAR2(20),
    login_pwd   VARCHAR2(20),
    tel         VARCHAR2(20),
    PRIMARY KEY(login_id),
    CONSTRAINT my_10 UNIQUE(login_pwd)
);

select owner,CONSTRAINT_name, CONSTRAINT_type,table_name
from user_CONSTRAINts
where table_name LIKE '%CHECK%';

select*from emp;
desc emp;

#
INSERT INTO EMP(EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
VALUES(9999,'길동','CLERK','7788', TO_DATE('2017-04-03','YYYY/MM/DD'),1200,NULL,30);
DELETE FROM EMP WHERE EMPNO=9999;
COMMIT;

CREATE TABLE DEPT_FK(
    DEPTNO    NUMBER(2) CONSTRAINT DEPTNO_FK PRIMARY KEY,
    DNAME   VARCHAR2(14),
    LOC     VARCHAR2(13)
);

CREATE TABLE EMP_FK(
    EPTNO    NUMBER(4) CONSTRAINT EMP_DEPTNO_FK PRIMARY KEY,
    ENAME    VARCHAR(10),
    JOB      VARCHAR(9),
    MGR      NUMBER(4),
    HIREDATE DATE,
    SAL      NUMBER(7,2),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2) CONSTRAINT EMP_FK REFERENCES DEPT_FK(DEPTNO) ON DELETE CASCADE
);

select*from EMP_FK;
select*from DEPT_FK;

DROP TABLE EMP_CHECK;

insert into DEPT_Fk
values (10,'길D동','CLERK');
insert into EMP_Fk
values (9999,'길D동','CLERK','7788', TO_DATE('2017-04-03','YYYY/MM/DD'),1200,NULL,10);

DELETE FROM DEPT_Fk
WHERE DEPTNO=10;

CREATE TABLE EMP_FK(
    EPTNO    NUMBER(4) CONSTRAINT EMP_DEPTNO_FK PRIMARY KEY,
    ENAME    VARCHAR(10),
    JOB      VARCHAR(9),
    MGR      NUMBER(4),
    HIREDATE DATE,
    SAL      NUMBER(7,2),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2) CONSTRAINT EMP_FK REFERENCES DEPT_FK(DEPTNO) ON DELETE SET NULL
);

# ON DELETE CASCADE 참조 된거 같이 삭제
# ON DELETE SET NULL 삭제시 참조값 NULL
 
# 데이터 범위, 형태 지정 CHECK
CREATE TABLE EMP_CHECK
(   login_id    VARCHAR2(20) CONSTRAINT CHECK_ID PRIMARY KEY,
    login_pwd   VARCHAR2(20) CONSTRAINT CHECK_PWD CHECK(LENGTH(LOGIN_PWD) > 3),
    tel         VARCHAR2(20) DEFAULT '123456'
);    
select*from EMP_CHECK;

insert into EMP_CHECK
values ('4','123456789',NULL);

#1
CREATE TABLE DEPT_CONST
(   DEPTNO    NUMBER(2) CONSTRAINT DEPT_PK PRIMARY KEY,
    DNAME     VARCHAR2(14) CONSTRAINT DEPT_UNQ UNIQUE,
    LOC       VARCHAR2(13) CONSTRAINT DEPT_NN NOT NULL
); 
CREATE TABLE EMP_CONST
(   EMPTNO    NUMBER(4) CONSTRAINT EMP_PK1 PRIMARY KEY,
    ENAME    VARCHAR(10)CONSTRAINT EMP_NN1 NOT NULL,
    JOB      VARCHAR(9),
    TEL     VARCHAR2(20)CONSTRAINT EMP_UNQ1 UNIQUE,
    HIREDATE DATE,
    SAL      NUMBER(7,2)CONSTRAINT EMP_CHK1 CHECK(SAL >=1000 AND SAL <=9999),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2) CONSTRAINT EMP_FK1 REFERENCES DEPT_CONST(DEPTNO)
);
select owner,CONSTRAINT_name, CONSTRAINT_type,table_name
from user_CONSTRAINts
WHERE table_name LIKE '%CONST';
