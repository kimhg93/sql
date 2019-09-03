-- upper
-- 1. 자바 upperCase 보다 DB의 upper() 함수가 훨씬 빠르다
-- 2. 웬만한 DB에서 문자열 처리 뿐만 아니라 포멧팅 처리 등을 다 해주고 
--    자바에서 출력만 해결한다.
-- 3. 자바 코드가 간결해서 좋다.
select	upper('SeouL'), ucase('seoul');
select 	upper(first_name) from employees;

-- lower 
select	lower('SEoul'), lcase('SEOUL');

-- substring()
select	substring('Happy Day', 3, 2);

select	first_name as '이름',
		substring(hire_date, 1, 4) as '입사연도'
from	employees;

-- lpad, rpad
select	lpad('1234', 10, '-');
select	rpad('1234', 10, '-');

-- ex) salaries 테이블에서 2001년 급여가 70000불 이하의 직원만 사번, 급여로 출력하되 급여는 10자리로 부족한 자리수는 *로 표시
select	emp_no,
		lpad(cast(salary as char), 10, '*')
from	salaries
where	from_date like '2001%'
and		salary < 70000;

-- ltrim, rtrim, trim
select	concat('---', ltrim('      hello     '), '---') as 'LTRIM',
		concat('---', rtrim('      hello     '), '---') as 'RTRIM',
        concat('---', trim('      hello     '), '---') as 'TRIM',
        concat('---', trim(both 'x' from 'xxxxhelloxxxx'), '---') as 'TRIM2',
        concat('---', trim(leading 'x' from 'xxxxhelloxxxx'), '---') as 'TRIM3',
        concat('---', trim(trailing 'x' from 'xxxxhelloxxxx'), '---') as 'TRIM3';
