## 테이블 조작어
# 테이블 제거
drop table emp_temp;
# 테이블생성
create table dept_temp
    as select * from dept;
# 틀 복사    
create table emp_temp
    as select * from emp where 1<>1;
    
select * from dept_temp;
# 데이터 삽입
insert into dept_temp (deptno,dname,loc)
values (50,'DATABASE','SEOUL');
# 데이터 제거
delete from dept_temp where deptno=50;

insert into dept_temp (deptno,dname,loc)
values (70,'WEB',null);

select * from emp_temp;
insert into emp_temp(empno,ename,job,mgr,hiredate,sal,comm,deptno)
              values(1111,'성춘향','MANAGER',9999,'2022-08-10',4000,null,20);

create table dept_temp2
    as select * from dept;
    
select * from dept_temp2;

# update
update dept_temp2 set loc='SEOUL' where deptno =10;

# rollback
rollback;
# 저장
commit;

# 하나 이상 데이터 수정
update dept_temp2 
set dname ='DATEBASE',LOC='SEOUL'
WHERE DEPTNO=40;

update emp_temp 
set comm=50
where sal <= 2500;

select * from dept_temp2;
# 서브쿼리로 수정
select DNAME,loc from dept where deptno=40;
update dept_temp2
set (DNAME,loc) =(select DNAME,loc from dept where deptno=40)
where deptno=40;

create table HW_emp as select * from emp;
create table HW_dept as select * from dept;
create table HW_salgrade as select * from salgrade;
