--from 서브쿼리 : 조회한 결과를 다시 조회한 대상으로 사용
SELECT *
FROM EMP;

SELECT *
FROM (SELECT * FROM DEPT);

SELECT DEPTNO, ROUND(AVG(SAL)) 급여평균
FROM EMP
GROUP BY DEPTNO
HAVING ROUND(AVG(SAL)) > 2000; -- 집계를 두 번 하기 때문에 성능적으로 좋지 않음

SELECT g.DEPTNO, g.급여평균
FROM (SELECT DEPTNO, ROUND(AVG(SAL)) 급여평균
      FROM EMP
      GROUP BY DEPTNO) g
WHERE 급여평균 > 2000;
-- 집계한것의 이름으로 조회, 집계를 한번만 함 => 성능 개선

-- ORACLE 전용
-- ROWNUM : 행을 출력할 때 번호 작성 (정렬 이후에 동작!!!!)
--          따라서 WHERE절을 절대 사용할 수 없음
SELECT r.*
FROM (SELECT ROWNUM no, EMPNO, ENAME
      FROM EMP
      --WHERE no < 5
      ORDER BY EMPNO) r
WHERE r.no < 5; -- 페이지네이션 (한페이지에 4개씩 보여짐)



-- ORDER BY는 출력을 다 하고 정렬을 함
SELECT r.*
FROM (SELECT ROWNUM no, EMPNO, ENAME
      FROM EMP) r
      ORDER BY EMPNO;
-- 이렇게 하면 No가 뒤죽박죽이 됨


--WHERE 절에 있는 단일 행 서브쿼리 : 평균보다 급여가 높은 직원
SELECT AVG(SAL) FROM EMP;

SELECT * FROM EMP WHERE SAL>2073;

SELECT * FROM EMP WHERE SAL>(SELECT AVG(SAL) FROM EMP);

--평균 급여가 2000 이상인 부서의 사원을 조회
--10
--20

SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING AVG(SAL)>2000;

SELECT * FROM EMP WHERE DEPTNO IN (10,20);

SELECT *
    FROM EMP
    WHERE DEPTNO
      IN (SELECT DEPTNO
          FROM EMP
          GROUP BY DEPTNO
          HAVING AVG(SAL)>2000);

-- 출력되는 부분에 뭔가를 더하고 싶을때 사용하는
-- SELECT 절의 서브쿼리 (무조건 단일행!)

SELECT
    e.ENAME,e.DEPTNO,
    (SELECT
         AVG(g.SAL)
        FROM EMP g WHERE g.DEPTNO=e.DEPTNO) --GROUP BY DEPTNO )
    FROM EMP e; -- 이 작업이 비효율적 (여러번 작업)

SELECT AVG(SAL) FROM EMP GROUP BY DEPTNO; -- 한번만 작업 TO JOIN

--JOIN 시키기
SELECT e.*,v.평균
    FROM EMP e
        INNER JOIN (SELECT DEPTNO, AVG(SAL) 평균
                                  FROM EMP
                                  GROUP BY DEPTNO) v
        ON e.DEPTNO=v.DEPTNO; -- 이미 조회된 것을 조인, (그때그때 조회하는 것과 다름)
                              -- 성능 최적화를 위해 어떻게 할 것인가는 그때그때 고민해봐야함!



--****************************************************************************--
--****************************************************************************--
--****************************************************************************--
--------------------------------서브 쿼리 문제 풀이--------------------------------
--****************************************************************************--
--****************************************************************************--
--****************************************************************************--


-- 문제 1. 전체 평균 급여보다 많은 급여를 받는 사원들의 이름과 급여를 조회하라.
SELECT ENAME, SAL
    FROM EMP WHERE SAL>(SELECT AVG(SAL) FROM EMP);

-- 문제 2. 이름이 'KING'인 사원과 동일한 직무를 가진 사원을 조회하라.
SELECT ENAME, JOB
FROM EMP WHERE JOB =(SELECT JOB FROM EMP WHERE ENAME = 'MILLER');

-- 이름이 king인 사람의 직무  =>
SELECT ename, job
FROM emp
WHERE job = (SELECT job FROM emp WHERE ename = 'MILLER');


-- 문제 3. 20번 부서에서 근무하는 사원과 동일한 급여를 받는 사원들의 이름과 급여를 조회하라.
SELECT ENAME, SAL, DEPTNO FROM EMP
WHERE SAL IN (SELECT SAL FROM EMP WHERE DEPTNO = 20);

