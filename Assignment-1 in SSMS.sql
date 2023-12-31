								Assignment-1

CREATE TABLE Student ( st_no varchar(35) PRIMARY KEY, st_name varchar(40), st_dob date,	 st_doj date ); 
CREATE TABLE Project ( prj_no varchar(35) PRIMARY KEY, prj_name varchar(40), prj_dur int,prj_platform varchar(30) ); 
CREATE TABLE StudentProject ( st_no varchar(35) Foreign Key(st_no) REFERENCES STUDENT(st_no), prj_no varchar(35) Foreign Key(prj_no) REFERENCES PROJECT(prj_no), 
                              designation varchar(40), PRIMARY KEY (st_no,prj_no,designation) ); 

INSERT INTO Student (st_no,st_name,st_dob,st_doj) VALUES ('ST1','KRUNAL','15-AUG-1982','10-JAN-2003'), ('ST2','BHAVESH','20-AUG-1983','10-JAN-2003'),
 		                                         ('ST3','DARSHAN','15-MAR-1983','12-FEB-2003'),('ST4','DHAVAL','11-MAY-1982','11-MAR-2003'); 
							 ('ST5','BIBIN','23-MAY-1983','12-MAR-2003'), ('ST6','SAMIR','04-SEP-82','12-APR-2003'),
							 ('ST7','CHIRAG','04-JUN-82','12-FEB-2003'); 
INSERT INTO Project(prj_no,prj_name,prj_dur,prj_platform) VALUES ('P01','XYZ',6,'VB'), ('P02','ABC',5,'JAVA'), ('P03','LMN',6,'C++'); 
INSERT INTO StudentProject (st_no,prj_no,designation) VALUES ('ST1','P01','PROGRAMMER'), ('ST2','P01','MANAGER'), ('ST3','P02','MANAGER'), 
 							     ('ST4','P02','MANAGER'), ('ST5','P03','PROGRAMMER'), ('ST6','P03','MANAGER'),
							     ('ST1','P03','PROGRAMMER'), ('ST1','P01','ANALYST'), ('ST3','P02','ANALYST'); 

--1.Display student table records using select statement 
create function Stud()
	returns table
	as
	return (select * from student)

	select * from stud()

--2.Display project table records using select statement 
 create procedure Proj
	as
	begin
	select * from Project
	end
	
	exec Proj

--3.Display studentproject table records using select statement 
Ans: create function StudProj()
	returns table
	as
	return (select * from studentProject)

	select * from studProj()

--4.Find number of student who participated in the project 'p01'  
Ans: create OR ALTER procedure Stud4(@prj_no VARCHAR(30))
	as
	begin
	select count(sp.st_no) as "Number of Students in P01",sp.Prj_no 
	from StudentProject sp 
	join Project p on sp.prj_no=p.prj_no
	where sp.Prj_No=@prj_no
	group by sp.Prj_No
	end

	exec Stud4 'P01'

--5.Find number of student who participated in the more than single project. 
Ans: 	select count(distinct sp.st_no) as "Student participated in the more than single project",sp.st_no,count(distinct sp.prj_no) as "Projects"
	from StudentProject sp 
	group by sp.st_no
	having count(distinct sp.prj_no)>1


--6.Find the no of student who did not participated in any of the project 
Ans: 	select count(s.st_no) as "No of Students",s.st_no,s.st_name 
	from student s 
	left join studentproject sp on s.st_no=sp.st_no
	where sp.st_no is null
	group by s.st_no,s.st_name

--7.Display student_no, prj_name,duration  
Ans: 	select sp.st_no,p.prj_name,p.prj_dur,p.prj_platform
	from studentproject sp 
	inner join project p on sp.prj_no=p.prj_no
	group by sp.st_no,p.prj_name,p.prj_dur,p.prj_platform


--8.Display prj_no,total no student of the project 
Ans: 	select prj_no,count(st_no) as "No of Students of the project"
	from studentproject 
	group by prj_no

--9.Display  a student_no,name, total no of projects. 
Ans: 	select sp.st_no,s.st_name,count(distinct sp.prj_no) as "No of Projects"
	from studentproject sp
	inner join student s on sp.st_no=s.st_no
	group by sp.st_no,s.st_name

