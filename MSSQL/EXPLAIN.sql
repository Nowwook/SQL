SET SHOWPLAN_ALL ON
/*

StmtText: SQL 문의 텍스트나 각 단계의 작업 설명, 쿼리의 전체적인 구조를 이해하는 데 도움

PhysicalOp: 실제 수행되는 물리적 연산, ex) "Index Seek", "Table Scan" 등, 이를 통해 인덱스 사용 여부 등을 확인

LogicalOp: 논리적 연산, 쿼리 옵티마이저가 선택한 전략을 이해하는 데 도움

EstimateRows: 각 단계에서 처리될 것으로 예상되는 행 수, 데이터의 흐름을 파악

EstimateIO와 EstimateCPU: 각 단계의 예상 I/O 비용과 CPU 비용, 쿼리의 리소스 사용량을 예측하는 데 유용

TotalSubtreeCost: 해당 작업과 모든 하위 작업의 누적 예상 비용, 쿼리의 전체적인 비용을 평가하는 데 중요

Argument: 작업에 대한 추가 정보를 제공, 사용된 인덱스 이름 등이 포함

Type: 노드의 유형, 주로 "PLAN_ROW"와 SQL 문 유형(SELECT, INSERT 등)

Parallel: 병렬 처리 여부, 0은 병렬 처리가 아님, 1은 병렬 처리를 의미

EstimateExecutions: 해당 연산자가 실행될 것으로 예상되는 횟수

*/

SET SHOWPLAN_ALL ON
GO

SELECT		*
FROM    [dbo].[DAY_PLAN]
WHERE		[ID] 			= '241111'
ORDER BY 	[ANME]
; 

SET SHOWPLAN_ALL OFF
GO
