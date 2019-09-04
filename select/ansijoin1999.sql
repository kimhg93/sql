-- ANSI JOIN 1999
-- 1. join ~ on
select 	a.emp_no, a.first_name, c.dept_name 
from	employees a
join	dept_emp b
on		a.emp_no = b.emp_no
join	departments c
on		b.dept_no = c.dept_no;

select 	a.emp_no, a.first_name, c.dept_name 
from	employees a, dept_emp b, departments c
where  	a.emp_no = b.emp_no
and 	b.dept_no = c.dept_no;

select	a.first_name, b.title
from	employees a
join	titles b
on		a.emp_no = b.emp_no;

-- 2. natural join
select	a.first_name, b.title
from	employees a
natural join titles b;

-- 2-1 natural join의 문제점
select 	count(*)
from	salaries a
natural join titles b;

-- 2-2 natural join의 문제점 -> (join ~ using)
select 	count(*)
from	salaries a
join 	titles b using(emp_no);