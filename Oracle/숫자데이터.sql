## 숫자데이터
# 반올림
select round(1234.5678), 
    round(1234.5678, 0),
    round(1234.5678,1),
    round(1234.5678,2),
    round(1234.5678,3)
from dual;

# 자름
select trunc(1234.5678, 1),
        trunc(1234.5678, 2),
        trunc(1234.5678, 3)
from dual;
 
# 반 올림 ceil
# 반 내림 floor
select ceil(3.14),
        floor(3.14),
        ceil(-3.14),
        floor(-3.14)
from dual;
 
# 나머지 %
select mod(15, 6),
        mod(10, 2),
        mod(11, 2)
from dual;
 
## 날짜
select sysdate,
    sysdate-1 as "어제",
    sysdate+1 as "내일"
from dual;
 
# 3개월 후 
select sysdate,
    add_months(sysdate, 3)
from dual;
 
# 입사 10주년이 되는 사원 데이터 출력하기
select empno, ename, hiredate, add_months(hiredate, 120)
from emp;
 
# 입사 32년 미만인 사원 데이터 출력하기 ----> where ㅅ용
select * from emp
where add_months(hiredate, 500) > sysdate;
 
# sysdate와 add_months 함수를 사용해서 현재 날짜와 6개월 후 날짜를 출력해 봅시다.
select sysdate,
    add_months(sysdate, 6)
    from dual;
    
# 두 날짜간의 개월 수 차이를 구하는 함수 months_between
select empno, ename, hiredate, sysdate,
    trunc(months_between (hiredate, sysdate)) as months1,
    trunc(months_between (sysdate, hiredate)) as months2
from emp;
 

# 돌아오는 요일, 달의 마지막날짜 next_day, last_day (/ ' ' - , 다가능)
select sysdate, 
next_day(sysdate, '금요일'),
last_day('22/2/11')
from dual;
 
# 날짜 round 함수
select sysdate,
        round(sysdate, 'CC'),
        round(sysdate, 'yyyy'),
        round(sysdate, 'q'),
        round(sysdate, 'ddd'),
        round(sysdate, 'hh')
from dual;
 
select sysdate,
        trunc(sysdate, 'CC'),
        trunc(sysdate, 'yyyy'),
        trunc(sysdate, 'q'),
        trunc(sysdate, 'ddd'),
        trunc(sysdate, 'HH')
from dual;
 
# 자료형(type)을 변환하는 변환함수
select empno, ename, empno + '500' 
from emp where ename = upper('scott');
 
# 문자열과 숫자 더하기
select 'abcd' + empno from emp; # error 문자열에 숫자를 넣으면 타입이 맞지않는다.
 
# substr()
# to_char()

# 날짜 형식 패턴을 이용하여 출력 가능하다.
# TO_CHAR(sysdate,'yyyy mm/dd hh24:mi:ss P.M.')
select TO_CHAR (sysdate, 'yyyy/mm/dd/hh/mi/ss') from dual;
 
# 여러 언어로 날짜 (월) 출력
select 
to_char (sysdate, 'mm'),
to_char (sysdate, 'mon'),
to_char (sysdate, 'month', 'nls_date_language = english'),
to_char (sysdate, 'mon', 'nls_date_language = japanese')
from dual; 

# sysdate 시간 형식 지정하여 출력
select sysdate, to_char(sysdate, 'hh:mi:ss am') from dual;
 
# 숫자형식을 to_char로 표현해 봅시다.
select 
    to_char(sal, '$999,999'),     # 달러
    to_char(sal, 'L999,999'),     # 원
    to_char(sal, '999,999.00'),
    to_char(sal, '000,999,999.00')
from emp;
 
# to_number 문자데이터를 숫자데이터로 
select 1300 - '1500' ,
        '1300' + 1500
from dual;
 
select to_number('1,300','999,999') - to_number('1,500','999,999') from dual;
 
# 문자데이터를 날짜 데이터로 변환 to_date
select to_date('2018-07-04', 'yyyy-mm-dd'),
    to_date('20180704','yyyy-mm-dd')
from dual;
        
    
# 1981년 6월 1일 이후에 입사한 사원 정보를 출력해 봅시다.
select * from emp
where hiredate > to_date('1981-06-01', 'yyyy-mm-dd');
 
# null처리 NVL() (아닐때,null일때)
# 데이터가 null 아니면 그대로 반환, null이라면 여룹ㄴ이 지정한 값으로 변환
select empno, ename, sal, comm, sal + comm,
   NVL(comm, 0), sal + nvl(comm, 0)
from emp;

# NVL2(,,) (이 데이터가,아닐때,null일때)
select comm, 
    NVL2(comm, 'O', 'X'),
    NVL2(comm, sal*12+comm, sal*12)
from emp;
 
# 완전 중요 decode 응용 부분
select empno, ename, job, sal,
        decode(job, 
                'MANAGER', sal * 1.1,
                'SALESMAN', sal * 1.15,
                'ANALYST', sal,
                sal * 1.03
                ) as 급여
from emp;
 
# P/L SQL
 
# 열 값에 따라 출력 값이 달라지는 case
select empno, ename, comm,
case
    when comm is null then '해당 사항 없음'
    when comm = 0 then '수당 없음'
    when comm > 0 then '수당 : ' || comm
    end as 추가수당
from emp;
   
# 퀴즈 
select empno,
    rpad(substr(empno,1,2), 4, '*') as masking_empno,
    ename,
    rpad(substr(ename,1,1), 5, '*') as masking_ename
from emp
where length(ename) = 5;

select empno, ename, sal, 
    trunc(sal / 21.5, 2) as 일당,
    round(sal / 21.5 / 8, 1) as 시급
from emp;
 
select empno, ename, hiredate,
    to_char(next_day(add_months(hiredate, 3), '월요일'), 'yyyy-mm-dd') as r_job,
    nvl(to_char(comm), 'n/a') as comm
from emp;
 
select empno, ename, mgr,
    case
        when mgr is null then '0000'
        when substr(mgr, 1, 2) = '78' then '8888'
        when substr(mgr, 1, 2) = '77' then '7777'
        when substr(mgr, 1, 2) = '76' then '6666'
        when substr(mgr, 1, 2) = '75' then '5555'
        else to_char(mgr)
    end as 변환 코드
from emp;
        
