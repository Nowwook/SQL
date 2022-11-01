# 데이터 그룹화
# group by
 
select round(avg(sal),2), deptno from emp; # 단일로 찍는 deptno는 안된다.
 
select round(avg(sal),2), deptno from emp
group by deptno;
 
# 부서번호 및 직책별 평균 급여 정렬하기
select deptno, job, avg(sal) from emp
group by deptno, job
order by deptno desc;

# group by 절에서 조건 having
select deptno, job, avg(sal)
from emp
group by deptno, job 
having avg(sal) >= 2000;
 
# where 과 having의 공동 사용
select deptno, job, avg(sal) from emp
where sal <= 3000
group by deptno, job
having avg(sal) >= 2000
order by deptno, job;
 
 
# 직업별 연봉 3000넘는 직업
select job, sum(sal) from emp
group by job
aving sum(sal) >= 3000;
 
# 부서별 연봉 기타 데이터
select deptno from emp
group by deptno
having avg(sal) >= 2000;
 
 
# 다양한 그룹화 함수 종류
select deptno, job, count(*), max(sal), sum(sal), avg(sal)
from emp
group by deptno, job
order by deptno, job;

# rollup	(a,b)(b,a) 다름
# cube	(a,b)(b,a) 같음

# rollup 위쪽의 공통된 데이터의 총 합을 한줄에 표현
select deptno, job, count(*), max(sal), sum(sal), avg(sal)
from emp
group by rollup(deptno, job);

# cube
select deptno, job, count(*), max(sal), sum(sal), avg(sal)
from emp
group by cube(deptno, job);
 
# deptno를 먼저 그룹화한 후 rollup 함수에 job지정하기
select deptno, job, count(*) from emp
group by deptno, rollup(job);
 
# job을 먼저 그룹화 한 후 rollup 함수에 deptno 지정하기
select deptno, job, count(*) from emp
group by job, rollup(deptno);
 
# grouping set
# 컬럼별 그룹화를 통해 결과를 출력
select deptno, job, count(*) from emp
group by grouping sets(deptno, job)
order by deptno, job;
 
# deptno, job열의 그룹화 결과 여부를 grouping 함수로 확인
select deptno, job, count(*), max(sal), sum(sal), round(avg(sal),2),
    grouping(deptno),
    grouping(job)
from emp
group by cube(deptno, job)
order by deptno, job;
 
select decode(grouping(deptno), 1, 'all_dept', deptno) as 부서번호,
        decode(grouping(job), 1, 'all_job', job) as 직업,
        count(*), max(sal)
from emp
group by cube (deptno, job)
order by deptno, job;

# pivot     행>>열
# unpivot 	열>>행
 
# 부서별, 직책별 그룹화 최고 급여 데이터 출력
select deptno, job, max(sal) from emp
group by deptno, job
order by deptno, job;
 
select * from (select deptno, job, sal from emp)
    pivot (max (sal) for deptno in (1o, 20, 30))
order by job;
 
# pivot 함수를 사용하여 부서별, 직책별 최고 급여를 2차원 표 형태로 출력하기
select * from (select job, deptno, sal from emp)
pivot(max(sal) 
    for job in ( 'CLERK' as CLERK,
                 'SALESMAN' as SALESMAN,
                 'PRESIDENT' as PRESIDENT,
                 'MANAGER' as MANAGER,
                 'ANALYST' as ANALYST)
                 )
order by deptno;
                

# decode문을 활용하여 pivot 구현
select deptno,
    max(decode(job, 'CLERK', sal)) as 점원,
    max(decode(job, 'SALESMAN', sal)) as 판매원
from emp
group by deptno;
