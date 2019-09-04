select	avg(salary), sum(salary)
from 	salaries
where	emp_no='10060';

select	 emp_no, avg(salary) as avg_salary, sum(salary)
from 	 salaries
where	 to_date-'9999-01-01'
group by emp_no
having	 avg(salary) > 40000
order by avg(salary) asc;

-- ex1) 각 사원별로 평균연봉 출력 
select	 emp_no, avg(salary)
from	 salaries
group by emp_no
order by avg(salary) desc;

-- ex2) 각 현재 Manager 직책 사원에 대한 평균 연봉은?
select 	avg(b.salary)
from	titles a, salaries b
where	a.emp_no = b.emp_no 		-- 조인조건
and		a.to_date = '9999-01-01' 	-- row 선택조건1
and		b.to_date = '9999-01-01' 	-- row 선택조건2
and		a.title = 'Manager';		-- row 선택조건3

-- ex2-1) 각 현재 직책별 평균 연봉은?
select 	 a.title, avg(b.salary)
from	 titles a, salaries b
where	 a.emp_no = b.emp_no 		-- 조인조건
and		 a.to_date = '9999-01-01' 	-- row 선택조건1
and		 b.to_date = '9999-01-01' 	-- row 선택조건2
group by a.title	
order by avg(b.salary) desc;

-- ex3) 사원별 몇 번의 직책 변경이 있었는지 조회 
select	 emp_no, count(*)
from	 titles
group by emp_no
order by count(*) desc;

select * from titles where emp_no='204120';

-- ex4) 각 사원별로 평균연봉 출력하되 50,000불 이상인 직원만 출력 
select 	 emp_no, avg(salary)
from 	 salaries
group by emp_no
having 	 avg(salary) >= 50000
order by avg(salary) asc;

-- ex5) (과제)현재 직책별로 평균 연봉과 인원수를 구하되 직책별로 인원이 100명 이상인 직책만 출력하세요.
select 	 a.title, avg(b.salary), count(a.emp_no)
from 	 titles a, salaries b
where 	 a.emp_no = b.emp_no
and		 a.to_date = '9999-01-01'
and		 b.to_date = '9999-01-01'
group by a.title
having	 count(distinct(a.emp_no)) >= 100;

-- ex6) 현재 부서별로 현재 직책이 Engineer인 직원들에 대해서만 평균급여를 구하세요.
select   avg(b.salary)
from	 titles a, salaries b, dept_emp c
where 	 a.emp_no = b.emp_no
and		 b.emp_no = c.emp_no
and		 a.title = 'Engineer'
and		 a.to_date = '9999-01-01'
and		 b.to_date = '9999-01-01'
and		 c.to_date = '9999-01-01'
group by c.dept_no;

-- ex7) 현재 직책별로 급여의 총합을 구하되 Engineer직책은 제외하세요 단, 
-- 		총합이 2,000,000,000이상인 직책만 나타내며 급여총합에 대해서 내림차순(DESC)로 정렬하세요.
select	 a.title, sum(b.salary)
from	 titles a, salaries b
where  	 a.emp_no = b.emp_no
and  	 a.to_date = '9999-01-01'
and		 b.to_date = '9999-01-01'
and		 a.title != 'Engineer'
group by a.title
having	 sum(b.salary) >= 2000000000
order by sum(b.salary) desc;
