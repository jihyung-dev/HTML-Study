SELECT * FROM EMP;

SELECT
    ENAME,
    EMP.DEPTNO,
    DNAME,LOC

FROM EMP, DEPT
    WHERE EMP.DEPTNO=DEPT.DEPTNO
    ORDER BY ENAME;
-- inner join
SELECT
    P.PAY_ID, -- 14명이됨 CUZ EMP가 14명이므로
    E.EMPNO, E.ENAME,
    P.AMOUNT,P.BONUS
FROM PAY_HISTORY P INNER JOIN EMP E
ON P.EMPNO=E.EMPNO        -- 이렇게 했는데 왜 28행이나오지??
WHERE AMOUNT >= 2000
ORDER BY PAY_ID; -- 1,2,3,4,5를 붙이는 고유값 PK


-- 가명 AS
SELECT ENAME AS 사원이름 FROM EMP; -- SELECT에서는 사용할 수 있음
SELECT ENAME 사원이름 FROM EMP;
SELECT e.ENAME, e.EMPNO 사원이름 FROM EMP e; -- 가명을줬다면 반드시 가명을 써야함
--SELECT e.ENAME, e.EMPNO 사원이름 FROM EMP as e; -- 오라클에서는 지원하지 않음

SELECT e.*,d.DNAME FROM EMP e INNER JOIN DEPT d
    ON e.DEPTNO=d.DEPTNO;
    -- 1..n<->1    테이블간의 관계를 표현 [ n:1 ]
    -- miller (emp) 입장에서는 부서를 1개만 가짐
    -- 부서 (dept) 의 입장에서는 여러명(n)명을 가짐  => n:1

        -- * 1:1 은 무의미함
        -- 데이터가 정말 많은 경우가 아니라면 분리시키는것은 의미없음

    -- left outer join을 선호하는 이유 : 왼쪽이 기준이 되는 데이터, (n:1인 경우)




SELECT DISTINCT DEPTNO FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM EMP WHERE DEPTNO IS NULL;

--BLAKE CLARK SCOTT (7698, 7782, 7788)의 부서를 NULL로 변경
UPDATE EMP SET DEPTNO = NULL WHERE EMPNO IN(7698,7782,7788);
COMMIT;
SELECT COUNT(*) FROM EMP; --총 14명
SELECT *
    FROM EMP e INNER JOIN DEPT d
        ON e.deptno=d.deptno;  -- 이너 조인

SELECT *
    FROM EMP e LEFT OUTER JOIN DEPT d
        ON e.deptno=d.deptno; -- 레프트 아우터 조인

SELECT *
FROM EMP e RIGHT OUTER JOIN DEPT d
         ON e.deptno=d.deptno;  -- 라이트 아우터 조인

SELECT *
FROM EMP e FULL OUTER JOIN DEPT d
         ON e.deptno=d.deptno; -- 풀 아우터 조인

-- INNER JOIN == NATURAL JOIN : 자동으로 ON의 조건을 생성 (자동 ON 절 생성)
-- PK = FK 이름이 같아야함, 지정이 안된것은 되지 않음
SELECT * FROM EMP NATURAL JOIN DEPT;

--#3 셀프 조인 (내가 내 자신을 참조)
SELECT EMPNO, ENAME, MGR FROM EMP;
SELECT e.EMPNO 사번,
       e.ENAME 사원이름,
       e.MGR 상사번호,
       m.ENAME 상사이름
FROM EMP e, EMP m
WHERE e.MGR=m.EMPNO;

SELECT e.*,m.ENAME
    FROM EMP e LEFT JOIN EMP m
    ON e.MGR=m.EMPNO;












SELECT
    P.PAY_ID,
    P.EMPNO AS Pay_EMPNO,   -- 별칭을 붙여 컬럼 이름 구분
    E.EMPNO AS Emp_EMPNO,   -- 별칭을 붙여 컬럼 이름 구분
    E.ENAME,
    P.AMOUNT,
    P.BONUS
FROM PAY_HISTORY  P
INNER JOIN EMP  E ON P.EMPNO = E.EMPNO
ORDER BY PAY_ID;






SELECT
    p.pay_id,
    p.empno,  -- 중복되는 E.EMPNO는 제거
    e.ename,
    p.amount,
    p.bonus
FROM pay_history p  -- AS 키워드 제거
         INNER JOIN emp e    -- AS 키워드 제거
                    ON p.empno = e.empno
ORDER BY pay_id;



-- ************************************************************************--
-- ***************************** 조인 문제 풀이 ******************************
-- ************************************************************************--
-- 문제 1. EMP와 DEPT를 내부 조인하여 (모든) 사원의 이름(ENAME)과 소속 부서명(DNAME)을 조회하라.
SELECT ENAME, DNAME FROM EMP INNER JOIN DEPT
    ON EMP.DEPTNO = DEPT.DEPTNO;

