/*
Composite Data Types
 레코드 - 서로 다른 타입을 사용하는 하나 이상의 필드로 구성
- INDEX BY TABLE (연관배열)
- 테이블을 컬럼으로 저장 가능
*/


/*
테이블	: TACCT (계좌정보), TREPAY (상환정보), TREPAY_PLAN (상환계획정보) 사용 
검색		: lnact, lnact_seq, 
        ln_dt, ln_amt, 
        dlq_dt, dlq_cnt,
        SUM(trepay_plan.sum_mon_amt), 
        SUM(trepay.sum_mon_amt),
        SUM(trepay_plan.sum_mon_amt) - SUM(trepay.sum_mon_amt)
조건1	: 대출 계좌 (tacct.lmt_typ IS NULL)
조건2	: 연체 계좌 (tacct.dlq_cnt > 0)
조건3	: 상환계획 일자가 오늘까지 (trepay_plan.pay_dt <= SYSDATE)
조건4	: 상환일자가 오는까지 (trepay.pay_dt <= SYSDATE)
그룹		: 계좌번호(lnact), 계좌일련번호(lnact_seq)
정렬		: 연체금액 합계 기준 내림차순
*/
SELECT TA.LNACT 					AS 계좌번호
       ,TA.LNACT_SEQ 				AS 계좌일련번호
       ,TA.LN_DT     				AS 대출시작일자
       ,TA.LN_AMT    				AS 대출금액
       ,TA.DLQ_DT    				AS 연체시작일자
       ,TA.DLQ_CNT   				AS 연체일수
       ,TP.SUM_PAMT  				AS "입금계획 합계"
       ,TR.SUM_RAMT  				AS "실제입금 합계"
       ,TP.SUM_PAMT - TR.SUM_RAMT AS "연체금액 합계"
FROM (SELECT *
      FROM TACCT 
      WHERE LMT_TYP IS NULL 
        AND DLQ_CNT > 0) AS TA 
  JOIN (SELECT LNACT, LNACT_SEQ
              ,SUM(SUM_MON_AMT) AS SUM_PAMT 
        FROM TREPAY_PLAN 
        WHERE PAY_DT <= SYSDATE 
        GROUP BY LNACT, LNACT_SEQ) AS TP 
    ON TA.LNACT = TP.LNACT 
      AND TA.LNACT_SEQ = TP.LNACT_SEQ 
  JOIN (SELECT LNACT, LNACT_SEQ
              ,SUM(SUM_MON_AMT) AS SUM_RAMT 
        FROM TREPAY
        WHERE PAY_DT <= SYSDATE 
        GROUP BY LNACT, LNACT_SEQ) AS TR 
    ON TA.LNACT = TR.LNACT 
      AND TA.LNACT_SEQ = TR.LNACT_SEQ 
ORDER BY 9 DESC ; 


SELECT TACCT.LNACT AS 계좌정보,
       TACCT.LNACT_SEQ AS 계좌일련번호, 
       TACCT.LN_DT AS 대출시작일자,
       TACCT.LN_AMT AS 대출금액, 
       TACCT.DLQ_DT AS 연체시작일자,
       TACCT.DLQ_CNT AS 연체일수,
       SUM(TREPAY_PLAN.SUM_MON_AMT) AS 입금계획_합, 
       SUM(TREPAY.SUM_MON_AMT) AS 실제입금_합,
       SUM(TREPAY_PLAN.SUM_MON_AMT) - SUM(TREPAY.SUM_MON_AMT) AS 연체금액_합
FROM TACCT
  LEFT OUTER JOIN TREPAY_PLAN ON TACCT.LNID = TREPAY_PLAN.LNID
  LEFT OUTER JOIN TREPAY ON TACCT.LNID = TREPAY.LNID AND TREPAY_PLAN.PLAN_SEQ = TREPAY.PLAN_SEQ
WHERE TACCT.LMT_TYP IS NULL
  AND TACCT.DLQ_CNT > 0
  AND TACCT.LNID IN (
      SELECT LNID 
      FROM TREPAY
      WHERE PAY_DT <= SYSDATE
        AND LNID IN (
            SELECT LNID
            FROM TREPAY_PLAN
            WHERE PAY_DT <= SYSDATE
        )
  )
GROUP BY TACCT.LNACT, TACCT.LNACT_SEQ, TACCT.LN_DT, TACCT.LN_AMT, TACCT.DLQ_DT, TACCT.DLQ_CNT
ORDER BY 연체금액_합 DESC;





-- 급여를 기준으로 2 개의 행만 검색 FETCH 
SELECT * 
FROM emp 
ORDER BY sal DESC 
FETCH FIRST 2 ROWS ONLY ;

-- 동일한 급여를 함께 검색하려면 WITH TIES 
SELECT * 
 FROM emp 
ORDER BY sal DESC 
FETCH FIRST 2 ROWS WITH TIES ; 

-- Page 단위 처리를 진행할 경우 2 개 행을 건너뛰고 그 다음 3 개의 행을 검색, OFFSET
SELECT * 
 FROM emp 
ORDER BY sal DESC 
OFFSET 2 ROWS FETCH FIRST 3 ROWS ONLY ; 

-- 백분율을 기준으로 행을 제한
SELECT * 
 FROM emp 
ORDER BY sal DESC 
FETCH FIRST 20 PERCENT ROWS ONLY ; -- 20% 가져오기

SELECT  DEPTNO, JOB, MGR, SUM(SAL),GROUPING_ID(DEPTNO,JOB,MGR) 
  FROM EMP 
 GROUP BY CUBE(DEPTNO, JOB, MGR) ;

/*
DEPTNO, JOB 컬럼으로 그룹화된 급여의 합계 
- DEPTNO 컬럼으로 그룹화된 급여 합계 
- 전체 급여 합계는 검색 안함 
*/ 
SELECT deptno, job, SUM(sal) 
FROM emp 
GROUP BY deptno, ROLLUP(job) ;    -- 항상 참여할 deptno은 따로 적기
/*
GROUP BY A, ROLLUP(B,C), CUBE(D,E)
(A, B, C, D, E)
(A, B, C, D) 
(A, B, C, E) 
(A, B, C) 
*/

/*
사원 정보를 검색하면서 소속 부서의 급여 합계와 평균 급여 검색 
- 전체 사원의 급여 합계와 평균 급여 검색 
- DEPTNO, EMPNO 기준으로 정렬 
*/
SELECT deptno, empno, 
 DECODE(grouping_id(1,deptno,2,empno), 1,
        'DEPT_SUM', 3,'DEPT_AVG', 7,'TOTAL_SUM', 15,'TOTAL_AVG', ename) AS ename, 
 DECODE(grouping_id(1,deptno,2,empno),1,
        SUM(sal), 3,ROUND(AVG(sal),1), 7,SUM(sal), 15,ROUND(AVG(sal),1), SUM(sal)) AS sal 
FROM emp 
GROUP BY ROLLUP(1,deptno,2,(empno,ename)) 
ORDER BY deptno, empno ;
SELECT * FROM PIVOT_EMP ;










