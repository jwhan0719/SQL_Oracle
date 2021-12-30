-- 12. 레스토랑 신규 매출 분석

-- 1. 실습 데이터 세팅

-- 인코딩 : 도구-환경설정-환경-인코딩-UTF-8

/* 실습용 데이터 정보
1) Address : 주소정보 || 25행
2) Customer : 고객정보 || 183행
3) Item : 상품정보 || 10행
4) Reservation : 주문예약,취소정보 || 396행
5) Order_Info : 주문상세정보 || 391행
*/

-- 실습용 데이터 테이블 생성
@c:\sql_practice\create_table.sql;

-- 실습용 데이터 삽입
@c:\sql_practice\1.address.sql;
@c:\sql_practice\2.customer.sql;
@c:\sql_practice\3.item.sql;
@c:\sql_practice\4.reservation.sql;
@c:\sql_practice\5.order_info.sql;

SELECT * FROM order_info;

-- 실습용 데이터 테이블 삭제
@c:\sql_practice\delete_table.sql;


-- 2. 현재 상황

/* 현재 상황
- 서울 곳곳에 패밀리 레스토랑 지점 운영 중
- 지금까지 주로 오프라인과 가족 고객 위주 매출 활동중
- 판매 활성화를 위해 온라인 예약 시스템 개편과 온라인 예약 전용 메뉴 상품 기획 출시
- 전용 상품은 오프라인 예약 불가능하고 온라인에서만 예약 가능 메뉴이며 기존 상품도 온라인 예약 가능
- 서울 모든 지점에서 전용 상품 서비스 중, 기간은 2017/06/01 ~ 2017/12/31(총 6개월)
*/

/* 온라인 예약 매출 시스템의 DB ERD
- DB 테이블 총 5개(고객정보, 주소정보, 예약정보, 주문정보, 상품정보)
- 주소는 고객 여러 건 갖고, 주소가 없어도 고객 존재 가능 = zip_code가 없어도 고객 있을 수 있다.
- 고객은 예약을 여러 건 갖고, 고객 없이는 예약 존재 불가능 = 고객 한명은 예약 여러건 가질 수 있고 예약할 때는 customer_id 필수
- 예약은 주문 여러건 갖고, 예약 정보 없이도 주문 정보 존재 가능, 단 주문정보는 당일 예약에 대해 순차적으로 생성된다고 가정
- 상품 주문 여러건 갖고, 상품이 없을 경우 주문은 존재 불가능 = 주문은 item_id를 필수로 갖고 주문 번호는 주문 완료 경우에만 생성된다고 가정

정리
- 고객정보를 필수로 예약정보 있어야 함
- 예약정보는 주문정보 여러개 가질 수 있음
- 주문정보의 주문번호는 상품번호와 합쳐져 복합키로 구성되어 있음
- 주문번호는 중복 없는 상품 번호 여러개 갖음
*/


-- 3. 매출 분석

-- 1) 특정 통계 값 계산
-- 분석 1 전체 상품의 주문 완료 건 총매출, 평균매출, 최고매출, 최저매출 출력
-- Reservation(주문예약, 취소정보) 테이블과 Order_Info(주문상세정보) 테이블 활용

-- 테이블 컬럼 조회
SELECT * FROM COLS WHERE TABLE_NAME = 'RESERVATION';
SELECT * FROM COLS WHERE TABLE_NAME = 'ORDER_INFO';
-- RESERV_NO로 조인, 예약완료->주문완료

SELECT COUNT(*) AS 주문완료건수,
       SUM(B.sales) AS 총매출,
       AVG(B.sales) AS 평균매출,
       MAX(B.sales) AS 최고매출,
       MIN(B.sales) AS 최저매출
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no;


-- 2) 비교분석:판매량과 매출액 비교
-- 분석 2 전체 상품의 총 판매량과, 총 매출액, 전용 상품의 판매량과 매출액을 출력

-- 테이블 컬럼 조회
SELECT * FROM COLS WHERE TABLE_NAME = 'RESERVATION';
SELECT * FROM COLS WHERE TABLE_NAME = 'ORDER_INFO';

-- 전용상품은 ORDER_INFO TABLE의 ITEM_ID = M0001을 의미
SELECT COUNT(*) AS 총판매량,
       SUM(B.sales) AS 총매출,
       -- DECODE(컬럼, 조건, 조건해당할경우, 조건해당안할경우)
       SUM(DECODE(B.item_id, 'M0001', 1, 0)) AS 전용상품판매량,
       SUM(DECODE(B.item_id, 'M0001', B.sales, 0)) AS 전용상품매출액
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no;
-- AND A.cancel = 'N' 예약 취소건 제외이지만 order_info 테이블에는 예약완료 건만 존재


