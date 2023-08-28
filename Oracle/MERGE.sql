/*
조건 참이면 UPDATE, 아니면 INSERT
*/

MERGE INTO TB_SCORE S
USING TMP_SCORE T
   ON (S.COURSE_ID = T.COURSE_ID AND S.STUDENT_ID = T.STUDENT_ID)
WHEN MATCHED THEN
    UPDATE SET S.SCORE = T.SCORE
WHEN NOT MATCHED THEN
    INSERT (S.COURSE_ID, S.STUDENT_ID, S.SCORE) 
    VALUES (T.COURSE_ID, T.STUDENT_ID, T.SCORE)
;
