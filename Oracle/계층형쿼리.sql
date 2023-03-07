# 1) 일반 조인을 사용한 계층형 쿼리
SELECT bom1.item_name,
       bom1.item_id,
       bom2.item_name parent_item
FROM bom bom1, bom bom2
WHERE bom1.parent_id = bom2.item_id(+)
ORDER BY bom1.item_id;
#계층관계 구분이 획실하지 않음


# 2) START WITH ... CONNECT BY 절을 사용한 계층형 쿼리
SELECT item_name, item_id, parent_id
FROM bom
START WITH parent_id IS NULL            #루트노드를 지정
CONNECT BY PRIOR item_id = parent_id;   #부모와 자식노드들 간의 관계를 연결

#) 3) 좀더 보기좋게 레벨별로 들여쓰기
SELECT LPAD(' ', 2*(LEVEL-1)) || item_name item_names,
        item_id, 
        parent_id
FROM bom
START WITH parent_id IS NULL 
CONNECT BY PRIOR item_id = parent_id;

#본체의 PARENT_ID는 부모노드인 컴퓨터의 ITEM_ID와 연결되므로 PRIOR키워드는 PARENT가 아닌 ITEM_ID앞

