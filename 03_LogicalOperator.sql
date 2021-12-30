-- 03. 논리 연산자 : 조건 논리 계속 연결하기

-- AND 연산자(교집합)
-- 예제 3-18 employees 테이블에서 salary가 4000을 초과하면서 job_id가 IT_PROG인 값 조회
SELECT *
FROM employees
WHERE salary > 4000 AND job_id = 'IT_PROG';

-- OR 연산자(합집합)
-- 예제 3-19 employees 테이블에서 salary가 4000을 초과하면서, job_id가 IT_PROG거나 FI_ACCOUNT인 경우 조회
SELECT *
FROM employees
WHERE salary > 4000 and job_id = 'IT_PROG' OR job_id = 'FI_ACCOUNT';

-- NOT 연산자
-- 예제 3-20 employees 테이블에서 employee_id가 105가 아닌 직원 조회
SELECT *
FROM employees
WHERE employee_id <> 105;

-- 예제 3-21 employees 테이블에서 manager_id가 null 값 아니 직원 조회
SELECT *
FROM employees
WHERE manager_id IS NOT NULL;
