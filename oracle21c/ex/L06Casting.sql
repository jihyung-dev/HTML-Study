-- 출력만 해보는 것 => 가상테이블 dual
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE,'HH24"시" MI"분" SS"초"') FROM DUAL;

SELECT TO_NUMBER('12345') *3 D;

SELECT '12,345'*3 FROM DUAL;


select substr('oracle',2,3) as "2~3" from dual;