-- 3) 그룹화 분석:상품별 매출 계산 및 순서 정렬
-- 분석3 각 상품별 전체 매출액을 내림차순 출력

-- 테이블 컬럼 조회
SELECT * FROM COLS WHERE TABLE_NAME = 'RESERVATION';
SELECT * FROM COLS WHERE TABLE_NAME = 'ORDER_INFO';
SELECT * FROM COLS WHERE TABLE_NAME = 'ITEM';

-- reservation과 order_info(reserv_no join)
-- order_info과 item(item_id join)
SELECT C.item_id AS 상품아이디,
       C.product_name AS 상품이름,
       SUM(B.sales) AS 상품매출
FROM reservation A, order_info B, item C
WHERE A.reserv_no = B.reserv_no
AND B.item_id = C.item_id
AND a.cancel = 'N'
GROUP BY C.item_id, C.product_name
ORDER BY SUM(B.sales) DESC;


-- 4) 시계열 분석:월별 상품 매출 분석
-- 분석4 모든 상품의 월별 매출액 출력

-- 테이블 컬럼 조회
SELECT * FROM COLS WHERE TABLE_NAME = 'RESERVATION';
SELECT * FROM COLS WHERE TABLE_NAME = 'ORDER_INFO';

SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
       SUM(DECODE(B.item_id, 'M0001', B.sales, 0)) AS SPECIAL_SET,
       SUM(DECODE(B.item_id, 'M0002', B.sales, 0)) AS PASTA,
       SUM(DECODE(B.item_id, 'M0003', B.sales, 0)) AS PIZZA,
       SUM(DECODE(B.item_id, 'M0004', B.sales, 0)) AS SEA_FOOD,
       SUM(DECODE(B.item_id, 'M0005', B.sales, 0)) AS STEAK,
       SUM(DECODE(B.item_id, 'M0006', B.sales, 0)) AS SALAD_BAR,
       SUM(DECODE(B.item_id, 'M0007', B.sales, 0)) AS SALAD,
       SUM(DECODE(B.item_id, 'M0008', B.sales, 0)) AS SANDWICH,
       SUM(DECODE(B.item_id, 'M0009', B.sales, 0)) AS WINE,
       SUM(DECODE(B.item_id, 'M0010', B.sales, 0)) AS JUCIE
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no
AND A.cancel = 'N'
GROUP BY SUBSTR(A.reserv_date, 1, 6)
ORDER BY SUBSTR(A.reserv_date, 1, 6);


-- 5) 시계열 분석:월별 매출 분석
-- 분석5 월별 총 매출액과 전용 상품 매출액 출력
SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
       SUM(B.sales) AS 총매출액,
       SUM(DECODE(B.item_id, 'M0001', B.sales, 0)) AS 전용상품매출액
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no
AND A.cancel = 'N'
GROUP BY SUBSTR(A.reserv_date, 1, 6)
ORDER BY SUBSTR(A.reserv_date, 1, 6);


-- 6) 산술 계산:매출 기여율 추가
-- 분석6 분석5에 매출 기여율 추가, 기여울은 소수점 아래 두번째 자리에서 반올림 출력
SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
       SUM(B.sales) AS 총매출액,
       SUM(DECODE(B.item_id, 'M0001', b.sales, 0)) AS 전용상품매출액,
       SUM(B.sales) - SUM(DECODE(B.item_id, 'M0001', b.sales, 0)) AS 전용상품제외매출액,
       ROUND(SUM(DECODE(B.item_id, 'M0001', B.sales, 0)) / SUM(B.sales)*100, 1) AS 매출기여율
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no
AND A.cancel = 'N'
GROUP BY SUBSTR(A.reserv_date, 1, 6)
ORDER BY SUBSTR(A.reserv_date, 1, 6);


