-- 1. 부서별 급여 합계 각 사원의 이름, 부서 호, 급여와 함께 같은 부서의
--    총 급여 합계를 OVER를 이용해 구하시오.
SELECT ENAME, DEPTNO, SAL, SUM(SAL) over (PARTITION BY DEPTNO) FROM EMP;

-- 2. 부서별 급여 평균, 각 사원의 이름과 급여를 출력하면서 같은 부서의 평균 급여를 OVER로 계산하시오.
SELECT ROUND(AVG(SAL) OVER ( PARTITION BY DEPTNO),0) 부서별급여평균, ENAME, SAL FROM EMP;

-- 3. 전체 누적 급여 합계 입사일(hiredate) 기준으로 정렬했을 때 각 사원까지의
--    누적 급여 합계를 OVER와 ROWS UNBOUNDED PRECEDING을 사용하여 구하시오.
    --전체 누적 급여 합계 (입사일 기준 정렬)
SELECT SUM(SAL) OVER ( ORDER BY HIREDATE ASC) 전체누적급여합계, HIREDATE FROM EMP;
SELECT SUM(SAL) OVER (ORDER BY HIREDATE ROWS UNBOUNDED PRECEDING) 전체누적급여합계, HIREDATE FROM EMP;


-- 4. 최근 3명 급여 합계, 입사일 순으로 정렬했을 때 현재 행 + 바로 앞 두 명의 급여를
--    합산한 컬럼을 OVER(ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)로 구하시오.
SELECT ENAME,
       SAL,
       HIREDATE,
       SUM(SAL) OVER(ORDER BY HIREDATE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 급여합계
FROM EMP;

-- 5. 부서별 급여 순위, 각 사원의 부서별 급여 순위를 ROW_NUMBER()를 사용해 표시하시오.
--    (동률은 순번이 달라야 함)

-- 어제꺼
SELECT (SELECT ROW_NUMBER() over (ORDER BY SAL) FROM EMP ) 부서별급여순위,
       SAL,
       SUM(SAL)
           OVER (PARTITION BY DEPTNO)
FROM EMP
ORDER BY SAL;

-- 부서별 급여 순위,
SELECT ROWNUM,  av.* FROM (SELECT ROUND(AVG(SAL)),DEPTNO FROM EMP WHERE DEPTNO IS NOT NULL GROUP BY DEPTNO) av ;


-- 각 사원의 부서별 급여 순위, + 부서별 급여 순위
SELECT
    DENSE_RANK() over (PARTITION BY e.DEPTNO ORDER BY SAL DESC, e.DEPTNO) NO,
    e.ENAME, e.SAL, e.DEPTNO,r.부서평균의순위
FROM EMP e INNER JOIN (SELECT ROWNUM 부서평균의순위,
                              av.* FROM (SELECT ROUND(AVG(SAL)),DEPTNO
                                         FROM EMP
                                         WHERE DEPTNO IS NOT NULL GROUP BY DEPTNO) av) r
ON e.DEPTNO=r.DEPTNO;

SELECT f.*,DENSE_RANK() over (ORDER BY 부서별평균) 부서별평균순위
    FROM (
        SELECT DENSE_RANK() over (PARTITION BY e.DEPTNO ORDER BY SAL DESC, e.DEPTNO) NO,
               e.ENAME,
               e.SAL,
               e.DEPTNO,
               ROUND( AVG (e.SAL) over (partition by e.DEPTNO)) 부서별평균
        FROM EMP e
        ) f;

-- 6. 부서별 급여 RANK, 부서별 급여 순위를 RANK()로 구하시오. (동률일 경우 같은 순위를 주고 다음 번호를 건너뛰게)
SELECT DEPTNO, ENAME, SAL, RANK() over (PARTITION BY DEPTNO ORDER BY SAL DESC) 부서별급여순위 FROM EMP  ;


-- 7. 부서별 급여 DENSE_RANK 부서별 급여 순위를 DENSE_RANK()로 구하시오. (동률일 경우 다음 번호를 건너뛰지 않게)
SELECT ROWNUM, DS.*
    FROM ((
        SELECT DEPTNO,
               ENAME,
               SAL,
               DENSE_RANK() over (PARTITION BY DEPTNO ORDER BY SAL DESC) 부서별급여순위
        FROM EMP) DS);


-- 8. 이전 사원 급여 비교, 입사일 순으로 정렬했을 때 이전 사람의 급여를 LAG()로 구하고, 현재 급여와 차이를 계산하는 컬럼을 만드시오.
--입사일 순으로 급여 정렬
SELECT SAL, ENAME, HIREDATE FROM EMP ORDER BY HIREDATE;

--이전사람의 급여를 LAG로 구하기
SELECT SAL,
       ENAME,
       HIREDATE,
       LAG(SAL,1,0) over (ORDER BY HIREDATE) AS PREV_SAL,
       ABS(SAL - LAG(SAL,1,0) over (ORDER BY HIREDATE)) AS RESULT
FROM EMP ORDER BY HIREDATE;

-- 9. 다음 사원 급여 비교, 입사일 순으로 정렬했을 때 다음 사람의 급여를 LEAD()로 구하고, 현재 급여와의 차이를 계산하는 컬럼을 만드시오.
--입사일 순 사원 급여
SELECT ENAME, SAL, HIREDATE FROM EMP ORDER BY HIREDATE;

--다음 사람의 급여
SELECT ENAME, SAL, HIREDATE, LEAD(SAL,1,0) OVER ( ORDER BY HIREDATE) AS 다음사람급여 FROM EMP ORDER BY HIREDATE;

-- 현재 급여와의 차이
SELECT ENAME,
       SAL,
       HIREDATE,
       LEAD(SAL,1,0) OVER ( ORDER BY HIREDATE) AS 다음사람급여,
       ABS(SAL - LEAD(SAL,1,0) OVER ( ORDER BY HIREDATE)) 다음사람급여차이
FROM EMP ORDER BY HIREDATE;



-- 10. 부서별 최대 급여 행만 추출
--     부서별로 최대 급여를 가진 사원만 출력하시오. (힌트: MAX(sal) OVER (PARTITION BY deptno)를 이용해 계산한 뒤,
--     FROM 서브쿼리로 감싸 WHERE 조건으로 필터링)

--부서별로
SELECT ENAME, DEPTNO, MAX(SAL) OVER (PARTITION BY DEPTNO) FROM EMP;
-- 이 결과창은 느낌적인 느낌으로 같은부서중 가장 높은갚을 보여달라는거같은딤

-- e.SAL 과 M이 같은 것만 출력!
SELECT e.ENAME, e.DEPTNO, e.SAL FROM (SELECT ENAME,
                                       DEPTNO,
                                       SAL,
                                       MAX(SAL) OVER (PARTITION BY DEPTNO) M
                                FROM EMP )e WHERE e.SAL = M;





