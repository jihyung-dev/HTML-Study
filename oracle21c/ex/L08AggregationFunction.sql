SELECT SUM(sal) FROM EMP; -- 단일행 결과
-- SELECT ENAME, SUM(sal) FROM EMP; 그룹함수와 같이 사용할 수 없음!

SELECT SUM(sal) AS "급여의 총합", ROUND(AVG(sal)) AS "급여의 평균" FROM EMP;
-- 집계함수를 작성하면 필드는 꼭 직계함수만 작성 가능!

-- DISTINCT : 중복제거 (집계함수 X)!!
SELECT DEPTNO FROM EMP;
SELECT DISTINCT DEPTNO FROM EMP;

SELECT COUNT(*) FROM EMP; -- 행의 갯수를 세줌

UPDATE EMP SET COMM=null WHERE COMM=0;

SELECT COUNT(*),MAX(sal),MAX(comm),MIN(sal),MIN(comm) FROM EMP;
-- 급여와 커미션을 가장 많이 그리고 가장 조금,받는 양
SELECT COUNT(*),MAX(sal),MAX(comm),MIN(sal),MIN(comm) FROM EMP WHERE DEPTNO=10;
-- 부서번호 10에서
SELECT COUNT(*),MAX(sal),MAX(comm),MIN(sal),MIN(comm) FROM EMP WHERE DEPTNO=30;
-- 부서번호 30에서

SELECT STDDEV(SAL) FROM EMP; -- 급여의 표준편차

-- 집계함수와 같이 쓰이는 GROUP BY 중복될 수 있는 요소가 있어야함
SELECT DEPTNO FROM EMP GROUP BY DEPTNO;
SELECT DISTINCT DEPTNO FROM EMP;
-- DISTINCT 와 같아 보이지만, DISTINCT 를 집계함수를 사용할 수 없지만,
-- GROUP BY 는 집계함수를 사용할 수 있음

-- SELECT DEPTNO, SUM(SAL), ROUND(AVG(SAL)) FROM EMP GROUP BY DEPTNO WHERE SAL>=1000 ;
-- WHERE 절은 FROM 뒤에!

SELECT DEPTNO, SUM(SAL), ROUND(AVG(SAL)) FROM EMP WHERE SAL>=1000 GROUP BY DEPTNO ;
-- 조회를 하고나서 결과를 집계 하는것이므로, 결과를 집계후, 조회를 할 수 없음

-- 집계된 결과에서 조건을 주기 ) 여기에서 SUM이 8500이상인 사람만 나오도록 하려면?
-- SELECT DEPTNO,
--        SUM(SAL) AS TOTAL,
--        ROUND(AVG(SAL)) AS AVG
--         FROM EMP
--         WHERE SAL>=1000 AND TOTAL>=8500
--         GROUP BY DEPTNO ;                    -- 안됨

SELECT DEPTNO,
       SUM(SAL) AS TOTAL
    FROM EMP
    GROUP BY DEPTNO
    HAVING SUM(SAL)>9000 -- mySQL에서는 SUM(SAL) 대신 TOTAL 사용가능,
    ORDER BY TOTAL;      -- BUT SUBQUERY로 사용 가능  // 오도바이

-- TOMORROW : SUBQUERY, JOIN



-- 1. 부서(deptno)별 인원수를 구하라. 컬럼명은 인원수로 표시하라.
SELECT COUNT(*) AS 인원수 FROM EMP;

-- 2. 부서(deptno)별 급여(sal) 합계를 구하고 합계가 큰 순으로 정렬하라. 컬럼명은 총급여로 하라.
SELECT SUM(SAL) AS 총급여 FROM EMP GROUP BY (DEPTNO) ORDER BY SUM(SAL) DESC ;

-- 3. 직무(job)별 평균 급여를 소수점 둘째 자리까지 반올림하여 구하라. 컬럼명은 평균급여로 하라.
SELECT ROUND(AVG(SAL),2) AS "평균급여" FROM EMP GROUP BY (JOB);

-- 4. 부서(deptno)별 최댓값/최솟값 급여를 함께 구하라. 컬럼명은 각각 최고급여, 최저급여로 하라.
SELECT MAX(SAL) AS "최고급여", MIN(SAL) AS "최저급여" FROM EMP GROUP BY (DEPTNO);

-- 5. 부서(deptno)와 직무(job)별 인원수를 구하라. 인원수가 3명 이상인 그룹만 출력하라.
SELECT DEPTNO,JOB, COUNT(*) AS "그룹별 인원수" FROM EMP GROUP BY (DEPTNO),(JOB) HAVING COUNT(*) >=3 ;
SELECT * FROM EMP;

