-- 04. 함수(Function)

-- 1. 문자 타입 함수
-- LOWER/UPPER/INITCAP('문자열' or 열이름)
-- 예제 4-1 employees 테이블에서 last_name을 소문자/대문자 출력, emali 첫 번째 문자 대문자 출력
SELECT last_name,
       LOWER(last_name) AS LOWER적용,
       UPPER(last_name) AS UPPER적용,
       email,
       INITCAP(email) INITCAT적용
FROM employees;

-- SUBSTR('문자열' or 열이름, 시작위치, 길이)
-- 예제 4-2 employees 테이블에서 job_id 데이터 값 첫째 자리부터 두개 문자 출력
SELECT job_id, SUBSTR(job_id, 1, 2) AS 적용결과
FROM employees;

-- REPLACE('문자열' or 열이름, '바꾸려는 문자열', '바뀔 문자열')
-- 예제 4-3 employees 테이블에서 job_id 문자열 값이 ACCOUNT면 AACNT로 출력
SELECT job_id, REPLACE(job_id, 'ACCOUNT', 'ACCNT') AS 적용결과
FROM employees;

-- LPAD/RPAD('문자열' or 열이름, '만들어질 자릿수(숫자지정)', '채워질 문자(1,a,abc,&,*등)')
-- 예제 4-4 employees 테이블에서 first_name에 대해 12자리 문자열 자리 만들되 first_name의 데이터 값이 12자리보다 작으면 왼쪽부터 * 채워서 출력 
SELECT first_name, LPAD(first_name, 12, '*') AS LPAD적용결과
FROM employees;

-- LTRIM/RTRIM('문자열', or 열이름, '삭제할문자')
-- 예제 4-5 employees 테이블에서 job_id의 데이터 값에 대해 왼쪽 방향부터 'F' 문자 만나면 삭제, 오른쪽 방향에서 'T'문자 만나면 삭제
SELECT job_id,
       LTRIM(job_id, 'F') AS LTRIM적용결과,
       RTRIM(job_id, 'T') AS RTRIM적용결과
FROM employees;

-- TRIM('문자열' or 열이름), 공백제거
SELECT 'start'||TRIM('    - space -    ')||'end' 제거된_공백
FROM dual;


-- 2. 숫자 타입 함수
-- ROUND(숫자 or 열이름, 반올림한 자리값(0이 소수점 첫째자리))
-- 예제 4-6 employees 테이블에서 salary를 30일로 나눈 후 나눈 값의 소수점 첫째, 둘째 자리, 정수 첫째 자리에서 반올림한 값 출력
SELECT salary,
       salary/30 AS 일급,
       ROUND(salary/30, 0) AS 소수점첫째자리,
       ROUND(salary/30, 1) AS 소수점둘째자리,
       ROUND(salary/30, -1) AS 정수첫째자리
FROM employees;

-- TRUNC(숫자 or 열이름, 절삭할 자리 값(0이 소수점 첫째자리))
-- 예제 4-7 employees 테이블에서 salary를 30일로 나눈 후 나눈 값의 소수점 첫째, 둘째 자리, 정수 첫째 자리에서 절삭 출력
SELECT salary,
       salary/30 AS 일급,
       TRUNC(salary/30, 0) AS 소수점첫째자리,
       TRUNC(salary/30, 1) AS 소수점둘째자리,
       TRUNC(salary/30, -1) AS 정수첫째자리
FROM employees;


-- 3. 날짜 타입 함수
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD/HH24:MI') AS 오늘날짜,
       SYSDATE + 1 AS 현재날짜에서하루추가,
       SYSDATE - 1 AS 현재날짜에서하루빼기,
       TO_DATE('20171202') - TO_DATE('20171201') AS 날짜빼기,
       SYSDATE + 13/24 AS 날짜에시간더하기
FROM DUAL;

-- MONTHS_BETWEEN(날짜, 날짜)
-- 예제 4-8 employees 테이블에서 department_id가 100인 직원에 대해 오늘날짜, hire_date, 오늘날짜와 hire_date 사이의 개월수 출력
SELECT SYSDATE, hire_date, MONTHS_BETWEEN(SYSDATE, hire_date) AS 사이개월수
FROM employees
WHERE department_id = 100;

