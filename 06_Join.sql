-- 06. 조인(join)

/* 조인기법 조율 
곱집합(cartesian product) - 가능한 모든 행 조인
동등 조인(equai join) - 조인 조건 정확히 일치하는 경우에 결과 출력
비동등 조인(non equi join) - 조인 조건 정확히 일치하지 않는 경우에 결과 출력
외부 조인(outer join) - 조인 조건이 정확히 일치하지 않아도 모든 결과 출력
자체 조인(self join) - 자체 테이블에서 조인할 때 사용
*/

-- 01. 동등 조인
-- 예제 6-1 employees 테이블과 departments 테이블과 locations 테이블 조인하여
-- 각 직원이 어느 부서에 속하는지와 부서의 소재지가 어디인지 조회
SELECT A.employee_id, A.department_id, B.department_name, C.location_id, C.city
FROM employees A, departments B, locations C
WHERE A.department_id = B.department_id AND B.location_id = C.location_id;

-- 02. 외부 조인
-- 예제 6-2 employees 테이블과 department 테이블은 department_id로 외부 조인하여
-- department_id가 null 값인 Kimberely Grant도 함께 출력
SELECT A.employee_id, A.first_name, A.last_name, B.department_id, B.department_name
FROM employees A, departments B
WHERE A.department_id = B.department_id(+)
AND A.first_name = 'Kimberely';

-- 03. 자체 조인
-- 예제 6-3 employees 테이블을 자체 조인하여 직원별 담당 매니저가 누구인지 조회
SELECT A.employee_id, A.first_name||' '||A.last_name AS employee_name,
       A.manager_id, B.first_name||' '||B.last_name AS manager_name
FROM employees A, employees B
WHERE A.manager_id = B.employee_id
ORDER BY 1;

-- 04 집합 연산자
-- UNION : SELECCT 문의 조회 결과의 합집합, 중복되는 행은 한번만 출력
-- 예제 6-4 employee 테이블의 department_id 집합과 departments 테이블의 department_id 집합의 UNION
SELECT department_id FROM employees 
UNION
SELECT department_id FROM departments;

-- UNION ALL : SELECT 문의 조회 결과의 합집합, 중복되는 행도 그대로 출력
-- 예제 6-5 employee 테이블의 department_id 집합과 departments 테이블의 department_id 집합의 UNION ALL
SELECT department_id FROM employees 
UNION ALL
SELECT department_id FROM departments
ORDER BY 1;

-- INTERSECT : SELECT 문의 조회 결과의 교집합, 중복되는 행만 출력
-- 예제 6-6 employee 테이블의 department_id 집합과 departments 테이블의 department_id 집합의 INTERSECT
SELECT department_id FROM employees 
INTERSECT
SELECT department_id FROM departments
ORDER BY 1;

-- MINUS : 첫 번째 SELECT 문의 조회 결고에서 두 번째 조회 결과 제외
-- 예제 6-6 departments 테이블의 department_id 집합에서 employee 테이블의 department_id 집합의 MINUS
SELECT department_id FROM departments
MINUS
SELECT department_id FROM employees; 