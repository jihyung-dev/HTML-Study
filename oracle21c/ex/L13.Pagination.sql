SELECT * FROM EMP;
-- 사원관리페이지서 페이징이되어 있음
-- 한 페이지당 5명씩 출력하기!

-- 로우넘 사용해ㅓㅅ 출력,
SELECT ROWNUM no, e.* FROM EMP e ORDER BY e.HIREDATE;

-- ROWNUM 순서가 뒤죽박죽이 되는것을 가장 마지막 단계로 빼서, 새로 정렬
SELECT ROWNUM no, emp.* FROM (SELECT * FROM EMP ORDER BY HIREDATE) emp;
-- WHERE no BETWEEN 1 AND 5;
--no 를 찾지 못함

SELECT * FROM (SELECT ROWNUM no, emp.* FROM (SELECT * FROM EMP ORDER BY HIREDATE) emp)
WHERE no BETWEEN 1 AND 5;
-- row 5                 row           row
-- 1 : 1~5  범위 : (page-1*5)+1 ~ (page*5)
-- 2 : 6~10
-- 3 : 11~15


SELECT ROWNUM, e.* FROM EMP e ORDER BY SAL;

--over : 집계를 나중에 하는 친구 (버전이 낮으면 없슴요)

SELECT ROW_NUMBER() OVER (ORDER BY SAL) NO, e.* FROM EMP e;
-- 오더 바이가 OVER 안에 있으면 오더 바이 이후에 출력


-- ROWNUM _ 번호가 꼭 필요하면 이 것 사용!
SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY SAL) NO, e.* FROM EMP e)
WHERE NO BETWEEN 1 AND 5;


--*****************************************************************************************************
--*****************************************************************************************************
--***********************************************  OFFSET  ********************************************
--*****************************************************************************************************
--*****************************************************************************************************

-- OFFSET
SELECT *
    FROM EMP
    ORDER BY SAL
    OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY; -- 5개를 건너뛰고 5개 보여줘



-------------------------------------------문제풀이-------------------------------------------
-- pay_history 페이징 연습문제
-- 테이블 구조: PAY_ID, EMPNO, PAY_DATE, AMOUNT, BONUS
--
-- ① ROWNUM 방식
-- pay_history 를 정렬 없이 1페이지(1~5행)를 조회하라. (페이지당 5건) 힌트: 안쪽에서 ROWNUM <= 5, 바깥에서 rnum >= 1
SELECT *
FROM (
    SELECT ROWNUM rn, p.*
    FROM PAY_HISTORY p
    WHERE ROWNUM <=10)
WHERE rn >0;    -- ********************예제에서는 부등호의 방향이 잘못된거 같은데요

-- T 문제풀이
--1)
SELECT * FROM PAY_HISTORY
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
--2)
SELECT ROWNUM no, PAY_HISTORY.* FROM PAY_HISTORY WHERE ROWNUM<=5;


SELECT *
FROM (SELECT ROWNUM no, PAY_HISTORY.* FROM PAY_HISTORY WHERE ROWNUM<=15)
WHERE No>=11;




-- 정렬 없이 2페이지(6~10행)를 조회하라. (페이지당 5건)
SELECT * FROM (
    SELECT ROWNUM rn, p.* FROM PAY_HISTORY p
    WHERE ROWNUM <=10)
    WHERE rn BETWEEN 6 AND 10;


-- 10번 부서의 pay_history를 1페이지(1~5행) 조회하라.


--10번 부서의 PAY_HISTORY 조회하기
SELECT DEPTNO ,ROWNUM rn, p.* FROM PAY_HISTORY p, EMP e
WHERE p.EMPNO = e.EMPNO ;

--PAY_HISTORY 1페이지 (1~5행) 조회하기
SELECT * FROM (SELECT ROWNUM rn, p.* FROM PAY_HISTORY p
WHERE ROWNUM <= 10)
WHERE rn BETWEEN 6 AND 10;

--합치기
SELECT * FROM
     (SELECT ROWNUM rn, p.*, DEPTNO FROM PAY_HISTORY p, EMP e
      WHERE ROWNUM <= 10 and p.EMPNO = e.EMPNO )
WHERE rn BETWEEN 6 AND 10;     -- 흠.. 이따 다시보던가 하자 잘 안되넹

--T 문제풀이

--1)조인
SELECT * FROM (SELECT ROWNUM no, ph.* FROM
                                          (SELECT *
    FROM PAY_HISTORY p INNER JOIN EMP e
        ON p.EMPNO=e.EMPNO
    WHERE DEPTNO =10 ORDER BY AMOUNT DESC) ph
    WHERE ROWNUM <=10)
WHERE no>=1;

--2)서브쿼리
SELECT * FROM PAY_HISTORY WHERE EMPNO IN (
    SELECT EMPNO FROM EMP WHERE DEPTNO =10);

SELECT * FROM PAY_HISTORY p WHERE EXISTS(
    SELECT * FROM EMP e WHERE e.EMPNO = p.EMPNO AND DEPTNO = 10);

--페이지네이션 하기
SELECT * FROM (SELECT ROWNUM rn, pn.* FROM (SELECT * FROM PAY_HISTORY WHERE EMPNO IN (
    SELECT EMPNO FROM EMP WHERE DEPTNO =10)) pn
    WHERE ROWNUM <=10) -- ROWNUM 으로 사용해야함, 가명사용 불가!!!
WHERE RN <4;




-- ② 4. ROW_NUMBER() 함수 방식
-- pay_history에서 급여일(PAY_DATE) 내림차순으로 정렬 후, 1페이지(1~5행)를 조회하라. 힌트: ROW_NUMBER() OVER (ORDER BY PAY_DATE DESC)