-- 7) 외부 조인:부족한 데이터 처리
-- 분석7 분석6에 총 예약 건수, 예약 취소 건수 추가
SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
       SUM(B.sales) AS 총매출액,
       SUM(DECODE(B.item_id, 'M0001', b.sales, 0)) AS 전용상품매출액,
       SUM(B.sales) - SUM(DECODE(B.item_id, 'M0001', b.sales, 0)) AS 전용상품제외매출액,
       ROUND(SUM(DECODE(B.item_id, 'M0001', B.sales, 0)) / SUM(B.sales)*100, 1) AS 매출기여율,
       COUNT(A.reserv_no) AS 총예약건수,
       SUM(DECODE(A.cancel, 'Y', 1, 0)) AS 예약취소건수,
       SUM(DECODE(A.cancel, 'N', 1, 0)) AS 예약완료건수
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no(+)
GROUP BY SUBSTR(A.reserv_date, 1, 6)
ORDER BY SUBSTR(A.reserv_date, 1, 6);
-- reservation 테이블에 reser_no가 있더라도 order_info에는 reserv_no가 없을 수 있기 때문에 데이터가 부족한 쪽에 외부조인


-- 8) 데이터처리:날짜 가공, 문자 붙이기
-- 분석8 분석7에 총 매출 대비 전용 상품의 판매율, 총 예약 건 대비 예약 취소율 추가
-- 소수점 아래 두번째 자리에서 반올림 ##.#% 형식 출력
SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
       SUM(B.sales) AS 총매출액,
       SUM(DECODE(B.item_id, 'M0001', b.sales, 0)) AS 전용상품매출액,
       SUM(B.sales) - SUM(DECODE(B.item_id, 'M0001', b.sales, 0)) AS 전용상품제외매출액,
       ROUND(SUM(DECODE(B.item_id, 'M0001', B.sales, 0)) / SUM(B.sales)*100, 1)||'%' AS 전용상품판매율,
       COUNT(A.reserv_no) AS 총예약건수,
       SUM(DECODE(A.cancel, 'Y', 1, 0)) AS 예약취소건수,
       SUM(DECODE(A.cancel, 'N', 1, 0)) AS 예약완료건수,
       ROUND(SUM(DECODE(A.cancel, 'Y', 1, 0)) / COUNT(A.reserv_no)*100, 1)||'%' AS 예약취소율
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no(+)
GROUP BY SUBSTR(A.reserv_date, 1, 6)
ORDER BY SUBSTR(A.reserv_date, 1, 6);


-- 9) 요일별 매출 분석:날짜 처리하기
-- 분석9 월별 전용 상품 매출액을 일요일부터 월요일까지 구분 출력
SELECT SUBSTR(reserv_date, 1, 6) AS 날짜,
       A.product_name 상품명,
       SUM(DECODE(A.WEEK, '1', A.sales, 0)) AS 일요일,
       SUM(DECODE(A.WEEK, '2', A.sales, 0)) AS 월요일,
       SUM(DECODE(A.WEEK, '3', A.sales, 0)) AS 화요일,
       SUM(DECODE(A.WEEK, '4', A.sales, 0)) AS 수요일,
       SUM(DECODE(A.WEEK, '5', A.sales, 0)) AS 목요일,
       SUM(DECODE(A.WEEK, '6', A.sales, 0)) AS 금요일,
       SUM(DECODE(A.WEEK, '7', A.sales, 0)) AS 토요일
FROM
    (
     SELECT A.reserv_date,
            C.product_name,
            TO_CHAR(TO_DATE(A.reserv_date, 'YYYYMMDD'), 'd') WEEK,
            B.sales
     FROM reservation A, order_info B, item C
     WHERE A.reserv_no = B.reserv_no
     AND B.item_id = C.item_id
     AND B.item_id = 'M0001'
     ) A
GROUP BY SUBSTR(reserv_date, 1, 6), A.product_name
ORDER BY SUBSTR(reserv_date, 1, 6);


-- 10) 순위 분석:월별 전용 상품 최대 실적 지점 확인
-- 분석10 월별 전용 상품 매출 1위부터 3위까지 지점 확인
SELECT *
    FROM
    (
     SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
            A.branch                    AS 지점,
            SUM(B.sales)                AS 전용상품매출,
            RANK() OVER(PARTITION BY SUBSTR(A.reserv_date, 1, 6)
            ORDER BY SUM(B.sales) DESC) AS 지점순위
    FROM reservation A, order_info B
    WHERE A.reserv_no = B.reserv_no
    AND A.cancel = 'N'
    AND B.item_id = 'M0001'
    GROUP BY SUBSTR(A.reserv_date, 1, 6), A.branch
    ORDER BY SUBSTR(A.reserv_date, 1 ,6)
    ) A
    WHERE A.지점순위 <= 3;

