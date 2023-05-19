-- 링크 만들기         ↓(링크이름)
CREATE DATABASE LINK MOVE_DB_LK CONNECT TO 아이디 IDENTIFIED BY 비번 USING
'(DESCRIPTION =
  (ADDRESS_LIST =
    (ADDRESS = 
      (PROTOCOL = TCP)
      (HOST = 192.168.주소)
      (PORT = 포트)
    )
  )
  (CONNECT_DATA =
    (SID = orcl)
  )
)';

-- 테이블 조회로 링크 접속확인
SELECT * FROM TB_BASE@MOVE_DB_LK;

-- 링크 삭제         ↓(링크이름)
DROP DATABASE LINK MOVE_DB_LK;

create table Move_L AS SELECT * FROM TB_BASE WHERE 1=2; -- 구조복사
--DROP TABLE Move_L;

-- 빈 테이블에 넣기
INSERT INTO Move_L
(
    SELECT * FROM TB_BASE@MOVE_DB_LK
);

SELECT * FROM ALL_DB_LINKS;   -- 모든 링크 보기
EXECUTE IMMEDIATE 'ALTER SESSION CLOSE DATABASE LINK MOVE_DB_LK'; -- MOVE_DB_LK 링크 닫기

-- 없는 데이터만 복사
INSERT INTO TB_BASE (A, B)
SELECT                        b.A, b.B
FROM Move_L b
LEFT JOIN TB_BASE a ON a.A = b.A
WHERE a.A IS NULL;

SELECT ML.A, ML.B
FROM MOVE_L ML
WHERE NOT EXISTS (
  SELECT 1
  FROM TB_BASE BD
  WHERE BD.A = ML.A )