-- ADD_MONTHS(날짜, 숫자)
-- 예제 4-9 employees 테이블에서 employee_id가 100과 106 사이인 직원의 hire_date에 3개월 더한 값, 3개월 뺀 값 출력
SELECT hire_date,
       ADD_MONTHS(hire_date, 3) AS 삼개월더한값,
       ADD_MONTHS(hire_date, -3) AS 삼개월뺀값
FROM employees
WHERE employee_id BETWEEN 100 AND 106;

-- NEXT_DAY(날짜, '요일' or 숫자), 숫자 1(일요일), 2(월요일), 돌아요는 요일 날짜 계산 
-- 예제 4-10 employees 테이블에서 employee_id가 100과 106사이인 직원의 hire_Date가 가장 가까운 금요일 날짜 언제인지 문자/숫자 지정 출력
SELECT hire_date,
       NEXT_DAY(hire_date, '금요일') AS 문자지정,
       NEXT_DAY(hire_date, 6) AS 숫자지정
FROM employees
WHERE employee_id BETWEEN 100 AND 106;

-- LAST_DAY(날짜)
-- 예제 4-11 employees 테이블에서 employee_id가 100과 106 사이인 직원의 hire_date 기준 해당월 마지막 날짜 출력
SELECT hire_date,
       LAST_DAY(hire_date) AS 해당월마지막날짜
FROM employees
WHERE employee_id BETWEEN 100 AND 106;

-- ROUND or TRUNC(날짜, 지정값(날짜인자값, MONTH, YEAR))
-- 예제 4-12 employees 테이블에서 employee_id가 100과 106 사이인 직원의 hire_date에 대해 월/연 기준 반올림, 월/연 기준 절삭 적용 출력
SELECT hire_date,
       ROUND(hire_date, 'MONTH') AS 월기준반올림,
       ROUND(hire_date, 'YEAR') AS 연기준반올림,
       TRUNC(hire_date, 'MONTH') AS 월기준절삭,
       TRUNC(hire_date, 'YEAR') AS 연기준절삭
FROM employees
WHERE employee_id BETWEEN 100 AND 106;


-- 4. 변환함수
-- 날짜 및 시간 형식 변환하기
-- TO_CHAR(날짜 데이터 타입, '지정 형식')

-- 날짜 지정 형식
SELECT TO_CHAR(SYSDATE, 'YY') AS 현재연도1,
       TO_CHAR(SYSDATE, 'YYYY') AS 현재연도2,
       TO_CHAR(SYSDATE, 'MM') AS 현재월1,
       TO_CHAR(SYSDATE, 'MON') AS 현재월2,
       TO_CHAR(SYSDATE, 'YYYYMMDD'),
       TO_CHAR(TO_DATE('20171008'), 'YYYYMMDD')
FROM dual;
-- 시간 지정 형식
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS PM') AS 시간형식,
       TO_CHAR(SYSDATE, 'YYYY/MM/DD HH:MI:SS PM') AS 날짜와시간조합
FROM dual;
-- 기타 형식
SELECT TO_CHAR(SYSDATE, 'HH-MI-SS PM') AS 시간형식,
       TO_CHAR(SYSDATE, ' "날짜:" YYYY/MM/DD "시각:" HH:MI:SS PM ') AS 날짜와시각표현
FROM dual;

-- 숫자 형식 변환하기
-- TO_CHAR(숫자 데이터 타입, '지정 형식')

-- TO_NUMBER(number)
SELECT TO_NUMBER('123')
FROM dual;

-- TO_DATE(문자열, '지정 형식')
SELECT TO_DATE('20171007', 'YYMMDD')
FROM dual;


-- 5. 일반함수
-- NVL(열 이름, 치환값(null에서 변환하고자 하는 값))
-- 예제 4-13 employess 테이블에서 salary에 commission_pct를 곱하되 null일때는 1로 치환
SELECT salary * NVL(commission_pct, 1) AS 곱셉값
FROM employees;

-- DECODE(열이름, 조건값, 치환값(조건해당값), 기본값(조건미해당값))
-- 예제 4-14 employees 테이블에서 first_name, last_name, department_id, salary를 출력하되
-- department_id가 60인 경우 급여 10%인상값 계산, 나머지는 원래값 출력
-- 그리고 department_id가 60인 경우 '10%'인상 출력, 나머지는 '미인상' 출력
SELECT first_name, last_name, department_id, salary AS 원래급여,
       DECODE(department_id, 60, salary*1.1, salary) AS 조정급여,
       DECODE(department_id, 60, '10%인상', '미인상') AS 인상여부