-- 1위 지점만 조회
SELECT *
    FROM
    (
     SELECT SUBSTR(A.reserv_date, 1, 6) AS 매출월,
            A.branch                    AS 지점,
            SUM(B.sales)                AS 전용상품매출,
            ROW_NUMBER() OVER(PARTITION BY SUBSTR(A.reserv_date, 1, 6)
            ORDER BY SUM(B.sales) DESC) 지점순위,
            DECODE(A.branch, '강남', 'A', '종로', 'A', '영등포', 'A', 'B') 지점등급
    FROM reservation A, order_info B
    WHERE A.reserv_no = B.reserv_no
    AND A.cancel = 'N'
    AND B.item_id = 'M0001'
    GROUP BY SUBSTR(A.reserv_date, 1, 6), A.branch,
          DECODE(A.branch, '강남', 'A', '종로', 'A', '영등포', 'A', 'B')
    ORDER BY SUBSTR(A.reserv_date, 1 ,6)
    ) A
    WHERE A.지점순위 = 1;


-- 11) 종합 리포트
-- 분석11 분석8 결과와 분석10 결과 항목을 월별로 합쳐서 리포트 생성
SELECT A.매출월                AS 매출월,
       MAX(총매출)             AS 총매출,
       MAX(전용상품외매출)      AS 전용상품외매출,
       MAX(전용상품매출)        AS 전용상품매출,
       MAX(전용상품판매율)      AS 전용상품판매율,
       MAX(총예약건)           AS 총예약건,
       MAX(예약완료건)         AS 예약완료건,
       MAX(예약취소건)         AS 예약취소건,
       MAX(예약취소율)         AS 예약취소율,
       MAX(최대매출지점)       AS 최대매출지점,
       MAX(지점매출액)         AS 지점매출액
FROM
(
    SELECT SUBSTR(A.reserv_date,1,6) AS 매출월, 
           SUM(B.sales) AS 총매출, 
           SUM(B.sales)
           - SUM(DECODE(B.item_id,'M0001',B.sales,0)) AS 전용상품외매출, 
           SUM(DECODE(B.item_id,'M0001',B.sales,0)) AS 전용상품매출,
           ROUND(SUM(DECODE(B.item_id,'M0001',B.sales,0))/SUM(B.sales)*100,1)||'%' AS 전용상품판매율,
           COUNT(A.reserv_no) AS 총예약건,
           SUM(DECODE(A.cancel,'N',1,0)) AS 예약완료건,
           SUM(DECODE(A.cancel,'Y',1,0)) AS 예약취소건,
           ROUND(SUM(DECODE(A.cancel,'Y',1,0))/COUNT(A.reserv_no)*100,1)||'%' AS 예약취소율,
           '' AS 최대매출지점,
           0  AS 지점매출액
    FROM reservation A, order_info B
    WHERE A.reserv_no = B.reserv_no(+)
    -- AND   A.cancel    = 'N'
    GROUP BY SUBSTR(A.reserv_date,1,6), '', 0
UNION
    SELECT A.매출월,
           0          AS 총매출,
           0          AS 전용상품외매출,
           0          AS 전용상품매출,
           ''         AS 전용상품판매율,
           0          AS 총예약건,
           0          AS 예약완료건,
           0          AS 예약취소건,
           ''         AS 예약취소율,
           A.지점      AS 최대매출지점,
           A.전용상품매출 AS 지점매출액 
    FROM 
    (
      SELECT SUBSTR(A.reserv_date,1,6) AS 매출월,
             A.branch                  AS 지점,
             SUM(B.sales)              AS 전용상품매출,
             ROW_NUMBER() OVER(PARTITION BY SUBSTR(A.reserv_date,1,6)   
      ORDER BY SUM(B.sales) DESC) AS 지점순위,
             DECODE(A.branch,'강남','A','종로','A','영등포','A','B') AS 지점등급
      FROM  reservation A, order_info B
      WHERE A.reserv_no = B.reserv_no
      AND   A.cancel = 'N'
      AND   B.item_id = 'M0001'
      GROUP BY SUBSTR(A.reserv_date,1,6), A.branch, 
          DECODE(A.branch,'강남','A','종로','A','영등포','A','B')
      ORDER BY SUBSTR(A.reserv_date,1,6)
    ) A
    WHERE A.지점순위 = 1 
    -- AND 지점등급 = 'A'
) A
GROUP BY A.매출월
ORDER BY A.매출월;



