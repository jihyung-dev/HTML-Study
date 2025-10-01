insert into member values ('김지형', 25);

select * from member;

-- DDL CREATE 생성, ALTER
-- ALTER TABLE MEMBER DROP COLUMN AGE; AGE 열 삭제
-- ALTER TABLE MEMBER MODIFY AGE NUMBER(3); 비워야 수정가능

UPDATE MEMBER SET AGE=NULL;  -- WHERE이 없으면 모두 NULL로 변환,        DML (DATA)명령어
ALTER TABLE MEMBER MODIFY AGE NUMBER(3);                         -- DDL (구조)변경 명령어

-- UPDATE MEMBER SET AGE=250 WHERE NAME='김지형';
-- number(3) -999~999 가능
UPDATE MEMBER SET AGE=25 WHERE NAME='김지형';
UPDATE MEMBER SET AGE=-100 WHERE NAME='이지형';
-- 컬럼의 제약조건을 주는 것은 컬럼 수정이 아닌 제약 조건 등록!
-- 0부터 가능하도록 제약조건을 추가 ADD

ALTER TABLE MEMBER ADD CONSTRAINT age_check check ( AGE>=0 AND AGE <=200); -- 잘못된 제약 (현재 이지형 age = -100)
UPDATE MEMBER SET AGE=0 WHERE NAME='이지형';
UPDATE MEMBER SET AGE=201 WHERE NAME='이지형'; -- 고마운 오류 // 고마해라 마이무따 아이가

ALTER TABLE MEMBER DROP CONSTRAINT AGE_CHECK;
-- 제약조건 삭제
-- 제약조건 수정은 애매해서, 삭제후 생성 하는 방법

INSERT INTO MEMBER (age) VALUES (39); -- 이름없이 나이만 들어온 이상한 데이터 --> 이름이 없는 제약조건을 주기

--지우기 DELETE FROM TABLE WHERE
DELETE FROM MEMBER WHERE AGE=39;

-- ************************** ALTER를 쓸 일은 거의 없다 **************************
-- ALTER TABLE MEMBER ADD CONSTRAINTS name_not_null
alter table member modify (name not null); --> 27행 실행 불가

INSERT INTO MEMBER VALUES ('최경민',39);
INSERT INTO MEMBER VALUES ('이지형',20,2);

ALTER TABLE MEMBER ADD ID NUMBER(5);

DELETE FROM MEMBER WHERE NAME='김지형';

ALTER TABLE MEMBER ADD CONSTRAINT pk_member PRIMARY KEY (id);

INSERT INTO MEMBER (NAME, AGE, ID) VALUES ('김지형',25,1); --무결성 위반
INSERT INTO MEMBER (NAME, AGE, ID) VALUES ('김지형',25,4);

UPDATE MEMBER SET AGE=35 WHERE id=3;