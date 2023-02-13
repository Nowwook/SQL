https://school.programmers.co.kr/learn/courses/30/lessons/157342

Oracle

SELECT CAR_ID, AVERAGE_DURATION
from (
    select CAR_ID, round(avg(END_DATE - START_DATE+1), 1) as AVERAGE_DURATION
    from CAR_RENTAL_COMPANY_RENTAL_HISTORY
    group by CAR_ID
)
where AVERAGE_DURATION>=7
order by AVERAGE_DURATION desc, CAR_ID desc;
