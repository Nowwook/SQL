/*
일반적인 LOOP 속 SQL 은 매 LOOP 마다 1회씩 수행된다, 반면에 BULK SQL 을 사용하면 LOOP 없이 1번의 SQL 수행으로 처리
*/

DECLARE 
 TYPE typ_sales IS TABLE OF sales%rowtype INDEX BY PLS_INTEGER ; 
 tab_sales typ_sales ; 
 BEGIN
   SELECT /*+ test4 */ * BULK COLLECT INTO tab_sales FROM sales ; 
   FORALL i IN tab_sales.FIRST .. tab_sales.LAST
   INSERT /*+ test4 */ INTO sales2 
   VALUES tab_sales(i) ; 
 END ;
/


-- FETCH ㅁㅁ BULK COLLECT INTO  ㅂㅂ LIMIT 1000   
-- FETCH 시 limit 로 행수 제한
