범위에 null 불가
LOOP 적어도 1번은 실행
WHILE 조건 LOOP 
*/
DECLARE
   v_countryid locations.country_id%TYPE := 'CA';
   v_loc_id locations.location_id%TYPE;
   v_counter NUMBER(2) := 1;
   v_new_city locations.city%TYPE := 'Montreal';
BEGIN
  SELECT MAX(location_id)
  INTO v_loc_id 
  FROM locations
  WHERE country_id = v_countryid;
  
  LOOP
    INSERT INTO locations
      (location_id, city, country_id) 
    VALUES((v_loc_id + v_counter), v_new_city, v_countryid);
   v_counter := v_counter + 1;
   EXIT WHEN v_counter > 3;
   END LOOP;
   
   /*
   WHILE v_counter <= 3 LOOP
    INSERT INTO locations
      (location_id, city, country_id) 
    VALUES((v_loc_id + v_counter), v_new_city, v_countryid);
   v_counter := v_counter + 1;
   END LOOP;
  */
  
  /*
  FOR I IN [REVERSE] 1..3 LOOP  -- 리버스 시 321
   INSERT INTO locations
    (location_id, city, country_id)
   VALUES((v_loc_id+i), v_new_city, v_countryid));
  END LOOP;
  
for 안의 I는 출력 불가
  */
END;
/

/*
중첩 LOOP 내부에서 외부만 종료 가능
<<레이블이름>>
*/
DECLARE 
  x	NUMBER := 3 ;
  y	NUMBER ;
BEGIN 
  <<OUTER_LOOP>> LOOP
    y := 1 ;
    EXIT WHEN x > 5 ; 
    <<INNER_LOOP>> LOOP 
      DBMS_OUTPUT.PUT_LINE ( x || ' * ' || y || ' = ' || x * y ) ;
      EXIT OUTER_LOOP WHEN x*y > 15 ;
      y := y + 1 ; 
      EXIT WHEN y > 5 ; 
    END LOOP INNER_LOOP ; 
    x := x + 1 ; 
  END LOOP OUTER_LOOP ; 
END ;
/
