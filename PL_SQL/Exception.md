## 에러종류

|**예외명**|    예외  코드     |**설명**|
|:---------------------:|:------------------:|:---------------------------------------------------------------------------------------:|
| ACCESS_INTO_NULL     | ORA-06530 | 정의되지 않은 Obejct 속성에 Value을 할당 하고자 했을 때 발생되는 예외.              |
| CASE_NOT_FOUND      | ORA-06592 | CASE 문의 구문 오류.                                                                   |
| INVALID_CURSOR      | ORA-01001 | 존재하지 않는 커서를 참조하려 할 때 발생되는 예외.                                  |
| CURSOR_ALREADY_OPEN | ORA-06511 | 이미 열려진 커서를 열려고 시도 했을 때 발생되는 예외.                                |
| DUP_VAL_ON_INDEX    | ORA-00001 | 유일인덱스에 중복값을 입력(Insert)하거나 업데이트(Upldate)하는 경우 발생되는 예외. |
| INVALID_NUMBER | ORA-01722 | 문자열을 숫자로 변환하는 SQL문이 실패했을 경우 발생되는 예외. |
| LOGIN_DENIED | ORA-01017 | 잘못된 사용자 이름이나 비밀번호로 로그인을 시도 하였을 때 발생되는 예외. |
| NO_DATA_FOUND | ORA-01403 | 결과가 없는 SELECT INTO문(묵시적 커서)을 실행할 때 발생되는 예외. |
| NOT_LOGGED_ON | ORA-01012 | 오라클 RDBMS에 접속하기 전(로그인 전)에 데이터베이스를 호출하는 경우 발생. |
| PROGRAM_ERROR | ORA-06501 | PL/SQL 코드상에서 내부 오류를 만났을 때 발생. 이 오류가 발생하면 "오라클에 문의(Contact Oracle Support)"란 메시지 출력. |
| STORAGE_ERROR | ORA-06500 | 프로그램 수행 시 메모리가 부족할 경우(메모리 초과) 발생. |
| TIMEOUT_ON_RESOURCE | ORA-00051 | 데이터베이스 자원을 기다리는 동안 타임아웃 발생 시 발생. |
| SUBSCRIPT_BEYOND_COUNT | ORA-06533 | 컬렉션의 요소 개수보다 더 큰 첨자 값으로 참조한 경우 발생되는 예외. |
| SUBSCRIPT_OUTSIDE_LIMIT | ORA-06532 | 컬렉션의 범위 밖의 참조가 일어났을 때 발생되는 예외. |
| TOO_MANY_ROWS | ORA-01422 | 하나 이상의 결과 값을 반환하는 SELECT INTO문을 실행한 경우. (SELECT INTO는 한 행만 반환할 수 있다.) |
| VALUE_ERROR | ORA-06502 | 수치 또는 값 오류. |
| ZERO_DIVIDE | ORA-01476 | 0으로 나눌 때 발생하는 오류. |
| TRANSACTION_BACKED_OUT | ORA-00061 | 명시적으로 ROLLBACK을 실행했거나 다른 동작의 결과로 원격 트랜잭션 부분이 롤백되는 경우 |
| ROWTYPE_MISMATCH | ORA-06504 | 할당문에서 호스트 커서 변수와 PL/SQL 커서 변수의 데이터 형이 불일치 할 때 발생되는 예외. |
