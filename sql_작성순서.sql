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
--오답 
SELECT  ta.lnact 					AS 계좌번호
       ,ta.lnact_seq 				AS 계좌일련번호
       ,ta.ln_dt     				AS 대출시작일자
       ,ta.ln_amt    				AS 대출금액
       ,ta.dlq_dt    				AS 연체시작일자
       ,ta.dlq_cnt   				AS 연체일수
       ,SUM(tp.sum_mon_amt)		AS "입금계획 합계"
       ,SUM(tr.sum_mon_amt)		AS "실제입금 합계"
       ,SUM(tp.sum_mon_amt) - SUM(tr.sum_mon_amt) AS "연체금액 합계"
  FROM tacct       ta 
  JOIN trepay_plan tp
    ON ta.lnact     = tp.lnact
   AND ta.lnact_seq = tp.lnact_seq
  JOIN trepay      tr 
    ON ta.lnact     = tr.lnact
   AND ta.lnact_seq = tr.lnact_seq
 WHERE ta.lmt_typ IS NULL 
   AND ta.dlq_cnt > 0
   AND tp.pay_dt <= SYSDATE
   AND tr.pay_dt <= SYSDATE
 GROUP BY ta.lnact, ta.lnact_seq, ta.ln_dt, ta.ln_amt, ta.dlq_dt, ta.dlq_cnt 
ORDER BY 9 DESC ; 


/*
작성순서
FROM 절 부터 결과를 생각하며 필요조건을 하나씩 실행해보며 작성

SELECT 은 마지막
*/

SELECT * 
  FROM (SELECT *
           FROM TACCT 
          WHERE lmt_typ IS NULL 
            AND dlq_cnt > 0) TA 
  JOIN (SELECT LNACT, LNACT_SEQ
               ,SUM(sum_mon_amt) AS SUM_PAMT 
          FROM TREPAY_PLAN 
         WHERE PAY_DT <= SYSDATE 
        GROUP BY LNACT, LNACT_SEQ) TP 
    ON TA.LNACT = TP.LNACT 
   AND TA.LNACT_SEQ = TP.LNACT_SEQ 
  JOIN (SELECT LNACT, LNACT_SEQ
               ,SUM(sum_mon_amt) AS SUM_RAMT 
          FROM TREPAY
         WHERE PAY_DT <= SYSDATE 
        GROUP BY LNACT, LNACT_SEQ) TR 
    ON TA.LNACT = TR.LNACT 
   AND TA.LNACT_SEQ = TR.LNACT_SEQ);


