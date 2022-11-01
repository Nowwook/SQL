# 동의어 SYNONYM
# 테이블, 뷰 등 객체의 이름이 너무 길 경우
# 다른 소유자가 가진 객체를 참조하려는 경우
# 생성
CREATE SYSNONYM E FOR EMP;
# 동의어 이름 E
SELECT * FROM E;

# 생성, 덮어쓰기
create or replace synonym E for EMP;
# 공용동의어
create public synonym E for EMP;
