# 다중행 함수
# count, sum, avg, max, min

select sum(sal) from emp;
select count(sal) from emp;
select * from emp;
 
select sal from emp;
select round(avg(sal),2) from emp;
 
# 급여의 합계 구하기 (중복제외 합, 총 합)
select sum(distinct sal),
    sum(all sal)
from emp;
 
# 30번 부서의 인원 구하기
select count(*) from emp
where deptno = 30;
 
select max(sal) from emp where deptno = 20;
select min(sal) from emp where deptno = 10;
 
# 입사일이 가장 최신일 출력 부서번호가 20번
select max(hiredate) from emp
where deptno = 10;
 
 
# count(*) 		(null 제외) 행 합 (distinct 사용시 포함)
# sum(*)		(null 제외) 열 합 (distinct 사용시 포함)
