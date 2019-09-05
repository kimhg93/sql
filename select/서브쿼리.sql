-- 단일행 연산

-- ex) 현재 Fai Bale이 근무하는 부서에서 근무하는 (직원의 사번, 전체이름)을 출력해보세요.

-- sol1-1)
select a.dept_no
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and a.to_date = '9999-01-01'
   and concat(b.first_name, ' ', b.last_name) = 'Fai Bale' ;
 
 -- sol1-2)
select b.emp_no, concat(b.first_name, ' ', b.last_name)
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and a.to_date = '9999-01-01'
   and a.dept_no = 'd004';
   
-- sol subquery
select b.emp_no, concat(b.first_name, ' ', b.last_name)
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and a.to_date = '9999-01-01'
   and a.dept_no = (select a.dept_no
				  from dept_emp a, employees b
				 where a.emp_no = b.emp_no
				   and a.to_date = '9999-01-01'
				   and concat(b.first_name, ' ', b.last_name) = 'Fai Bale') ;
                   
                   
-- 서브쿼리는 괄호로 묶여야 함
-- 서브쿼리 내에 order by 금지
-- group by 절에 외에 거의 모든 절에서 사용가능( 특히, from, where절에 많이 사용)
-- where 절인 경우,
--       1) 단일행 연산자 : =, >, <, >=, <=, <>




-- 실습문제1) 현재 (전체사원의 평균 연봉)보다 적은 급여를 받는 (사원의 이름, 급여)를 나타내세요.
select concat(a.first_name, ' ', a.last_name), b.salary
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and b.salary < (select avg(salary)
                     from salaries
					where to_date = '9999-01-01');

-- 실습문제2) 현재 가장적은 평균 급여를 받고 있는 직책에 대해서 평균 급여를 구하세요               

-- top-K 를 사용
  select b.title, avg(a.salary)
    from salaries a, titles b
   where a.emp_no = b.emp_no
	 and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by b.title
  having avg(a.salary) = (select avg(a.salary)
							from salaries a, titles b
						   where a.emp_no = b.emp_no
							 and a.to_date = '9999-01-01'
                             and b.to_date = '9999-01-01'
						group by b.title
                        order by avg(a.salary) asc
                           limit 0,1);
                           
-- 방법2 from절에 서브쿼리 및 집계함수 사용
select min(a.avg_salary)               
from ( select round(avg(a.salary)) as avg_salary
        from salaries a, titles b
       where a.emp_no = b.emp_no
         and a.to_date = '9999-01-01'
         and b.to_date = '9999-01-01'
	group by b.title) a;
    
    
  select b.title, avg(a.salary)
    from salaries a, titles b
   where a.emp_no = b.emp_no
	 and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by b.title
  having avg(a.salary) = (select min(a.avg_salary)               
                           from ( select round(avg(a.salary)) as avg_salary
								    from salaries a, titles b
                                   where a.emp_no = b.emp_no
									 and a.to_date = '9999-01-01'
                                     and b.to_date = '9999-01-01'
								group by b.title) a); 

-- 방법3 join으로 만 풀기(굳이 서브쿼리를 쓸 필요가 없다)
select avg(a.salary)
  from salaries a, titles b
 where a.emp_no = b.emp_no
   and a.to_date = '9999-01-01'
   and b.to_date = '9999-01-01'
 group by b.title
 order by avg(a.salary) asc
 limit 0,1;

-- where 절인 경우
--   2) 다중(복수)행 연산자: in, any, all, not in
--      2-1) any 사용법
--           1. =any : in과 완전 동일
--           2. >any, >=any : 최소값 
--           3. <any, <=any : 최대값
--           4. <>any, !=any : !=all 와 동일
--      2-2) all 사용법
--           1. =all : in과 완전 동일
--           2. >all, >=all : 최대값 
--           3. <all, <=all : 최소값

-- 1) 현재 급여가 50000 이상인 직원 이름 출력

-- 방법 1: join으로 해결
select a.first_name
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and b.salary > 50000;

-- 방법 2: in
select first_name
  from employees
 where emp_no in(select emp_no
				   from salaries
				  where to_date = '9999-01-01'
					and salary > 50000);

select emp_no
  from salaries
 where to_date = '9999-01-01'
   and salary > 50000;
   
-- 2) 각 부서별로 최고월급을 받는 직원의 이름과 월급을 출력
--    dept_no, first_name, max_salary

-- 부서별 max_salary
  select b.dept_no, max(c.salary) as max_salary
    from employees a, dept_emp b, salaries c
   where a.emp_no = b.emp_no
	 and a.emp_no = c.emp_no
     and b.to_date = '9999-01-01'
     and c.to_date = '9999-01-01'
group by b.dept_no;

-- 방법 1: where 절에 서브쿼리 사용
select b.dept_no, a.first_name, c.salary
  from employees a, dept_emp b, salaries c
 where a.emp_no = b.emp_no
   and a.emp_no = c.emp_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and (c.salary, b.dept_no) = any (select max(c.salary), b.dept_no
								      from employees a, dept_emp b, salaries c
								     where a.emp_no = b.emp_no
                                       and a.emp_no = c.emp_no
                                       and b.to_date = '9999-01-01'
                                       and c.to_date = '9999-01-01'
							      group by b.dept_no);
                               
-- 방법 2: from 절에 서브쿼리 사용
select b.dept_no, a.first_name, c.salary
  from employees a, 
	   dept_emp b, 
       salaries c,
       (select max(c.salary) as max_salary, b.dept_no
          from employees a, dept_emp b, salaries c
		 where a.emp_no = b.emp_no
           and a.emp_no = c.emp_no
           and b.to_date = '9999-01-01'
           and c.to_date = '9999-01-01'
	  group by b.dept_no) d      
 where a.emp_no = b.emp_no
   and a.emp_no = c.emp_no
   and b.dept_no = d.dept_no   
   and c.salary = d.max_salary
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01';
   
   select *, (select now()) from employees
