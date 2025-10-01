SELECT * FROM EMP;

-- 1000개 게시글
-- 최근에 등록된 글 10개 1 page
-- 최근에 등록된 글 10개 다음의 10개 2 page
-- ... pagination, paging

-- 입사일이 가장 최근인 사원을 5명씩 본다. : paging
SELECT * FROM EMP ORDER BY HIREDATE DESC;

-- ROWNUM : 행에 번호를 매김 (출력 이후, ORDER BY 전)
SELECT ROWNUM NO,
       EMP.*
FROM EMP
ORDER BY HIREDATE DESC;  -- -> ROWNUM 이 꼬이게되어 NO가 뒤죽박죽이 됨

-- ROWNUM 으로 정렬하기 위해
-- 1)
SELECT * FROM EMP ORDER BY HIREDATE DESC;

-- 2)  ROWNUM으로 번호 지정
SELECT ROWNUM, e.*
FROM (SELECT * FROM EMP ORDER BY HIREDATE DESC) e

-- 3) PAGINATION 6~10항목 보기
SELECT ROWNUM no, e.*
FROM (SELECT * FROM EMP ORDER BY HIREDATE DESC) e
WHERE no BETWEEN 5 AND 10;
-- ROWNUM 은 WHERE 절이 끝이나고 실행이됨,  (ROWNUM -> WHERE과 ORDER BY 사이에 존재)
-- WHERE 절에서 ROWNUM 함수 자체를 호출하면 SELECT절의 ROWNUM과 동시에 실행됨

SELECT ROWNUM as no, e.*
    FROM (SELECT * FROM EMP ORDER BY HIREDATE DESC) e
    WHERE ROWNUM <=10;
-- WHERE ROWNUM BETWEEN 5 AND 10;   -- 복잡한 구간을 설정할 수 없지만, 끊어지는 지점만 설정 가능
-- 데이터 번호지정 전체하지 않음

SELECT * FROM (SELECT ROWNUM as no, e.*
               FROM (SELECT * FROM EMP ORDER BY HIREDATE DESC) e
               WHERE ROWNUM <=5)
WHERE no>0;

SELECT * FROM (SELECT ROWNUM as no, e.*
               FROM (SELECT * FROM EMP ORDER BY HIREDATE DESC) e
               WHERE ROWNUM <=10)
WHERE no BETWEEN 6 AND 10;

-- **********************************************************
-- **********************************************************
-- ************************* 서브쿼리 *************************
-- **********************************************************
-- **********************************************************

--급여의 평균보다 급여를 많이 받는 사람
-- MAX MIN AVG ...
SELECT AVG(SAL) FROM EMP;
SELECT * FROM EMP WHERE SAL>(SELECT AVG(SAL) FROM EMP);

SELECT EMP.*, (SELECT AVG(SAL) FROM EMP) 평균 FROM EMP;

SELECT e.*,
       (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=e.DEPTNO) 평균
FROM EMP e;

--ROWNUM 보다 WHERE절이 먼저 동작하므로, no를 참조할 수 없음
SELECT ROWNUM no, EMP.* FROM EMP WHERE no BETWEEN 5 AND 10;

-- 따라서 FROM 절로 묶어서 우선순위를 주고 난 후 WHERE 절을 후순위로 밀기
SELECT * FROM (SELECT ROWNUM no, EMP.* FROM EMP) WHERE no BETWEEN 5 AND 10;



--#2 ************************ 서브쿼리! ************************
--FROM 절의 서브쿼리
SELECT * FROM (SELECT * FROM EMP);


-- ORDER BY가 ROWNUM 이후에 실행되므로, ROWNUM의 순서가 뒤죽박죽이 됨
SELECT ROWNUM, EMP.* FROM EMP ORDER BY SAL DESC;

-- mysql DB : 서브쿼리의 가상테이블의 가명, 별칭을 꼭 붙여야함

SELECT * FROM (
SELECT ROWNUM no, e.* FROM (SELECT * FROM EMP ORDER BY SAL DESC) e
WHERE ROWNUM <=10 )
WHERE NO>5; -- 10개까지의 MAXIMUM 을 주고 난후, 최소값 지정을 위해 한번더 묶어줌

--WHERE ROWNUM BEETWEEN 6 AND 10; -- WHERE 절이 ROWNUM 보다 순서가 빠르므로 불러올 수 없음
 -- 그러나 '10개 까지만'은  가능


SELECT * FROM EMP ORDER BY SAL DESC
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;
-- 건너뛰기 5개 ROW, 붙인붙인다 5개를 ROW만

