/*
Composite Data Types
 ���ڵ� - ���� �ٸ� Ÿ���� ����ϴ� �ϳ� �̻��� �ʵ�� ����
- INDEX BY TABLE (�����迭)
- ���̺��� �÷����� ���� ����
*/


/*
���̺�	: TACCT (��������), TREPAY (��ȯ����), TREPAY_PLAN (��ȯ��ȹ����) ��� 
�˻�		: lnact, lnact_seq, 
        ln_dt, ln_amt, 
        dlq_dt, dlq_cnt,
        SUM(trepay_plan.sum_mon_amt), 
        SUM(trepay.sum_mon_amt),
        SUM(trepay_plan.sum_mon_amt) - SUM(trepay.sum_mon_amt)
����1	: ���� ���� (tacct.lmt_typ IS NULL)
����2	: ��ü ���� (tacct.dlq_cnt > 0)
����3	: ��ȯ��ȹ ���ڰ� ���ñ��� (trepay_plan.pay_dt <= SYSDATE)
����4	: ��ȯ���ڰ� ���±��� (trepay.pay_dt <= SYSDATE)
�׷�		: ���¹�ȣ(lnact), �����Ϸù�ȣ(lnact_seq)
����		: ��ü�ݾ� �հ� ���� ��������
*/
SELECT TA.LNACT 					AS ���¹�ȣ
       ,TA.LNACT_SEQ 				AS �����Ϸù�ȣ
       ,TA.LN_DT     				AS �����������
       ,TA.LN_AMT    				AS ����ݾ�
       ,TA.DLQ_DT    				AS ��ü��������
       ,TA.DLQ_CNT   				AS ��ü�ϼ�
       ,TP.SUM_PAMT  				AS "�Աݰ�ȹ �հ�"
       ,TR.SUM_RAMT  				AS "�����Ա� �հ�"
       ,TP.SUM_PAMT - TR.SUM_RAMT AS "��ü�ݾ� �հ�"
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


SELECT TACCT.LNACT AS ��������,
       TACCT.LNACT_SEQ AS �����Ϸù�ȣ, 
       TACCT.LN_DT AS �����������,
       TACCT.LN_AMT AS ����ݾ�, 
       TACCT.DLQ_DT AS ��ü��������,
       TACCT.DLQ_CNT AS ��ü�ϼ�,
       SUM(TREPAY_PLAN.SUM_MON_AMT) AS �Աݰ�ȹ_��, 
       SUM(TREPAY.SUM_MON_AMT) AS �����Ա�_��,
       SUM(TREPAY_PLAN.SUM_MON_AMT) - SUM(TREPAY.SUM_MON_AMT) AS ��ü�ݾ�_��
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
ORDER BY ��ü�ݾ�_�� DESC;





-- �޿��� �������� 2 ���� �ุ �˻� FETCH 
SELECT * 
FROM emp 
ORDER BY sal DESC 
FETCH FIRST 2 ROWS ONLY ;

-- ������ �޿��� �Բ� �˻��Ϸ��� WITH TIES 
SELECT * 
 FROM emp 
ORDER BY sal DESC 
FETCH FIRST 2 ROWS WITH TIES ; 

-- Page ���� ó���� ������ ��� 2 �� ���� �ǳʶٰ� �� ���� 3 ���� ���� �˻�, OFFSET
SELECT * 
 FROM emp 
ORDER BY sal DESC 
OFFSET 2 ROWS FETCH FIRST 3 ROWS ONLY ; 

-- ������� �������� ���� ����
SELECT * 
 FROM emp 
ORDER BY sal DESC 
FETCH FIRST 20 PERCENT ROWS ONLY ; -- 20% ��������

SELECT  DEPTNO, JOB, MGR, SUM(SAL),GROUPING_ID(DEPTNO,JOB,MGR) 
  FROM EMP 
 GROUP BY CUBE(DEPTNO, JOB, MGR) ;

/*
DEPTNO, JOB �÷����� �׷�ȭ�� �޿��� �հ� 
- DEPTNO �÷����� �׷�ȭ�� �޿� �հ� 
- ��ü �޿� �հ�� �˻� ���� 
*/ 
SELECT deptno, job, SUM(sal) 
FROM emp 
GROUP BY deptno, ROLLUP(job) ;    -- �׻� ������ deptno�� ���� ����
/*
GROUP BY A, ROLLUP(B,C), CUBE(D,E)
(A, B, C, D, E)
(A, B, C, D) 
(A, B, C, E) 
(A, B, C) 
*/

/*
��� ������ �˻��ϸ鼭 �Ҽ� �μ��� �޿� �հ�� ��� �޿� �˻� 
- ��ü ����� �޿� �հ�� ��� �޿� �˻� 
- DEPTNO, EMPNO �������� ���� 
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