-- 4. 인구 통계 분석

-- 1) 인구 특징 통계 분석
-- 분석12 고객의 수, 남녀 숫자, 평균 나이, 평균 거래 기간 출력
SELECT COUNT(customer_id) AS 고객수,
       SUM(DECODE(sex_code, 'M', 1, 0)) AS 남자,
       SUM(DECODE(sex_code, 'F', 1, 0)) AS 여자,
       ROUND(AVG(MONTHS_BETWEEN(TO_DATE('20171231', 'YYYYMMDD'), TO_DATE(birth, 'YYYYMMDD')) / 12),1) AS 평균나이,
       ROUND(AVG(MONTHS_BETWEEN(TO_DATE('20171231','YYYYMMDD'), first_reg_date)),1) AS 평균거래기간
FROM customer;

-- 2) 개인화 분석:개인별 매출분석
-- 분석13 개인별 전체 상품 주문건수, 총 매출, 전용상품 주문건수, 전용상품 매출을 출력하여 전용상품 매출기준 내림차순
SELECT A.customer_id                            AS 고객아이디, 
       A.customer_name                          AS 고객이름, 
       COUNT(C.order_no)                        AS 전체상품주문건수, 
       SUM(C.sales)                             AS 총매출,
       SUM(DECODE(C.item_id, 'M0001', 1, 0))       AS 전용상품주문건수,
       SUM(DECODE(C.item_id, 'M0001', C.sales, 0)) AS 전용상품매출
FROM customer A, reservation B, order_info C
WHERE A.customer_id = B.customer_id
AND   B.reserv_no = C.reserv_no
AND   B.cancel = 'N'
GROUP BY A.customer_id, A.customer_name
ORDER BY SUM(DECODE(C.item_id, 'M0001', C.sales, 0)) DESC;


-- 3) 특징 분석:거주지와 직업 비율 분석
-- 분석14 상품 구매한 전체 고객의 거주지와 전용상품을 구매한 고객의 거주지를 각각 비교해보고
-- 상품 구매한 전체 고객의 직업과 전용 상품 구매한 고객의 직업 각각 비교

-- 전체 상품 구매 고객 거주지
SELECT B.address_detail         AS 주소,
       B.zip_code               AS 코드,
       COUNT(B.address_detail)  AS 사람수
FROM (
      SELECT DISTINCT A.customer_id, A.zip_code
      FROM  customer A, reservation B, order_info C
      WHERE A.customer_id = B.customer_id
      AND   B.reserv_no = C.reserv_no
      AND   B.cancel = 'N'
      ) A, address B
WHERE A.zip_code = B.zip_code
GROUP BY B.address_detail, B.zip_code 
ORDER BY COUNT(B.address_detail) DESC;

-- 전용 상품 구매 고객 거주지
SELECT B.address_detail         AS 주소,
       B.zip_code               AS 코드,
       COUNT(B.address_detail)  AS 사람수
FROM (
      SELECT DISTINCT A.customer_id, A.zip_code
      FROM  customer A, reservation B, order_info C
      WHERE A.customer_id = B.customer_id
      AND   B.reserv_no = C.reserv_no
      AND   B.cancel = 'N'
      AND   C.item_id = 'M0001'
      ) A, address B
WHERE A.zip_code = B.zip_code
GROUP BY B.address_detail, B.zip_code 
ORDER BY COUNT(B.address_detail) DESC;


-- 전체 상품 구매 고객의 직업
SELECT NVL(B.job,'정보없음')    AS 직업,
       COUNT(NVL(B.job,1))     AS 사람수
FROM (
      SELECT DISTINCT A.customer_id, A.zip_code
      FROM  customer A, reservation B, order_info C
      WHERE A.customer_id = B.customer_id
      AND   B.reserv_no = C.reserv_no
      AND   B.cancel = 'N'
      ) A, customer B
WHERE A.customer_id = B.customer_id
GROUP BY NVL(B.job,'정보없음')
ORDER BY COUNT(NVL(B.job,1)) DESC;

-- 전용 상품 구매 고객의 직업
SELECT NVL(B.job,'정보없음')    AS 직업,
       COUNT(NVL(B.job,1))     AS 사람수
FROM (
      SELECT DISTINCT A.customer_id, A.zip_code
      FROM  customer A, reservation B, order_info C
      WHERE A.customer_id = B.customer_id
      AND   B.reserv_no = C.reserv_no
      AND   B.cancel = 'N'
      AND   C.item_id = 'M0001'
      ) A, customer B
