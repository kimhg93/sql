-- 문제1
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(*)
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and b.salary > (select avg(salary)
					 from salaries);

-- 문제2
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다.
select a.emp_no,
       concat(a.first_name, ' ', a.last_name), 
       d.dept_name,
       c.salary
  from employees a, dept_emp b, salaries c, departments d
 where a.emp_no = b.emp_no
   and a.emp_no = c.emp_no
   and b.dept_no = d.dept_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and (c.salary, b.dept_no) = any (select max(c.salary), b.dept_no
								      from employees a, dept_emp b, salaries c
								     where a.emp_no = b.emp_no
                                       and a.emp_no = c.emp_no
                                       and b.to_date = '9999-01-01'
                                       and c.to_date = '9999-01-01'
							      group by b.dept_no)
order by c.salary desc;


select max(c.salary), b.dept_no
								      from employees a, dept_emp b, salaries c
								     where a.emp_no = b.emp_no
                                       and a.emp_no = c.emp_no
                                       and b.to_date = '9999-01-01'
                                       and c.to_date = '9999-01-01'
							      group by b.dept_no;
-- 문제3
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요
  select b.dept_no, avg(c.salary)
    from employees a, dept_emp b, salaries c
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
group by b.dept_no;

select a.emp_no,
       concat(a.first_name, ' ', a.last_name), 
       c.salary,
       d.avg_salary
  from employees a, dept_emp b, salaries c,
       (select b.dept_no, avg(c.salary) as avg_salary
          from employees a, dept_emp b, salaries c
		 where a.emp_no = b.emp_no
           and a.emp_no = c.emp_no
           and b.to_date = '9999-01-01'
           and c.to_date = '9999-01-01'
	  group by b.dept_no) d       
 where a.emp_no = b.emp_no
   and a.emp_no = c.emp_no
   and b.dept_no = d.dept_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and c.salary > d.avg_salary;
      
-- 문제4
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.
select b.dept_no, a.first_name, a.last_name
  from employees a, dept_manager b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01';
   
select a.emp_no, 
       concat(a.first_name, ' ', a.last_name),
       d.manager,
       c.dept_name
  from employees a, dept_emp b, departments c,
       (select b.dept_no, concat(a.first_name, ' ', a.last_name) as manager
          from employees a, dept_manager b
         where a.emp_no = b.emp_no
           and b.to_date = '9999-01-01') d
 where a.emp_no = b.emp_no
   and b.dept_no = c.dept_no
   and b.dept_no = d.dept_no 
   and b.to_date = '9999-01-01';
 

-- 문제5
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
  select b.dept_no
    from employees a, dept_emp b, salaries c
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
     and b.to_date = '9999-01-01'
     and c.to_date = '9999-01-01'
group by b.dept_no
order by avg(c.salary) desc
   limit 0, 1
; 

select a.emp_no, 
       concat(a.first_name, ' ', a.last_name), 
       d.title, 
       c.salary
  from employees a, dept_emp b, salaries c, titles d
 where a.emp_no = b.emp_no
   and a.emp_no = c.emp_no
   and a.emp_no = d.emp_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and d.to_date = '9999-01-01'
   and b.dept_no = (select b.dept_no
                      from employees a, dept_emp b, salaries c
                      where a.emp_no = b.emp_no 
                        and a.emp_no = c.emp_no
                        and b.to_date = '9999-01-01'
                        and c.to_date = '9999-01-01'
				   group by b.dept_no
                   order by avg(c.salary) desc   
                   limit 0, 1);

-- 문제6
-- 평균 연봉이 가장 높은 부서는?
select b.dept_name
  from dept_emp a, departments b
 where a.dept_no = b.dept_no
   and b.dept_no = (  select b.dept_no
                        from employees a, dept_emp b, salaries c
                        where a.emp_no = b.emp_no
                        and a.emp_no = c.emp_no
                        group by b.dept_no
                        order by avg(c.salary) desc
                        limit 0,1)
group by b.dept_name;





-- 문제7.
-- 평균 연봉이 가장 높은 직책?
  select b.title
    from employees a, titles b, salaries c
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
group by b.title
order by avg(c.salary) desc
   limit 0,1;



-- 문제8
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은? 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.
select b.dept_no, c.salary, concat(a.first_name, ' ', a.last_name)
  from employees a, dept_manager b, salaries c
 where a.emp_no = b.emp_no
   and a.emp_no = c.emp_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01';

select c.dept_name,
	   concat(a.first_name, ' ', a.last_name),
       d.salary,       
       e.manager_name,
       e.manager_salary
  from employees a, dept_emp b, departments c, salaries d,
       (select b.dept_no, c.salary as manager_salary, concat(a.first_name, ' ', a.last_name) as manager_name
          from employees a, dept_manager b, salaries c
		 where a.emp_no = b.emp_no
           and a.emp_no = c.emp_no
           and b.to_date = '9999-01-01'
           and c.to_date = '9999-01-01') e
   where a.emp_no = b.emp_no
     and a.emp_no = d.emp_no
     and b.dept_no = c.dept_no
     and c.dept_no = e.dept_no
     and b.to_date = '9999-01-01'
     and d.to_date = '9999-01-01'
     and d.salary > e.manager_salary;


   
   