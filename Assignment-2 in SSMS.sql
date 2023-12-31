								--Assignment-2

--1. Write a program to accept a year and display the emps belongs to that year?
 select * from emp
 create function empyear1(@year int)
 returns table
 as
 return select empno,ename,year(hiredate) as "year1" from emp where year(hiredate)=@year

 select * from empyear1(1981)



--2.Write a program to accept a mgr and display who are working under that mgr?
select * from emp
create function empmgr2(@mgr int)
returns table
as
return select * from emp where mgr=@mgr

select * from empmgr2(7782)



--3. Write a program to accept the grade and display emps belongs to that grade?
select * from emp
select * from salgrade

create procedure gradeemps3(@grade int)
as
begin
select e.*,s.grade from emp e
join salgrade s on e.sal between s.losal and s.hisal
where s.grade=@grade
end

exec gradeemps3 4










--4. Write a program to accept a deptno and display who are working in that dept?
select * from emp
select * from dept

create function empfunction4(@dno int)
returns table
as
return (select e.empno,e.ename,e.job,e.sal,d.deptno,d.dname from emp e
	   join dept d on e.deptno=d.deptno
		where d.deptno=@dno)

select * from empfunction4(10)



select * from emp
select * from dept
--5. Write a program to accept the location and display empno, name, sal , date of join and also display the total salary, avg salary and no of emps?


create procedure empproc5(@location varchar(40))
as
begin
select * from emp e1 inner join (select e.deptno,sum(e.sal) as "Total Salary",avg(e.sal) as "Avg Salary",count(e.empno) as "No of Emps"
		from emp e
		where e.deptno in (select deptno from dept where loc=@location)
		group by e.deptno) e2 on e1.deptno=e2.deptno 
end

exec Empproc5 'New York'


--6. Write a program to accept a range of salary (that is lower boundary and higher boundary) and print the details of emps along with loc,grade and exp?
select * from emp
select * from dept
select * from salgrade

create function rangeofSal(@losal int,@hisal int)
returns table
as
return 
select e.*,d.loc,s.* from emp e
join dept d on e.deptno=d.deptno
join salgrade s on e.sal between s.losal and s.hisal
where e.sal between @losal and @hisal

select * from rangeofSal(1500,2000)






select * from emp

--7. Write a program to print all the details of emps accepting the job?
create function empjob7(@job varchar(40))
returns table
as
return (select * from emp where job=@job)

select * from empjob7('Salesman')

--8. Write a program to display the details of emps year wise?
select * from emp

create procedure empyear8
as
begin
select *,year(hiredate) as "Year Wise" from emp order by hiredate asc
end

exec empyear8

9. Write a program to accept empno and print all the details along with loc and grade?
select * from emp
select * from dept
select * from salgrade

create function emplocgrade9(@empno int)
returns table
as
return ( select e.*,d.loc,s.grade 
		 from emp e
		 join dept d on e.DEPTNO=d.DEPTNO
		 join salgrade s on e.SAL between s.LOSAL and s.HISAL
		 where e.empno=@empno
		)

select * from emplocgrade9(7698)



--10. Write a procedure to accept the deptno as parameter and display the details of that dept also display the total salary, no of employees, max sal and avg sal?

create procedure deptdetails10(@deptno int)
as
begin
select * from dept d 
inner join (select e.deptno,sum(e.sal) as "Total Salary",count(e.empno) as "No of Employees",max(e.sal) as "Max Salary",avg(e.sal) as "Avg Salary"
			from emp e 
			group by e.DEPTNO) e1 on d.DEPTNO=e1.DEPTNO and d.DEPTNO=@deptno
end

exec deptdetails10 20

--11. Write a procedure to accept two different numbers and print even numbers between the two given numbers?

create procedure numbers12(@num1 int,@num2 int)
as
begin
print 'Even Numbers are: '
while(@num1<=@num2)
begin
	if @num1%2=0
		print @num1
	set @num1=@num1+1
end
end

exec numbers12 1,100

--12. Write a procedure to accept deptno as input and print the details of emps along with grade?
create procedure empdeptgrade12(@deptno int)
as
begin
select e.*,s.grade from emp e
join dept d on e.DEPTNO=d.DEPTNO
join salgrade s on e.sal between s.LOSAL and s.HISAL
where d.DEPTNO=@deptno
end

exec empdeptgrade12 10


--13. Write a procedure to accept a string and check whether it is palindrome or not?
create procedure stringpalin13(@string varchar(40))
as
begin
declare @a varchar(40)
set @a=REVERSE(@string)
if @string=@a
	print @string + ' is palindrome'
else 
	print @string + ' is not palindrome'
end

exec stringpalin13 'Tenet'

--14. Write a procedure to accept the empno and print all the details of emp along with exp, grade and loc?
create or alter procedure empgradeloc14(@empno int)
as
begin
select e.*,s.grade,d.loc 
from emp e
join salgrade s on e.SAL between s.LOSAL and s.HISAL
join dept d on e.DEPTNO=d.DEPTNO
where e.empno=@empno
end

exec empgradeloc14 7782

--15. Write a procedure to accept a string and print it in reverse case?
create procedure stringreverse15(@str varchar(40))
as 
begin
declare @rev varchar(40)
set @rev=REVERSE(@str)
print @rev + ' is the reverse case'
end

exec stringreverse15 'Mike Hussey'