-- 급여일 기준, 내림차순 ROW_NUMBER() 정렬
SELECT ROW_NUMBER() over (ORDER BY PAY_DATE DESC) NO, PAY_DATE FROM PAY_HISTORY;

-- 페이지네이션 조합
SELECT * FROM (
    SELECT ROW_NUMBER() over (ORDER BY PAY_DATE DESC) NO, PAY_DATE
    FROM PAY_HISTORY)
WHERE NO between 1 and 5;  -- 맞는지를 모르겠숨돠



-- 5. pay_history에서 금액(AMOUNT) 높은 순으로 2페이지(6~10행)를 조회하라.
 -- pay_history 금액 높은순으로 조회
SELECT ROW_NUMBER() OVER (ORDER BY AMOUNT DESC) NO, AMOUNT , PAY_DATE  FROM PAY_HISTORY;

 -- 페이지 네이션 조합
SELECT * FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY AMOUNT DESC) NO,
           AMOUNT,
           PAY_DATE
    FROM PAY_HISTORY)
WHERE NO BETWEEN 6 AND 10; -- 이건 맞네 굳

SELECT PAY_HISTORY.*, AVG(AMOUT) OVER() FROM PAY_HISTORY;
-- rank, row_number() :  top-n stop-key로 중간에 번호 매기는 것을 멈출 수 없다.

SELECT ROW_NUMBER () OVER (ORDER BY PAY_DATE) no, p.* FROM PAY_HISTORY p;
-- 이친구는 불가능

SELECT ROWNUM no,p.* FROM (SELECT * FROM PAY_HISTORY ORDER BY PAY_DATE) p
WHERE ROWNUM<10;

SELECT * FROM (
    SELECT
        ROW_NUMBER() over (ORDER BY PAY_DATE DESC) no,
        p.*
FROM PAY_HISTORY p)
WHERE no BETWEEN 11 AND 15;



-- 6. pay_history에서 보너스(BONUS)가 있는 건만 대상으로 PAY_DATE DESC 정렬 후 1페이지(1~5행)를 조회하라.
  -- PAY_HISTORY 에서 보너스가 있는 것만 대상으로 PAY_DATE DESC 정렬
    SELECT * FROM PAY_HISTORY WHERE BONUS IS NOT NULL;

  -- ROW NUM()으로 정렬
    SELECT ROW_NUMBER(PAY_DATE DESC) FROM (
        SELECT *
        FROM PAY_HISTORY
        WHERE BONUS IS NOT NULL
                             );

-- T 문제풀이
    SELECT * FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY BONUS DESC) NO,
               p.*
        FROM PAY_HISTORY p WHERE BONUS IS NOT NULL)
    WHERE no BETWEEN 6 AND 10;

-- ③ OFFSET / FETCH 방식 (Oracle 12c+ 또는 MySQL)
-- 7. pay_history에서 PAY_DATE DESC 기준으로 1페이지(1~5행)를 조회하라. 힌트: OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
SELECT * FROM PAY_HISTORY
ORDER BY PAY_DATE
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--T 문제풀이
SELECT *
FROM PAY_HISTORY
ORDER BY PAY_DATE DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


--8. pay_history에서 AMOUNT DESC 기준으로 2페이지(6~10행)를 조회하라.
SELECT *
FROM PAY_HISTORY
ORDER BY AMOUNT DESC
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

--9. pay_history에서 직책(JOB)이 sales인 사원의 데이터를 PAY_DATE DESC 정렬 후 3페이지(11~15행)를 조회하라.
SELECT * FROM PAY_HISTORY p, EMP e
WHERE p.EMPNO= e.EMPNO
ORDER BY p.PAY_DATE DESC;

SELECT no.ENAME, no.JOB, no.PAY_DATE FROM ( -- 왜 여기뒤에는 *을 쓰면 작성이 안될까요 ??
                  SELECT * FROM PAY_HISTORY p, EMP e
                  WHERE p.EMPNO= e.EMPNO AND e.JOB = 'SALESMAN'
                  ORDER BY p.PAY_DATE DESC
              ) no;
-- OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY ; --10개가 안넘어서 데이터가 안뜸 ㅇ,ㅇ

--T 문제풀이

--서브쿼리
SELECT *
FROM PAY_HISTORY
WHERE EMPNO IN (SELECT EMPNO
                FROM EMP
                WHERE JOB = 'SALESMAN')
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY
;

--조인하기





-- pay_history최근 30일 이내 데이터만 대상으로 PAY_DATE DESC 정렬 후 1페이지(1~5행)를 조회하라.
(SELECT * FROM PAY_HISTORY
WHERE PAY_DATE --최근 30일을 어떻게 구현--
ORDER BY PAY_DATE DESC) no

SELECT no.* from ( -- 보여줄 표 구체화하기
                     (SELECT * FROM PAY_HISTORY     --윗부분 가져오기
                      WHERE PAY_DATE
                      ORDER BY PAY_DATE DESC) no
                 )
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


-- T 문제 풀이
SELECT * FROM PAY_HISTORY;
-- 특정날짜를 데이트로 변환하는 법 ( CURRENT 에서 - 연산을 위해 형변환 )
SELECT CURRENT_DATE - DATE'2025-09-01' FROM DUAL;
SELECT CURRENT_DATE - TO_DATE('2025-09-01') FROM DUAL;
SELECT CURRENT_DATE - CAST('2025-09-01' as DATE) FROM DUAL;

-- 오늘 = '2025-02-02' 가정


SELECT PAY_DATE FROM PAY_HISTORY
WHERE ABS(PAY_DATE - DATE '2025-02-02')<=30
ORDER BY PAY_DATE DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

SELECT ABS(PAY_DATE- DATE '2025-02-02') as d FROM PAY_HISTORY
WHERE ABS(PAY_DATE - DATE '2025-02-02')<=30;
