-- 데이터 소스 만드는 법
--     url:jdbc:oracle:thin:@//localhost:3000/XEPDB1
--     user : table_user
--     password : 1234
--     데이터 소스 : @localhost/table_user
-- select 7*8 from dual;  //주석달기 ctrl + /

-- create user table_user identified by "1234"
-- default tablespace USERS
-- temporary tablespace TEMP
-- quota unlimited on USERS;

create table member(
    name varchar2(10),
    age NUMBER
);
-- varchar2 : 문자열 ''
-- number : 수
INSERT INTO member(name, age) VALUES ('이지형',20);
INSERT INTO member(name, age) VALUES ('김지형',25);
commit;
select name, age from member;

select * from member;

insert into board(no, title, contents) values (1,'웹표준의 정석','이지스퍼블리싱');
insert into board(no, title, contents) values (2,'파이썬 철저 입문','위키북스');

select no, title, contents from board;



