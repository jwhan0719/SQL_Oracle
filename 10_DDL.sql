-- 10. DDL(Data Definition Language)

-- 1. CREATE
-- CREATE TABLE 테이블이름 (열이름1 데이터타입, 열이름2 데이터타입(자릿수)
-- 예제 10.1 product_id(number 타입), product_name(vachar2 타입, 20자리) manu_date(data 타입)
-- 열이 있음 sample_product 이름의 테이블 생성
CREATE TABLE sample_product
      ( product_id number,
        product_name varchar2(20),
        manu_date date
      );
SELECT * FROM sample_product;
-- DDL 명령어는 실행시 자동 커밋

INSERT INTO sample_product VALUES(1, 'television', to_date('140101', 'YYMMDD'));
INSERT INTO sample_product VALUES(2, 'washer', to_date('150101', 'YYMMDD'));
INSERT INTO sample_product VALUES(3, 'cleaner', to_date('160101', 'YYMMDD'));
SELECT * FROM sample_product;
-- DML 명령어는 실행시 수동으로 커밋
commit;


-- 2. ALTER

-- 1) 열 추가(ADD)
-- ALTER TABLE 테이블이름 ADD(열이름1 데이터타입, 열이름2 데이터타입)
-- 예제 10-2 sample_product 테이블에 factory(varchar2 타입, 10자리)열 추가
ALTER TABLE sample_product ADD(factory varchar2(10));
select * from sample_product;

-- 2) 열 수정(MODIFY)
-- ALTER TABLE 테이블이름 MODIFY(열이름1 데이터타입, 열이름2 데이터타입)
-- 예제 10-3 sample_product 테이블에 있는 fatory 열의 데이터 타입과 크기를 char 타입 10자리로 변경
ALTER TABLE sample_product MODIFY(factory char(10));

-- 3) 열 이름 변경(RENAME COLUMN)
-- ALTER TABLE 테이블이름 RENAME COLUMN 열이름1 to 바꾸려는 열이름1
-- 예제 10-4 sample_product 테이블에 factory 열 이름을 factory_name으로 변경
ALTER TABLE sample_product RENAME COLUMN factory to factory_name;
SELECT * FROM sample_product;

-- 4) 열 삭제(DROP COLUMN)
-- ALTER TABLE 테이블이름 DROP COLUMN 열이름
-- 예제 10-5 sample_product 테이블의 factory_name열 삭제
ALTER TABLE sample_product DROP COLUMN factory_name;
SELECT * FROM sample_product;


-- 3. TRUNCATE(테이블 내용 삭제)
-- TRUNCATE TABLE 테이블이름
-- 모든 데이터가 삭제되지만 테이블 구조는 그대로, 삭제 여부 안묻고 삭제된 데이터 자동 커밋
-- 예제 10-6 sample_product 테이블을 TRUNCATE
TRUNCATE TABLE sample_product;
SELECT * FROM sample_product;


-- 4. DROP(테이블 삭제)
-- DROP TABLE 테이블 이름
-- TRUNCATE와 다르게 테이블 포함 전체 삭제
DROP TABLE sample_product;
SELECT * FROM sample_product;
