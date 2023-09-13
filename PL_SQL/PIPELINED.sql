/*
파이프라인 
- 결과 집합이 모두 생성될 때까지 기다리지 않고 완료된 부분을 순차적으로 처리하므로 응답 시간이 빠름
- 하나의 연산을 종료하지 않고 일련의 연산을 순차적으로 반복 처리
- 여러 연산을 연속해서 수행
- SQL 문장으로 표현하기 어려운 과정을 유연하게 처리


Object 타입, 테이블 타입을 정의하여, 파이프라인 테이블 함수 생성 시에 사용
*/

-- Object 타입 생성
-- 함수에서 반환하는 레코드의 스키마를 정의
CREATE OR REPLACE TYPE OBJ_STORE AS OBJECT (
    USER_NUM NUMBER(10)
  , USER_NM VARCHAR2(20)
  , STORE_NUM NUMBER(10)
  , STORE_NM VARCHAR2(50) 
  , STORE_ADDR VARCHAR2(30)
);


-- 테이블 타입 정의
-- 함수에서 반환하는 레코드의 집합(테이블) 정의
CREATE OR REPLACE TYPE TABLE_STORE AS TABLE OF OBJ_STORE;


-- 파이프라인 테이블 함수 작성
-- RETURN 타입은 위의 테이블 타입으로 지정
-- 변수는 위의 Object 타입으로 지정
/*
CREATE OR REPLACE FUNCTION [함수명] ([파라미터명] [파라미터타입])
    RETURN [리턴타입] PIPELINED
IS
    [변수명] [변수타입]
BEGIN
    (생략)
    RETURN;
END;
*/
-- ex
CREATE OR REPLACE FUNCTION fn_get_store_info (p_user_num NUMBER)
    RETURN TABLE_STORE PIPELINED
IS
    v_obj_store OBJ_STORE;
BEGIN 
    FOR v_row IN (
        SELECT 
            U.USER_NUM
          , fn_get_user_nm(U.USER_NUM) AS USER_NM
          , S.STORE_NUM
          , S.STORE_NM
          , S.STORE_ADDR
        FROM USER_INFO U
        INNER JOIN STORE_INFO S
        ON U.USER_NUM = S.OWNER_NUM
        WHERE U.USER_NUM = p_user_num
    ) LOOP
        v_obj_store := OBJ_STORE(v_row.USER_NUM, v_row.USER_NM, v_row.STORE_NUM, v_row.STORE_NM, v_row.STORE_ADDR);
        PIPE ROW(v_obj_store);
    END LOOP;
    RETURN;
END;
/

  
-- 파이프라인 테이블 함수 사용
SELECT * FROM TABLE(fn_get_store_info(1));
-- 함수 조회
SELECT * FROM USER_SOURCE WHERE TYPE = 'FUNCTION';
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION';
-- 삭제
DROP FUNCTION [함수명];