FROM employees;

-- CASE WHEN 조건1 THEN 출력값1 WHEN 조건2 THEN 출력값2 ELSE 출력값3 END
-- 예제 4-15 employees 테이블에서 job_id가 IT_PROG라면 employee_id, first_name, last_name,
-- salary 출력하되 salary가 9000 이상이면 상위급여, 6000-8999 이면 중위급여, 그외 하위급여로 출력
SELECT employee_id, first_name, last_name, salary,
       CASE
           WHEN salary >= 9000 THEN '상위급여'
           WHEN salary BETWEEN 6000 AND 8999 THEN '중위급여'
           ELSE '하위급여'
       END AS 급여등급
FROM employees
WHERE job_id = 'IT_PROG';

-- RANK() OVER([PARTITION BY 열 이름(그룹 순위시 사용, 생략가능)] ORDER BY 열 이름)
-- 예제 4-16 순위함수를 이용해 salary 값이 높은 순서대로 순위 출력
SELECT employee_id, salary,
       RANK()       OVER(ORDER BY salary DESC) AS RANK_급여,
       DENSE_RANK() OVER(ORDER BY salary DESC) AS DENSE_RANK_급여,
       ROW_NUMBER() OVER(ORDER BY salary DESC) AS ROW_NUMBER_급여
FROM employees;

-- 예제 4-17 순위함수를 이용해 employees테이블 직원이 속한 department_id 안에서 salary 값 높은 순서대로 순위 출력
SELECT A.employee_id, A.department_id, B.department_name, salary,
       RANK()       OVER(PARTITION BY A.department_id ORDER BY salary DESC) AS RANK_급여,
       DENSE_RANK() OVER(PARTITION BY A.department_id ORDER BY salary DESC) AS DENSE_RANK_급여,
       ROW_NUMBER() OVER(PARTITION BY A.department_id ORDER BY salary DESC) AS ROW_NUMBER_급여
FROM employees A, departments B
WHERE A.department_id = B.department_id
ORDER BY B.department_id, A.salary DESC;


-- 6. 그룹함수
-- COUNT(열 이름)
-- 예제 4-18 employees 테이블에서 salary의 행 개수 출력
SELECT COUNT(salary)
FROM employees;

-- SUM(열 이름) | AVG(열 이름)
-- 예제 4-19 employees 테이블에서 salary의 합계와 평균 구하고 AVG함수 안하고 평균 출력
SELECT SUM(salary) AS 합계,
       AVG(salary) AS 평균,
       SUM(salary)/COUNT(salary) AS 계산평균
FROM employees;

-- MAX(열 이름) | MIN(열 이름)
-- 예제 4-20 employees 테이블에서 salary과 first_name의 최대/최소값 출력
SELECT MAX(salary) AS 최댓값,
       MIN(salary) AS 최솟값,
       MAX(first_name) AS 최대문자값,
       MIN(first_name) AS 최소문자값
FROM employees;

-- GROUP BY
-- 예제 4-21 employees 테이블에서 employee_id가 10 이상인 직원에 대해 job_id 별로 그룹화하여
-- job_id별 총 급여와 평균 급여 구하고, 총 급여별 내림차순 정렬 출력
SELECT job_id AS 직무, SUM(salary) AS 직무별_총급여, AVG(salary) AS 직무별_평균급여
FROM employees
WHERE employee_id >= 10
GROUP BY job_id
ORDER BY 직무별_총급여 DESC;

-- HAVING
-- 예제 4-22 employees 테이블에서 employee_id가 10 이상인 직원에 대해 job_id별로 그룹화하여
-- job_id별 총/평균 급여 구하되, job_id별 총 급여가 30000보다 큰값만 출력, job_id별 총급여 내림차순
SELECT job_id AS 직무, SUM(salary) AS 직무별_총급여, AVG(salary) AS 직무별_평균급여
FROM employees
WHERE employee_id >= 10
GROUP BY job_id
HAVING SUM(salary) > 30000
ORDER BY 직무별_총급여 DESC;