--10.Display the information(no,name,age) of student  who made the project in java.
Ans: 	select distinct s.st_no,s.st_name,datediff(yy,st_dob,st_doj) as "Age" 
	from student s 
	inner join studentproject sp on s.st_no=sp.st_no
	inner join project p on sp.prj_no=p.prj_no
	where p.prj_platform='Java'
 

--11.Display the detail of student who is a programmer.
Ans: 	select distinct s.*,sp.designation 
	from student s 
	inner join studentproject sp on s.st_no=sp.st_no
	where sp.designation='Programmer' 

--12.Display the informaton of student who is as programmer and analyst in the same project. (Can use table Alias) 
Ans: select s.* from student s where s.st_no =(select st_no from (select st_no,prj_no from studentproject where designation='programmer' intersect
								  select st_no,prj_no from studentproject where designation='analyst') e)

--13.Display the student who played the max designation(e.g. manager,programmer) in the same project. 
Ans: ;with cte
	as 
	(select count(designation) as Col,st_no,prj_no
 	 from studentproject 
	 group by st_no,prj_no
	)

	select st_no,prj_no,max(col) as "Max Designation"
	from cte 
	group by st_no,prj_no 
	having max(col)>1

--14.Display the info of the project with greater than single no of student involve in it.
Ans: 	select p.prj_no,p.prj_name,p.prj_dur,p.prj_platform,count(distinct sp.st_no) as "More than one Student involved"
	from StudentProject sp 
	join Project p on sp.prj_no=p.prj_no
	group by p.prj_no,p.prj_name,p.prj_dur,p.prj_platform
	having count(distinct sp.st_no)>(select min(col) from cte)

--15.Display detail of the youngest student. 
Ans: select top 1 * from student order by st_dob desc;

--16.Display the info of the project which duration is the largest. 
Ans: with ProDurLar_CTE 
	as
	(
	select prj_no,prj_name,max(prj_dur) as "project which duration is the largest",prj_platform
	from project 
	group by prj_no,prj_name,prj_platform
	having max(prj_dur)>(select min(prj_dur) from project)
	)

	select * from ProDurLar_CTE

--17.who works as a prog and as a analyst not for the same project.(can Use Table alias) 
Ans: 	with Program_Cte as
	(	
	select st_no,prj_no from StudentProject where designation='Programmer'
	),
	Analyst_Cte as
	(
	select st_no,prj_no from StudentProject where designation='Analyst'
	)

	select distinct p.st_no,s.st_name
	from Program_Cte p
	join Analyst_Cte a on p.st_no=a.st_no and p.prj_no!=a.st_no
	join Student s on a.st_no=s.st_no
	-----------------------------------------------------(or)----------------------------------------------------

	select sp1.st_no,s.st_name,sp1.prj_no as "Project Programmer",sp2.prj_no as "Project Analyst"
	from StudentProject sp1
	join StudentProject sp2 on sp1.st_no=sp2.st_no
	join student s on sp2.st_no=s.st_no
	where sp1.designation='Programmer'
	and sp2.designation='Analyst'
	and sp1.prj_no!=sp2.prj_no

--18.Display the info of the student who works as a programmer and not as an analyst for the same project.(can Use Table alias) 
Ans: 	select distinct sp.st_no,s.st_name,sp.prj_no as "Project Programmer",'N/A' as "Project Analyst"
	from StudentProject sp
	join student s on sp.st_no=s.st_no
	where sp.designation='Programmer'
	and not exists(
			select top 1 *
			from StudentProject sp2 
			where sp.st_no=sp2.st_no
			and sp.prj_no=sp2.prj_no
			and sp2.designation='Analyst'
		      )

--19.Display the info of the student who participated in the project where total no of the student should be exact three. 
Ans: create procedure Students19(@count int)
	as begin
	with Three_CTE as
	(
	select s.* from student s where s.st_no in (select st_no from studentproject where prj_no in (select prj_no
	from StudentProject
	group by prj_no
	having count(distinct st_no)=@count))
	)
	select * from Three_CTE
	end

	exec Students19 3

--20.Display the info. of oldest Student with its age. 
Ans: select top 1 st_no,st_name,concat(datediff(yy,st_dob,st_doj) , ' years ',datediff(mm,st_dob,st_doj)%12, ' months ',datediff(dd,st_dob,st_dob), ' days') as Age
	from student
	order by st_dob asc;