-- 문제 2. 모든 사원의 이름과 소속 부서를 출력하되, 소속이 없는 사원도 포함되도록 LEFT JOIN을 사용하라.
SELECT ENAME, DNAME FROM EMP LEFT JOIN DEPT
    ON EMP.DEPTNO = DEPT.DEPTNO;

-- 문제 3. 모든 부서명을 출력하되, 사원이 없는 부서도 포함되도록 RIGHT JOIN을 사용하라.
SELECT d.DEPTNO, DNAME FROM DEPT e RIGHT JOIN EMP d
    ON e.DEPTNO = d.DEPTNO;

-- 문제 4. EMP와 DEPT를 FULL OUTER JOIN하여 사원 또는 부서가 없어도 모두 조회하라.
SELECT ENAME, DNAME FROM EMP FULL OUTER JOIN DEPT
    ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT e.EMPNO,e.ENAME,d.DEPTNO,d.DNAME,d.LOC
FROM EMP e FULL OUTER JOIN DEPT d
ON e.DEPTNO=d.DEPTNO;

-- 문제 5. EMP 테이블에서 사원 이름과 같은 부서에 속한 다른 사원의 이름을 SELF JOIN으로 조회하라.
SELECT e.ENAME, g.ENAME FROM EMP e JOIN EMP g
    ON e.DEPTNO = g.DEPTNO;
-- 본인이름은 빼고 해야하나? 일단 지나가                                                            *****

--  <T. 문제풀이>
SELECT e.EMPNO, e.ENAME, e.DEPTNO, d.EMPNO, d.ENAME FROM EMP e INNER JOIN EMP d
ON e.DEPTNO=d.DEPTNO
--중복 제거 방법
WHERE e.ENAME!=d.ENAME ORDER BY e.EMPNO; -- WHERE 절에 넣어두되고 ON 절에 넣어도 됨



-- 문제 6. EMP와 DEPT를 CROSS JOIN하여 모든 가능한 조합을 조회하라.
SELECT * FROM EMP CROSS JOIN DEPT;

-- 문제 7. EMPNO와 DEPTNO가 일치하는 데이터만 INNER JOIN으로 조회하고, DEPTNO 순으로 정렬하라.
-- 문제 7. 사원의 부서번호와 부서의 부서번호가 동일한 사원을 조회하고 부서번호로 정렬하세요.
SELECT ENAME, e.DEPTNO FROM EMP e INNER JOIN DEPT
    ON e.DEPTNO=DEPT.DEPTNO;

-- 문제 8. 사원의 이름, 부서명을 출력하되, 부서명이 없는 경우 "NO DEPT"로 표시하라. (LEFT JOIN + NVL/COALESCE 활용)

-- SELECT NVL(NULL, 'NO DEPT') FROM( );  NVL 사용법!

SELECT ENAME,  NVL(DNAME, 'NO DEPT') FROM EMP LEFT OUTER JOIN DEPT
ON EMP.DEPTNO=DEPT.DEPTNO;

-- 문제 9. EMP에서 ENAME, DEPT에서 DNAME을 INNER JOIN으로 조회하되, 부서명이 'SALES'인 사원만 출력하라.
SELECT ENAME, DNAME FROM EMP e INNER JOIN DEPT g
ON e.DEPTNO=g.DEPTNO WHERE g.DNAME='SALES';

-- 문제 10. EMP 테이블에서 관리자를 표현하려고 SELF JOIN을 사용해 사원의 이름과 같은 부서의 다른 사원을 "관리자"로 표시하라.
-- SELECT e.ENAME, g.ENAME 관리자 FROM EMP e JOIN EMP g
-- on e.MGR=g.MGR;                                                  아 모르겠다 일단 묻떠 해


SELECT * FROM EMP e LEFT JOIN
(SELECT EMPNO,'매니저',DEPTNO, JOB FROM EMP WHERE JOB='MANAGER') m
ON e.DEPTNO=m.DEPTNO
WHERE e.EMPNO!=m.EMPNO;


-- where (select f.ENAME
--        from EMP f left join EMP h
--                             on e.DEPTNO=g.DEPTNO
--        where f.ENAME <> g.ENAME).ENAME='관리자';
--



SELECT JOB,DEPTNO,ENAME FROM EMP WHERE JOB='MANAGER';

SELECT e.EMPNO,e.JOB,e.DEPTNO,m.ENAME 관리자
FROM EMP e INNER JOIN EMP m on e.DEPTNO=m.DEPTNO WHERE m.JOB='MANAGER' ORDER BY EMPNO;
