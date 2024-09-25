/*
SQL Server에서 트랜잭션의 고립 수준(Isolation Level)을 설정

각 고립 수준은 트랜잭션이 다른 트랜잭션과의 격리 정도를 결정하여 동시성 문제를 제어
동시성 문제 유형:
Dirty Read: 다른 트랜잭션에서 커밋되지 않은 데이터를 읽음
Non-repeatable Read: 같은 트랜잭션에서 두 번 읽을 때 데이터가 변경됨
Phantom Read: 트랜잭션 중에 데이터 행이 추가되거나 삭제됨
*/

/*
1. READ UNCOMMITTED

설명: 다른 트랜잭션에서 커밋되지 않은 변경 내용도 읽을 수 있습니다. 이를 "dirty read"라고도 합니다.
특징: 동시성은 매우 높지만, 데이터 일관성이 떨어질 수 있습니다.
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
2. READ COMMITTED (기본값)

설명: 다른 트랜잭션이 커밋된 데이터만 읽습니다. 읽는 동안 다른 트랜잭션이 데이터를 변경할 수 있습니다.
특징: Dirty read는 발생하지 않지만, non-repeatable read가 발생할 수 있습니다.
*/
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

/*
3. REPEATABLE READ

설명: 트랜잭션 내에서 데이터를 읽으면 해당 데이터는 다른 트랜잭션에서 변경할 수 없습니다. 하지만 새로운 행을 추가하는 것은 허용됩니다.
특징: Dirty read와 non-repeatable read는 발생하지 않지만, phantom read는 발생할 수 있습니다.
*/
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;


/*
4. SERIALIZABLE

설명: 트랜잭션이 완료될 때까지 다른 트랜잭션이 데이터를 읽거나 변경할 수 없습니다. 가장 높은 고립 수준을 제공합니다.
특징: 동시성은 가장 낮지만, phantom read 문제를 방지합니다.
*/
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;



--ex)

GO  
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
GO  
  
BEGIN TRANSACTION;  
GO  
SELECT * FROM HumanResources.EmployeePayHistory;  
GO  
SELECT * FROM HumanResources.Department;  
GO  
COMMIT TRANSACTION;  
GO  
