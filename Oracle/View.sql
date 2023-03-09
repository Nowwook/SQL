/*
뷰(view)
: 하나 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블

뷰의 필요성
-- 사용자 마다 특정 객체만 조회할 수 있도록 할 필요가 있음
   (모든 직원에 대한 정보를 모든 사원이 볼 수 있도록 하면 안 됨)
-- 복잡한 질의문을 단순화 할 수 있음
-- 데이터의 중복성을 최소화할 수 있음

ex) 판매부에 속한 사원들만을 사원테이블에서 찾아서 다른 테이블로 만들면 중복성이 발생함

장점
-- 논리적 독립성을 제공함
-- 데이터의 접근 제어 ( 보안 )
-- 사용자의 테이터 관리 단순화
-- 여러 사용자의 다양한 데이터 요구 지원

단점
-- 뷰의 정의 변경 불가
-- 삽입 , 삭제 , 갱신 연산에 제한이 있음
*/

--뷰의 생성구문 
create view 뷰이름 as 
(select문);

--뷰의 삭제구문
drop view 뷰이름 ;