-- 하나의 셀에 나열하기, 컬럼 합치기 

-- LISTAGG([합칠 컬럼명], [구분자]) WITHIN GROUP(ORDER BY [정렬 컬럼명]) 

--컬럼 합치기
SELECT LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename) AS names
  FROM emp
 WHERE job IN ('MANAGER', 'SALESMAN')
 

--GROUP BY 절을 사용하여 컬럽 합치기
SELECT job
     , LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename) AS names
  FROM emp
 WHERE job IN ('MANAGER', 'SALESMAN')
 GROUP BY job
 

--PARTITION BY 절을 사용하여 컬럼 합치기
SELECT ename
     , job
     , LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename) OVER(PARTITION BY job) AS names
  FROM emp
 WHERE job IN ('MANAGER', 'SALESMAN')
--PARTITION BY 절을 사용하면 조회된 행을 그대로 유지하면서 합쳐진 컬럼의 값을 표시할 수 있다.

 
--중복을 제거하여 컬럼 합치기
SELECT job
     , REGEXP_REPLACE(LISTAGG(deptno, ',') WITHIN GROUP(ORDER BY deptno), '([^,]+)(,\1)*(,|$)', '\1\3') deptnos
  FROM emp
 WHERE job IN ('MANAGER', 'SALESMAN', 'CLERK')
 GROUP BY job
--REGEXP_REPLACE 정규식 함수를 사용하여 컬럼의 중복을 제거하는 방법이며, 값의 순서로 정렬되어 있어야 정확한 중복제거가 된다. (ORDER BY deptno)
