/*
PL(Procedural Language) 절차형 언어

종류
PROCEDURE, TRIGGER, USER DEFINED FUNCTION
 
 
 @@@기본 문법
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


--기본 문법 ex
CREATE OR REPLACE Procedure 이름 
  (매개변수1 IN NUMBER,
   매개변수2 OUT VARCHAR2)
IS [AS]

BEGIN
  SELECT COUNT(*) INTO CNT
  FROM DEPT
  WHERE DEPTNO = 매개변수1;
  if cnt > 0 then
    매개변수2 := '이미 등록된 부서번호이다';
  else
    INSERT INTO DEPT (NUMBER)
    VALUES (매개변수1); 
    COMMIT;
    매개변수2 := '입력 완료!!';
  end if; 
EXCEPTION
  WHEN OTHERS THEN
ROLLBACK;
v_result := 'ERROR 발생';
  에러시 실행
END;
/


-- 활용
variable 이름1 varchar2(30);    -- 결과 받을 변수 선언
EXECUTE Procedure_이름(10, 'seoul', :이름1);
PRINT 이름1;    -- 확인