-- 6. 부서(deptno)별로 중복을 제거한 직무(job) 개수를 구하라. 컬럼명은 직무개수로 하라.
SELECT COUNT(DISTINCT(JOB)) AS 직무개수 FROM EMP;

-- 7. 보너스(comm)가 NULL이 아닌 사원만 대상으로, 직무(job)별 평균 보너스를 구하라.
SELECT JOB, ROUND(AVG(COMM),2) AS 평균보너스 FROM EMP WHERE COMM IS NOT NULL GROUP BY JOB;

-- 8. 부서(deptno)별 급여 합계가 10000 이상인 부서만 출력하라. 합계 컬럼명은 총급여로 하라.
SELECT SUM(SAL) AS 총급여 FROM EMP GROUP BY DEPTNO HAVING SUM(SAL)>10000;

-- 9. 입사일(hiredate)을 월 단위(YYYY-MM)로 묶어 월별 입사 인원수를 구하고 최신 월이 먼저 오도록 정렬하라.
SELECT TO_CHAR(HIREDATE,'YYYY-MM') AS 입사월 , COUNT(*) AS 인원수 FROM EMP GROUP BY TO_CHAR(HIREDATE,'YYYY-MM') ORDER BY 입사월 DESC;
-- 입사일을 달로 형태를 변환한 후, 그룹으로 묶고 진행

-- 10. 직무(job)별로 급여 평균이 2500 이상인 그룹만 출력하고, 평균은 소수점 한 자리까지 표시하라.
SELECT ROUND(AVG(SAL),1) AS 급여평균2500이상 FROM EMP GROUP BY JOB HAVING AVG(SAL)>=2500;

-- 11. 부서(deptno)별로 급여가 3000 이상인 사원 수와 3000 미만인 사원 수를 각각 구해 한 행에 보여라.
SELECT DEPTNO,
       SUM( CASE WHEN SAL >=3000 THEN 1 ELSE 0 END) AS "3000이상",
       SUM( CASE WHEN SAL <3000 THEN 1 ELSE 0 END) AS "3000미만"
FROM EMP GROUP BY DEPTNO;
-- COUNT 안에 SAL >=3000 을 넣었지만, 그런 행이 없으므로, 이런 조건식을 넣을 수 없음.
-- 조건식 = CASE를 필요로 하며, 이를 숫자로 COUNT하기위해서는 조건이 부합하면 1, 아니면 0을 주고 합(SUM)

-- 12. 부서(deptno)별로 사원들의 고유 급여(sal, 중복 제거)의 평균을 구하라. 컬럼명은 고유평균급여로 하라.
SELECT DEPTNO, ROUND(AVG(DISTINCT SAL),2) AS 고유평균급여 FROM EMP GROUP BY DEPTNO;
-- DISTINCT 가 앞에 붙는거같은데, 이게 가장 안쪽에 SAL에 바로 붙는다, 순서가 거꾸로됨 확인할것!

-- 13. 직무(job)별로 급여의 표준편차와 분산을 구하라. 컬럼명은 각각 표준편차, 분산으로 하라.
SELECT JOB, ROUND(STDDEV(SAL),2) AS 표준편차, ROUND(VARIANCE(SAL),2) AS 분산 FROM EMP GROUP BY JOB;

-- 14. 부서(deptno)별로 사원 수가 가장 많은 직무(job)만 출력하라. 동률이면 모두 출력하라. *******제껴~******


-- 15. 직무(job)별로 보너스(comm)를 받는 사원 비율(보너스 있는 인원 / 전체 인원 × 100)을 소수점 둘째 자리까지 구하라.
SELECT JOB, Sum(CASE
WHEN COMM IS NOT NULL
    THEN 1
    ELSE 0 END) /COUNT(*)*100||'%'
FROM EMP GROUP BY JOB;

SELECT * FROM EMP;

SELECT job,
       AVG(CASE WHEN comm IS NOT NULL THEN 1 ELSE 0 END) AS 보너스비율
FROM emp
GROUP BY job;

-- 16. 부서(deptno)별 급여 중앙값을 구하라. 컬럼명은 중앙값으로 하라.


-- 17. 부서(deptno)별, 직무(job)별로 급여 합계를 구하고, 부서 내에서 합계가 큰 순으로 정렬하라.


-- 18. 부서(deptno)별 급여 합계와 평균을 구하되, 부서 번호가 10 또는 20인 경우만 출력하라.


-- 19. 전체 사원을 하나의 그룹으로 보고, 전체 인원수, 서로 다른 직무 수, 급여 평균을 한 행에 출력하라.


-- 20. 부서(deptno)별로 급여 평균이 각 부서의 최대 급여의 60% 이상인 부서만 출력하라.








