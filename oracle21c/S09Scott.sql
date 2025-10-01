-- =====================================
-- SCOTT 샘플 스키마 생성 스크립트 (Oracle 21c)
-- 계정 생성 및 권한
-- =====================================
-- PDB에 접속해서 실행하세요 (예: sqlplus sys/oracle@localhost:1521/XEPDB1 as sysdba)
-- 0.유저가 있으면 삭제
DROP USER scott CASCADE;
-- 1. 유저 생성
CREATE USER scott IDENTIFIED BY tiger;

-- 2. 권한 부여
GRANT CONNECT, RESOURCE TO scott;
ALTER USER scott QUOTA UNLIMITED ON users;

-- =====================================
-- 테이블 생성
-- =====================================

-- 부서 테이블
CREATE TABLE scott.dept (
                            deptno NUMBER(2) CONSTRAINT pk_dept PRIMARY KEY,
                            dname  VARCHAR2(14),
                            loc    VARCHAR2(13)
);

-- 사원 테이블
CREATE TABLE scott.emp (
                           empno    NUMBER(4) CONSTRAINT pk_emp PRIMARY KEY,
                           ename    VARCHAR2(10),
                           job      VARCHAR2(9),
                           mgr      NUMBER(4),
                           hiredate DATE,
                           sal      NUMBER(7,2),
                           comm     NUMBER(7,2),
                           deptno   NUMBER(2) CONSTRAINT fk_deptno REFERENCES scott.dept(deptno)
);

-- 급여 등급 테이블
CREATE TABLE scott.salgrade (
                                grade NUMBER,
                                losal NUMBER,
                                hisal NUMBER
);
-- 급여 기록 테이블
CREATE TABLE scott.pay_history (
                                   pay_id     NUMBER(6) CONSTRAINT pk_pay_history PRIMARY KEY,
                                   empno      NUMBER(4) CONSTRAINT fk_emp_pay REFERENCES scott.emp(empno),
                                   pay_date   DATE      DEFAULT SYSDATE,
                                   amount     NUMBER(7,2),
                                   bonus      NUMBER(7,2)
);
-- 급여 id 시퀀스
CREATE SEQUENCE scott.seq_pay_history
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- =====================================
-- 데이터 삽입
-- =====================================

-- DEPT 데이터
INSERT INTO scott.dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO scott.dept VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO scott.dept VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO scott.dept VALUES (40, 'OPERATIONS', 'BOSTON');

-- EMP 데이터
INSERT INTO scott.emp VALUES (7839, 'KING',   'PRESIDENT', NULL, TO_DATE('1981-11-17','YYYY-MM-DD'), 5000, NULL, 10);
INSERT INTO scott.emp VALUES (7566, 'JONES',  'MANAGER',   7839, TO_DATE('1981-04-02','YYYY-MM-DD'), 2975, NULL, 20);
INSERT INTO scott.emp VALUES (7698, 'BLAKE',  'MANAGER',   7839, TO_DATE('1981-05-01','YYYY-MM-DD'), 2850, NULL, 30);
INSERT INTO scott.emp VALUES (7782, 'CLARK',  'MANAGER',   7839, TO_DATE('1981-06-09','YYYY-MM-DD'), 2450, NULL, 10);
INSERT INTO scott.emp VALUES (7788, 'SCOTT',  'ANALYST',   7566, TO_DATE('1987-07-13','YYYY-MM-DD'), 3000, NULL, 20);
INSERT INTO scott.emp VALUES (7902, 'FORD',   'ANALYST',   7566, TO_DATE('1981-12-03','YYYY-MM-DD'), 3000, NULL, 20);
INSERT INTO scott.emp VALUES (7844, 'TURNER', 'SALESMAN',  7698, TO_DATE('1981-09-08','YYYY-MM-DD'), 1500, 0,    30);
INSERT INTO scott.emp VALUES (7900, 'JAMES',  'CLERK',     7698, TO_DATE('1981-12-03','YYYY-MM-DD'),  950, NULL, 30);
INSERT INTO scott.emp VALUES (7654, 'MARTIN', 'SALESMAN',  7698, TO_DATE('1981-09-28','YYYY-MM-DD'), 1250, 1400, 30);
INSERT INTO scott.emp VALUES (7499, 'ALLEN',  'SALESMAN',  7698, TO_DATE('1981-02-20','YYYY-MM-DD'), 1600, 300,  30);
INSERT INTO scott.emp VALUES (7521, 'WARD',   'SALESMAN',  7698, TO_DATE('1981-02-22','YYYY-MM-DD'), 1250, 500,  30);
INSERT INTO scott.emp VALUES (7934, 'MILLER', 'CLERK',     7782, TO_DATE('1982-01-23','YYYY-MM-DD'), 1300, NULL, 10);
INSERT INTO scott.emp VALUES (7876, 'ADAMS',  'CLERK',     7788, TO_DATE('1987-07-13','YYYY-MM-DD'), 1100, NULL, 20);
INSERT INTO scott.emp VALUES (7369, 'SMITH',  'CLERK',     7902, TO_DATE('1980-12-17','YYYY-MM-DD'),  800, NULL, 20);

-- SALGRADE 데이터
INSERT INTO scott.salgrade VALUES (1,  700, 1200);
INSERT INTO scott.salgrade VALUES (2, 1201, 1400);
INSERT INTO scott.salgrade VALUES (3, 1401, 2000);
INSERT INTO scott.salgrade VALUES (4, 2001, 3000);
INSERT INTO scott.salgrade VALUES (5, 3001, 9999);


-- pay_history 샘플 삽입
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7369, DATE '2025-01-01', 800,   NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7499, DATE '2025-01-02', 1600,  300);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7521, DATE '2025-01-03', 1250,  500);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7566, DATE '2025-01-04', 2975,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7654, DATE '2025-01-05', 1250,  1400);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7698, DATE '2025-01-06', 2850,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7782, DATE '2025-01-07', 2450,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7788, DATE '2025-01-08', 3000,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7839, DATE '2025-01-09', 5000,  500);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7844, DATE '2025-01-10', 1500,  0);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7876, DATE '2025-01-11', 1100,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7900, DATE '2025-01-12', 950,   NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7902, DATE '2025-01-13', 3000,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7934, DATE '2025-01-14', 1300,  NULL);

INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7369, DATE '2025-01-15', 800,   NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7499, DATE '2025-01-16', 1600,  200);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7521, DATE '2025-01-17', 1250,  400);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7566, DATE '2025-01-18', 2975,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7654, DATE '2025-01-19', 1250,  1200);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7698, DATE '2025-01-20', 2850,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7782, DATE '2025-01-21', 2450,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7788, DATE '2025-01-22', 3000,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7839, DATE '2025-01-23', 5000,  600);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7844, DATE '2025-01-24', 1500,  0);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7876, DATE '2025-01-25', 1100,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7900, DATE '2025-01-26', 950,   NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7902, DATE '2025-01-27', 3000,  NULL);
INSERT INTO scott.pay_history VALUES (scott.seq_pay_history.NEXTVAL, 7934, DATE '2025-01-28', 1300,  NULL);


COMMIT;