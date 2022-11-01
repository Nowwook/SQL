# SubQuery
# ()로 합치기
select sal from emp where ename =upper('jones');
select * from emp where sal > 2975;

select * from emp where sal > (select sal from emp where ename =upper('jones'));

select ename from emp 
where comm > (select comm from emp where ename =upper('allen'));

# 실행결과가 하나인 단일 쿼리
select hiredate from emp where ename=upper('scott');

select * from emp where hiredate < (select hiredate from emp where ename=upper('scott'));

# join + 서브쿼리
select e.empno,ename,job,sal,d.deptno,dname,loc
from emp e, dept d
where e.deptno =d.deptno
      and e.deptno =20
      and sal > (select trunc(avg(sal)) from emp);

# 실행 결과가 여러개인 다중행 서브쿼리
select * from emp where deptno in (20,30);

# 각부서별 최고급여, 동일한 급여 받는 사원
select * from emp 
where sal in (select max(sal) from emp group by deptno);

# ANY
select max(sal) from emp group by deptno;

select * from emp
where sal = any(select max(sal) from emp group by deptno);
 
# SOME
select * from emp
where sal = some(select max(sal) from emp group by deptno);


select empno,ename,e.deptno,dname,loc
from emp e,dept d
where e.deptno=d.deptno;

select empno,ename,e.deptno,dname,loc
from emp e,dept d
where e.deptno=d.deptno and sal<=2500 and empno<=9999;

select * from emp e, salgrade s
where losal<=sal and hisal>=sal;

select e1.empno, e1.ename, e1.mgr, e2.empno, e2.ename
from emp e1, emp e2
where e1.mgr = e2.empno;

select e1.empno, e1.ename, e1.mgr, e2.empno, e2.ename
from emp e1, emp e2
where e1.mgr = e2.empno(+);

# SQL 99
select e.empno, e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,
       deptno,d.dname,d.loc
from emp e natural join dept d
order by deptno,e.empno;

# exists 결과값이 존재하면 모두출력
select dname from dept where deptno=10;
select * from emp
where exists (select dname from dept where deptno=10);

# 다중열 서브쿼리 **
select deptno,max(sal) from emp group by deptno;
select * from emp 
where(deptno,sal) in(select deptno,max(sal) from emp group by deptno);

# INLINE VIEW
select e10.empno,e10.ename,e10.deptno,d.dname,d.loc
from (select * from emp where deptno=10) e10,
     (select * from dept) d
where e10.deptno=d.deptno;     

# WITH >> INLINE VIEW의 변수화
#테이블 내 데이터 규모가 너무 크거나 일부 행,열만 사용하고자 할때
with
E10 as (),
D   as ()
select e10.empno,e10.ename,e10.deptno,d.dname,d.loc
from E10,D
where e10.deptno=d.deptno;

# select 절에서 서브 쿼리 사용
#1 
select grade from salgrade;
#2
select empno,ename,job,sal,
       (select grade from salgrade where e.sal between losal and hisal),
       deptno,
       (select dname from dept where e.deptno =dept.deptno)
from emp e;       
