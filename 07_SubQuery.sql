-- 07. 서브쿼리(SubQuery)

/* 서브쿼리 종류
단일행 서브쿼리 : 하나의 행 검색 서브쿼리
다중행 서브쿼리 : 하나 이상의 행 검색 서브쿼리
다중열 서브쿼리 : 하나 이상의 열 검색 서브쿼리
*/

/* 서브쿼리 종류에 따른 사용 연산자 종류
단일행 연산자 || =,>,>=,<,<=,<>,!= || 단일행, 다중열 서브쿼리
다중행 연산자 || IN, NOT IN, EXISTS, ANY, ALL || 다중행, 다중열 서브쿼리
*/

/* 다중행 연산자 종류
IN : 같은값
NOT IN : 같은 값 아님
EXISTS : 값 있으면 반환
ANY : 최소 하나라도 만족하는 것(OR), <,=등 비교 연산자와 같이 사용
ALL : 모두 만족하는 것(AND), <,=등 비교 연산자와 같이 사용
*/

-- 1. 단일행 서브쿼리
-- 예제 employees 테이블의 last_name이 'De Haan' 직원과 salary가 동일한 직원 출력
SELECT *
FROM employees A
WHERE A.salary = (
                  SELECT salary
                  FROM employees
                  WHERE last_name = 'De Haan'
                  );
-- WHERE A.salary = 17000과 동일한 값

-- 2. 다중행 서브쿼리
-- 예제 7-2 employees 테이블에서 department_id별로 가장 낮은 salary 찾아내고
-- 찾아낸 salary에 해당 직원이 누구인지 다중행 서브쿼리 이용
SELECT *
FROM employees A
WHERE A.salary IN (
                   SELECT MIN(salary) AS 최저급여
                   FROM employees
                   GROUP BY department_id
                   )
ORDER by A.salary DESC;

-- 3. 다중열 서브쿼리
-- 예제 7-3 employees 테이블에서 job_id별로 가장 낮은 salary가 얼마인지 찾아내고,
-- 찾아낸 job_id별 salary에 해당 직원이 누구인지 다중열 서브쿼리 이용
SELECT *
FROM employees A
WHERE (A.job_id, A.salary) IN (
                               SELECT job_id, MIN(salary) AS 그룹별급여
                               FROM employees
                               GROUP BY job_id
                               )
ORDER BY A.salary DESC;

SELECT job_id, MIN(salary) AS 그룹별급여
FROM employees
GROUP BY job_id;


-- 4. FROM 절 서브쿼리 : 인라인 뷰
-- 예제 7-4 직원 중에서 department_name이 IT인 직원 정보를 인라인 뷰를 이용해 출력
-- 테이블명에 AS로 별칭주면 에러나므로 제외함
SELECT *
FROM employees A,
                ( SELECT department_id
                  FROM departments
                  WHERE department_name= 'IT') B
WHERE A.department_id = B.department_id;