-- 문제 4. 30번 부서 사원 중 조금이라도 급여를 더 받는 사원들을 조회하라. -> 30번 부서중에서 받으라고 했으니 FROM 도 SELECT를 사용해야함!
SELECT ENAME, SAL, DEPTNO FROM (SELECT ENAME, SAL, DEPTNO FROM EMP WHERE DEPTNO=30)
WHERE SAL > ANY (SELECT SAL FROM EMP WHERE DEPTNO = 30) ;

-- 문제 5. 10번 부서 사원 전원보다 급여가 높은 사원을 조회하라. 10번 부서 회장님은 최고티어 -> 30번 부서로 급여 역순으로 변경
SELECT ENAME, SAL, JOB FROM EMP
WHERE SAL > ALL (SELECT SAL FROM EMP WHERE DEPTNO = 30) ORDER BY SAL DESC;

-- 문제 6. 20번 부서의 (직무, 급여) 조합과 같은 조건을 가진 사원들을 조회하라.
SELECT * FROM EMP
   WHERE (JOB, SAL) IN (SELECT JOB, SAL FROM EMP WHERE DEPTNO=20); -- 20번 부서 사람 + 동일한 수치를 가진 사람
    --20번 부서의 직무, 급여 조합과 같은 조건
    --SELECT JOB, SAL FROM EMP WHERE DEPTNO=20;

-- 문제 7. 각 부서별 최고 급여를 받는 사원 정보를 조회하라.
SELECT DEPTNO 부서, MAX(e.SAL) 최고급여  FROM EMP e GROUP BY DEPTNO;  -- 이거도 되나요 ?

--해설처럼 하려면 위의 것을 한번 더 묶어서 해야한다.

-- 문제 해설
SELECT * FROM emp
WHERE (deptno, sal) IN (
    SELECT deptno, MAX(sal)
    FROM emp
    GROUP BY deptno
);


-- 문제 8. 자기 부서의 평균 급여보다 높은 급여를 받는 사원들의 이름, 부서번호, 급여를 조회하라.

-- 서브쿼리 [조건]으로 풀기

SELECT *
    FROM EMP e
    WHERE SAL>(SELECT AVG(a.SAL) FROM EMP a WHERE a.DEPTNO=e.DEPTNO);

-- 서브쿼리 [조인]으로 문제 풀기

    SELECT *
        FROM EMP INNER JOIN
             (SELECT DEPTNO, AVG(SAL) avg FROM EMP GROUP BY DEPTNO) a
        ON EMP.DEPTNO=a.DEPTNO
    WHERE EMP.SAL>a.avg
        ORDER BY EMP.EMPNO;






-- 문제 9. 사원이 존재하는 부서만 조회하라.
    -- 여러가지 방법이 존재
    -- 풀이 1번 : 부서 번호로 검색
    SELECT * FROM DEPT;
    SELECT DISTINCT DEPTNO FROM EMP;
    SELECT * FROM DEPT WHERE DEPTNO IN (SELECT DISTINCT DEPTNO FROM EMP);

    -- 풀이 2번 : DEPTNO가 각 번호가 있는지?

    SELECT * FROM DEPT WHERE EXISTS(SELECT * FROM EMP WHERE EMP.DEPTNO = DEPT.DEPTNO)






-- 문제 10. 각 사원의 이름, 급여와 함께 해당 사원 부서의 평균 급여를 같이 출력하라.
    SELECT
        e.ENAME,
        e.SAL,
        e.DEPTNO,
        (SELECT AVG(d.SAL)FROM EMP d WHERE d.DEPTNO=e.DEPTNO) 부서별평균 --GROUP BY로 하면 행이 1개여야만함 --> WHERE 로 변경
        WHERE 부서별평균 >2500,
        FROM EMP e;


-- over : 집계를 따로 진행해서 기존 출력에 더한다.   SUCH LIEK ROWNUM, 집계를 마친 후 추가!!!!

SELECT * FROM EMP;
--SELECT e.ENAME, e.SAL, AVG(e.SAL) FROM EMP e;
SELECT e.ENAME, e.SAL, AVG(e.SAL) OVER (  ) FROM EMP e; -- 묶지 않으면 전체 평균
SELECT e.ENAME, e.SAL, AVG(e.SAL) OVER (PARTITION BY DEPTNO ) FROM EMP e; -- 부서별로 묶은 평균
SELECT z.이름, z.급여, z.부서번호, z.부서별평균 FROM (SELECT
        e.ENAME 이름,
        e.SAL 급여,
        e.DEPTNO 부서번호,
        AVG(e.SAL) OVER (PARTITION BY DEPTNO) 부서별평균
FROM EMP e) z
WHERE z.부서별평균>2500; -- 부서별로 묶은 평균

-- NEXT, PAGENATION




