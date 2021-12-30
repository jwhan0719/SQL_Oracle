-- 01. SELECT문의 기본 문법

-- 1. SQL문 작성 규칙
SELECT *
FROM employees A,
    (
        SELECT *
        FROM departments
        WHERE department_id = 20
    ) B
WHERE A.department_id = B.department_id;

-- 2. 전체 데이터 조회
-- 예제 3-1
SELECT *
FROM employees;

-- 3. 원하는 열만 조회하고 정렬하기
-- 예제 3-2
SELECT employee_id, first_name, last_name
FROM employees

-- 예제 3-3
SELECT employee_id, first_name, last_name
FROM employees
ORDER BY employee_id DESC;

-- 4. 중복된 출력 값 제거하기
-- 예제 3-4
SELECT DISTINCT job_id
FROM employees;

-- 5. 별칭 사용
-- 예제 3-5
SELECT employee_id AS 사원번호, first_name AS 이름, last_name AS 성
FROM employees;

-- 6. 데이터 값 연결
-- 예제 3-6
SELECT employee_id, first_name||last_name
FROM employees;

-- 예제 3-7
SELECT employee_id, 
       first_name||last_name,
       email||'@'||'company.com'
FROM employees;

-- 7. 산술 처리
-- 예제 3-8
SELECT employee_id, salary, salary+500, salary-100, (salary*1.1)/2
FROM employees;

-- 예제 3-9
SELECT employee_id AS 사원번호,
       salary AS 급여,
       salary+500 AS 추가급여,
       salary-100 AS 인하급여,
       (salary*1.1)/2 AS 조정급여
FROM employees;
