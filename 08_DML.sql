-- 08. DML(Data Manipulation Language)

/* DML 종류
INSERT : 테이블에 새로운 행 삽입
UPDATE : 테이블에 있는 행의 내용 갱신
DELETE : 테이블 행 삭제
*/

-- 1. INSERT
-- INSERT INTO 테이블이름 [(열이름1, 열이름2)] VALUES(데이터값1, 데이터값2)
-- 예제 8.1 departments 테이블에 department_id가 271, department_name이 'Sample_Dept'
-- manager_id가 200, location_id가 1700인 행을 삽입
INSERT INTO departments (department_id, department_name, manager_id, location_id) VALUES(271, 'Sample_Dept', 200, 1700);
SELECT * FROM departments;

-- 예제 8.2 departments 테이블에 department_id가 271, department_name이 'Sample_Dept'
-- manager_id가 200, location_id가 1700인 행을 삽입(열 이름 생략)
-- INSERT INTO 테이블이름 VALUES(데이터값)
INSERT INTO departments VALUES(272, 'Sample_Dept', 200, 1700);
SELECT * FROM departments;


-- 2. UPDATE
-- UPDATE 테이블이름 SET 변경열 = 변경데이터값 [WEHRE 조건식]
-- 예제 8.3 departments 테이블에 department_name이 'Sample_Dept' 행을 찾아서
-- manager_id를 201, location_id를 1800으로 변경
UPDATE departments
SET manager_id = 201,
    location_id = 1800
WHERE department_name = 'Sample_Dept';
SELECT * FROM departments;

-- 예제 8.4 departments 테이블에서 department_id가 40인 manager_id와 location_id의 데이터 값 찾고
-- department_name이 'Sample_Dept'인 행의 manager_id와 location_id를 찾아낸 데이터 값과 동일하게 변경
UPDATE departments
SET (manager_id, location_id) = ( SELECT manager_id, location_id
                                  FROM departments
                                  WHERE department_id = 40)
WHERE department_name = 'Sample_Dept';
SELECT * FROM departments WHERE department_name = 'Sample_Dept';


-- 3. DELETE
-- DELETE FROM 테이블이름 [WHERE 조건식];
-- 예제 8.5 departments 테이블에서 department_name이 'Sample_Dept'인 행 삭제
DELETE FROM departments WHERE department_name = 'Sample_Dept';
