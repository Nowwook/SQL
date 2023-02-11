비용 기반 옵티마이저 CBO(Cost-Based Optimizer)
- 쿼리를 수행하는데 소요되는 일 량 또는 시간 기반으로 최적화를 수행

CHOOSE : SQL이 실행되는 환경에서 통계 정보를 가져올 수 있으면 비용 기반 옵티마이저로 그렇지 않다면 규칙 기반 옵티마이저로 작동시키는 모드
FIRST_ROWS : 옵티마이저가 처리 결과 중 첫 건을 출력하는데 걸리는 시간을 최소화할 수 있는 실행 계획을 세우는 모드
FIRST_ROWS_n : SQL의 실행 결과를 출력하는데까지 걸리는 응답속도를 최적화하는 모드
ALL_ROWS : SQL 실행 결과 전체를 빠르게 처리하는데 최적화 된 실행계획을 세우는 모드, 마지막으로 출력될 행까지 최소한의 자원을 사용하여 최대한 빨리 가져오게 하며 오라클 10g 이후로는 이 모드가 기본값