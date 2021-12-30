-- 11. 관계형 데이터베이스의 주요 지식

-- 1. 뷰:가상의 테이블

/* 뷰의 특징
- 뷰는 데이터 가공을 통해 마치 테이블처럼 내용 보여줌
- 자주 쓰거나 복잡합 SQL문의 겨로가를 미리 만들어 놓을 수 있음
- 여러 테이블 조인하여 하나의 뷰로 생성 가능 ex) 테이블 세개 조인하여 결과를 하나의 뷰로 만듬
- 사용자별 접근 권한 다르게 가능
- 각기 다른 DB 시스템에서 각각의 데이터 전달하는 경우에도 유용
*/

/* 뷰의 종류
1) 심플 뷰 : 하나의 테이블에서 데이터 생성, CREATE VIEW 명령어 사용
2) 컴플렉스 뷰 : 여러개 테이블 조인하여 데이터 생성, CREATE VIEW 명령어 사용
3) 인라인 뷰 : SELECT 문의 FROM 절에 기술한 SELECT 문, 1회용 뷰로 권한 제어 불가능
*/

-- 예제 11-1 employees 테이블과 emp_details_view뷰를 조인하여 employee_id가 100인 직원의
-- employee_id, hire_Date, department_name, job_title 추력
SELECT A.employee_id, A.hire_date, B.department_name, B.job_title
FROM employees A, emp_details_view B
WHERE A.employee_id = B.employee_id AND A.employee_id = 100;


-- 2. 옵티마이저:성능최적화 관리

/* RBO(Rule Based Optimizer)와 CBO(Cost Based Optimizer)방식 비교
1) 개념 : 사전에 정의된 규칙 기반 계획 || 최소 비용 계산, 실행 계획 수립
2) 기준 : 실행 우선순위 || 액세스 비용
3) 성능 : 사용자 SQL 작성 숙련도 || 옵티마이저 예측 성능
4) 특징 : 실행 계획의 예측 용이 || 저장된 통계 정보 활용
5) 고려 사항 : 저효율, 사용자의 규칙 이해도 || 예측 복잡, 비용 산출 공식 정확선


-- 3. 인덱스:빠른 검색을 위한 데이터 주소록

/* 인덱스 특징
- 테이블 데이터 값에 빠르게 액세스하도록 하는 DB 객체
- 데이터 빠르게 찾을 수 있으므로 디스크 액세스 횟수 줄일 수 있음
- DB 시스템이 인덱스 자동 사용 및 유지 보수 하므로 사용자는 인덱스를 직접 조작 필요 없음(수동 생성 가능)
- 언제든지 생성/삭제 할 수 있으며 테이블이나 다른 인덱스에 영향 주지 않음
*/

-- 데이터 조회 원리

/* B 트리 인덱스 종류
1) Unique Index : 중복 데이터가 없는 경우(Uniuqe)에 사용 || 기본키, 유일키 데이터
2) Non-Unique Index : 중복 데이터 있는 경우 빠른 검색 결과 보장 || 인덱스가 필요한 일반적 데이터
3) Descending Index : 내림차순 데이터 값으로 인덱스 생성 }} 매출, 최근일자 등
4) Composite Index : 여러 열 합쳐서 하나의 인덱스 생성 : 여러 조건이 필요한 경우(고객번호 and 성별)
*/