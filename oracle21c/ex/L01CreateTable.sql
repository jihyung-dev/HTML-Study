-- 데이터 소스 만드는 법
--     url:jdbc:oracle:thin:@//localhost:3000/XEPDB1
--     user : system
--     password : oracle
-- select 7*8 from dual;  //주석달기 ctrl + /

create user table_user identified by "1234"
default tablespace USERS
temporary tablespace TEMP
quota unlimited on USERS;

grant connect, resource to table_user;

create table table_user.board(
    no NUMBER,
    title varchar2(50),
    contents varchar2(100)
);

create user table_user2 identified by "12345"
default tablespace USERS
temporary tablespace TEMP
quota unlimited on users;

grant connect, resource to table_user2;

create table TABLE_USER2.Game(
    no NUMBER,
    title varchar2(50),
    genre varchar2(10)
);

alter table TABLE_USER2.Game modify genre VARCHAR2(256);

