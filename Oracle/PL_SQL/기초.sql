/*
PL(Procedural Language) 절차형 언어

종류
PROCEDURE, USER DEFINED FUNCTION, TRIGGER
 
 
 @@@ PROCEDURE 기본 문법
DECLARE (선언부)
  PL/SQL에서 사용하는 모든 변수나 상수를 선언하는 부분으로서 DECLARE로 시작 => 변수/상수/커서 등 을 선언 

BEGIN (실행부)	(필수)
  절차적 형식으로 SQL문을 실행할수있도록 절차적 언어의 요소인 제어문, 반복문, 함수 정의 등 로직을 기술할수있는 부분

EXCEPTION (예외 처리부)
  PL/SQL문이 실행되는 중에 에러가 발생했을때 이를 해결하기 위한 문장을 기술할수있는 부분 

END (실행문 종료)  (필수)
 
 
 
쿼리문을 수행하기 위해서 '/'가 반드시 입력
PL/SQL 블록은 행에 '/'가 있으면 종결된것으로 간주

DBMS_OUTPUT.PUT_LINE(화면에 출력할 내용)

OR REPLACE 
  데이터베이스 내에 같은 이름의 프로시저가 있을 경우, 새로운 내용으로 덮어쓰기
*/


-- PROCEDURE ex
CREATE OR REPLACE Procedure 이름     -- 이름 선언
  (매개변수1 IN NUMBER,              -- IN,OUT,INOUT 변수 지정
   매개변수2 OUT VARCHAR2)
IS [AS]                             -- 변수 선언
CNT NUMBER := 0;
BEGIN                               -- 실행부
  SELECT COUNT(*) INTO CNT
  FROM DEPT
  WHERE DEPTNO = 매개변수1;
  if cnt > 0 then
    매개변수2 := '이미 등록된 번호';
  else
    INSERT INTO DEPT (DEPTNO)
           VALUES (매개변수1); 
    COMMIT;
    매개변수2 := '입력 완료!!';
  end if; 
EXCEPTION                         -- 예외
  WHEN OTHERS THEN
  ROLLBACK;                       -- 오류시 롤백
  매개변수2 := 'ERROR 발생';
END;
/


-- 활용
variable 이름1 varchar2(30);        -- 결과 받을 변수 선언
EXECUTE Procedure_이름(10, :이름1);  -- 실행
PRINT 이름1;    -- 확인



/*
USER DEFINED FUNCTION
RETURN을 사용해서 값을 반드시 리턴
*/

CREATE OR REPLACE Function 펑션이름
(in_값 IN NUMBER)
RETURN NUMBER
IS [AS]                    -- 변수 선언
out_값 NUMBER := 0;
BEGIN                      -- 실행부

EXCEPTION                  -- 예외

RETURN out_값;

END;
/

-- 실행
펑션이름(파라미터)


/*
TRIGGER
INSERT, UPDATE, DELETE와 같은 DML문이 수행되었을 때, 데이터베이스에서 자동으로 동작
행 트리거	- 데이터 변화가 생길 때마다 실행
문장 트리거	- 트리거에 의해 단 한 번 실행
트리거 내에서 TCL 사용 시 컴파일 에러
*/

CREATE OR REPLACE TRIGGER 트리거명
  (BEFORE | AFTER) (INSERT | DELETE | UPDATE) -- 이벤트 종류 
  ON 테이블명            --이벤트가 발생하는 테이블
  [FOR EACH ROW]        --실행될 문장 행에 각각 적용
  [WHEN 조건식]
  BEGIN
  --이벤트 발생시 실행할 문장(주로 DML) => 이벤트 처리부
  :new.컬럼명 -- 새로 입력(INSERT, UPDATE)된 데이터
  :old.컬럼명 -- 이미 저장되어있는 데이터
END;
/