WHERE A.customer_id = B.customer_id
GROUP BY NVL(B.job,'정보없음')
ORDER BY COUNT(NVL(B.job,1)) DESC;


-- 4) 상위 고객 분석:상위 10위 고객
-- 분석15 전용 상품 매출 기준 상위 10위 고객 확인
SELECT *
FROM
(  
  SELECT  A.customer_id,
          A.customer_name,
          SUM(C.sales) AS 전용상품매출,
          ROW_NUMBER() OVER(PARTITION BY C.item_id ORDER BY SUM(C.sales) DESC) AS 순위
  FROM customer A, reservation B, order_info C
  WHERE A.customer_id = B.customer_id
  AND   B.reserv_no = C.reserv_no
  AND   B.cancel = 'N'
  AND   C.item_id = 'M0001'
  GROUP BY A.customer_id, C.item_id, A.customer_name
) A
WHERE A.순위 <= 10
ORDER BY A.순위 DESC;

-- 10위 고객 거주지
SELECT A.주소, COUNT(A.주소) AS 개수
FROM
(
  SELECT A.customer_id        AS 고객아이디,
         A.customer_name      AS 고객이름,
         NVL(A.job,'정보없음') AS 직업,
         D.address_detail     AS 주소,
         SUM(C.sales)         AS 전용상품_매출,
         RANK() OVER(PARTITION BY C.item_id ORDER BY SUM(C.sales) DESC) AS 순위
  FROM customer A, reservation B, order_info C, address D
  WHERE A.customer_id = B.customer_id
  AND   B.reserv_no = C.reserv_no
  AND   A.zip_code  = D.zip_code
  AND   B.cancel = 'N'
  AND   C.item_id = 'M0001'
  GROUP BY A.customer_id, C.item_id, A.customer_name, NVL(A.job, '정보없음'), D.address_detail
) A
WHERE A.순위 <= 10
GROUP BY A.주소
ORDER BY COUNT(A.주소) DESC;

-- 10위 고객 직업
SELECT A.직업, COUNT(A.직업) AS 개수
FROM
(
  SELECT A.customer_id        AS 고객아이디,
         A.customer_name      AS 고객이름,
         NVL(A.job,'정보없음') AS 직업,
         D.address_detail     AS 주소,
         SUM(C.sales)         AS 전용상품_매출,
         RANK() OVER(PARTITION BY C.item_id ORDER BY SUM(C.sales) DESC) AS 순위
  FROM customer A, reservation B, order_info C, address D
  WHERE A.customer_id = B.customer_id
  AND   B.reserv_no = C.reserv_no
  AND   A.zip_code  = D.zip_code
  AND   B.cancel = 'N'
  AND   C.item_id = 'M0001'
  GROUP BY A.customer_id, C.item_id, A.customer_name, NVL(A.job, '정보없음'), D.address_detail
) A
WHERE A.순위 <= 10
GROUP BY A.직업
ORDER BY COUNT(A.직업) DESC;


-- 5) 선호도 분석:개인별 두 번쨰 선호 상품 분석
-- 분석16 전용 상품 매출 상위 10 이상 고객이 두번째로 선호하는 상품 확인
SELECT *
 FROM (
       SELECT A.고객아이디,
              A.고객이름,
              D.product_name AS 상품명,
              SUM(C.sales)   AS 상품매출,
              RANK() OVER(PARTITION BY A.고객아이디 ORDER BY SUM(C.sales) DESC) 선호도순위
       FROM
       (
          SELECT A.customer_id       AS 고객아이디,
                 A.customer_name     AS 고객이름,
                 SUM(C.sales)        AS 전용상품_매출
          FROM customer A, reservation B, order_info C
          WHERE A.customer_id = B.customer_id
          AND   B.reserv_no = C.reserv_no
          AND   B.cancel = 'N'
          AND   C.item_id = 'M0001'
          GROUP BY A.customer_id, A.customer_name
          HAVING SUM(C.sales) > = 216000  
      ) A, reservation B, order_info C, item D
      WHERE A.고객아이디 = B.customer_id
      AND   B.reserv_no = C.reserv_no
      AND   C.item_id = D.item_id
      AND   D.item_id <> 'M0001' -- 전용상품 제외 최대 매출 상품
      AND   B.cancel = 'N'
      GROUP BY A.고객아이디, A.고객이름, D.product_name
) A
WHERE A.선호도순위 = 1;
