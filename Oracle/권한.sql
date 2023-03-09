# 사용자 만들기
CREATE USER ORCLSTUDY IDENTIFIED BY ORACLE;

# 권한 부여
#GRANT CREATE SESSION TO ORCLSTUDY;
# 계정에 권한 부여
GRANT CREATE SYNONYM TO hr;
GRANT CREATE PUBLIC SYNONYM TO hr;

# 모든 사용자 조회
SELECT *FROM ALL_USERS;
SELECT *FROM DBA_USERS;
SELECT *FROM DBA_OBJECTS;

# PL/SQL 기초
#SET SERVEROUTPUT ON;
#BEGIN
#    DBMS_OUTPUT.PUT_LINE('HELLO,PL/SQL')
#END;    

select * from EMP ;


CREATE USER 계정이름 IDENTIFIED BY PASSWORD;    -- 계정 생성
GRANT CONNECT, RESOURCE TO 계정이름;            -- grant 부여할 권한 to 계정이름
REVOKE CONNECT, RESOURCE FROM 계정이름;         -- revoke 제거할 권한 from 계정이름


-- 권한 그룹 
CREATE ROLE 롤_이름;           -- 롤 생성
GRANT CONNECT TO 롤_이름;      -- 롤에 권한 부여
GRANT 롤_이름 TO 계정이름;      -- 롤에 계정 넣기
