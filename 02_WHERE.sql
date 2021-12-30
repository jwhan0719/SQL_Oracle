-- 02. WHWER 조건 절을 활용한 데이터 검색

-- 1. 비교 연산자
-- 예제 3-10 employee_id가 100인 직원 정보 출력
SELECT *
FROM employees
WHERE employee_id = 100;

-- 예제 3-11 employee 테이블에서 first_name이 David인 직원 정보 출력
SELECT *
FROM employees
WHERE first_name ='David';

-- 예제 3-12 employees 테이블에서 employee_id가 105 이상인 직원 정보 출력
SELECT *
FROM employees
WHERE employee_id >= 105;

-- 2. 조회 조건 확장
-- BETWEEN 연산자
-- 예제 3-13 employees 테이블에서 salary가 10000이상 20000이하 직원 정보 출력
SELECT *
FROM employees
WHERE salary BETWEEN 10000 AND 20000;

-- IN 연산자
-- 예제 3-14 employees 테이블에서 salary가 10000, 17000, 24000인 직원 정보 출력
SELECT *
FROM employees
WHERE salary IN (10000, 17000, 24000);

-- LIKE 연산자
-- 예제 3-15 employees 테이블에서 job_id값이 AD ㅍ함하는 모든(%) 데이터 조회
SELECT *
FROM employees
WHERE job_id LIKE 'AD%';

-- 예제 3-16 employees 테이블에서 AD 포함하면서 AD 뒤에 따라오는 문자열이 3자리인 데이터 값을 갖는 직원 정보 조회
SELECT *
FROM employees
WHERE job_id LIKE 'AD___';

-- IS NULL 연산자
-- 예제 3-17 employees 테이블에서 manager_id가 null 값인 직원 정보 출력
SELECT *
FROM employees
WHERE manager_id IS NULL;
