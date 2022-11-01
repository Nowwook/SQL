#join
select * from emp;
select * from dept;

# 곱형식
select * from emp,dept,salgrade;
# 조건 조인
select * from emp,dept
where emp.deptno = dept.deptno
order by empno;

# 중복되는 테이블은 .으로 표시
select ename, job ,hiredate, dname,loc from emp,dept
where emp.deptno = dept.deptno
order by dname;

# 테이블 이름 (한칸 띄워서)별칭
select * from emp e, dept d
where e.deptno = d.deptno;

# sal>2000 사원정보
select d.deptno,dname,empno,ename,sal from emp e,dept d
where e.deptno=d.deptno and sal>2000;

# 등가조인 >> insert join , simple join
select empno,ename, e.deptno,dname,loc
from emp e, dept d
where e.deptno =d.deptno;

# 비등가조인 
# TABLE 1
select *from emp;
# TABLE 2
select * from salgrade;

# TABLE 3 비등가
select * from emp e, salgrade s
where e.sal between s.losal and s.hisal;  # losal<sal<hisal 데이터만

select ename, sal,job, grade 
from emp e, salgrade s
where e.sal between s.losal and s.hisal;

# 자신을 조인
select e1.empno, e1.ename,e1.mgr, e2.empno,e2.ename
from emp e1, emp e2
where e1.mgr = e2.empno;

# insert join 해보니 null 값에 대한 데이터 유실이 생김
# 이를 해결한 join >> 외부조인 outer join >> left join, right join

# left join
select e1.empno, e1.ename,e1.mgr, e2.empno,e2.ename
from emp e1, emp e2
where e1.mgr = e2.empno(+);
# right join
select e1.empno, e1.ename,e1.mgr, e2.empno,e2.ename
from emp e1, emp e2
where e1.mgr(+) = e2.empno;

# ANSI 표준 SQL JOIN 구문
# NATURAL JOIN
select e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,
       deptno,d.dname,d.loc
from emp e natural join dept d
order by deptno, e.empno;

#2
select e.deptno,d.dname,trunc(avg(sal)),max(sal),min(sal),count(*)
from emp e, dept d
where e.deptno = d.deptno
group by e.deptno,d.dname
order by deptno;
#3
select e.deptno,dname,empno,ename,job,sal
from emp e, dept d
where e.deptno(+) = d.deptno
order by d.deptno,e.ename;
#4
select d.deptno,d.dname,
       e1.empno,e1.ename,e1.mgr,e1.sal,e1.deptno,
       s.losal,s.hisal,s.grade,
       e2.empno,e2.ename
from emp e1,emp e2, dept d,salgrade s
where e1.mgr = e2.empno(+) 
      and e1.deptno(+) = d.deptno 
      and e1.sal >= s.losal(+)
      and e1.sal <= s.hisal(+)
order by d.deptno,d.dname,e1.empno;
