USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spGraduation]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Retrieve colleges, students and credit hour per semester
-- Example:		exec spGradesVsStudents '%', '%', 2009.66, 2019.33
-- =============================================
CREATE PROCEDURE [dbo].[spGraduation] 
	@college varchar(50), @department varchar(50), @start float, @end float 

AS
BEGIN

--select FIRSTGRADDATE, count(distinct IDENTIFIER) from OIR where FIRSTGRADDATE is not null group by FIRSTGRADDATE order by FIRSTGRADDATE

	SELECT		year(FIRSTGRADDATE), FIRSTGRADCOLLEGE, FIRSTGRADDEPT, count(distinct IDENTIFIER)
	from		OIR O --join DEPT D on D.[SUBJECT]= O.[SHRTCKN_SUBJ_CODE]
	where		--D.COLLEGE <> 'NA' 
				CURRENTTERM >= @start 
				and CURRENTTERM <= @end
				and FIRSTGRADCOLLEGE like  @college
				and FIRSTGRADDEPT like @department
				and FIRSTGRADDATE is not null
	group by	FIRSTGRADDATE, FIRSTGRADCOLLEGE, FIRSTGRADDEPT
	order by	FIRSTGRADDATE, FIRSTGRADCOLLEGE, FIRSTGRADDEPT

END


/*
create table #temp (FIRSTGRAD float, STUD float, GRAD float)
insert into #temp
select year(FIRSTGRADDATE), 
		(
			select	count(distinct IDENTIFIER) 
			from	OIR O2 
			where	floor(O2.CURRENTTERM) = year(O1.FIRSTGRADDATE) and 
					floor(O2.CURRENTTERM) =   
					(
						select	top 1 CURRENTTERM 
						from	OIR O3 
						where	O3.IDENTIFIER = O2.IDENTIFIER
						order by CURRENTTERM asc
					) and
		) as STUDENTS
from	OIR O1 
where	FIRSTGRADDATE is not null group by FIRSTGRADDATE order by FIRSTGRADDATE


select	distinct(year(FIRSTGRADDATE)) as Y, 
		(
			select	count(distinct IDENTIFIER) 
			from	OIR O2 
			where	floor(CURRENTTERM) = Y and 
					O2.IDENTIFIER = O1.IDENTIFIER and
					floor(CURRENTTERM) =   
					(
						select	top 1 CURRENTTERM 
						from	OIR O3 
						where	O3.IDENTIFIER = O2.IDENTIFIER
						order by CURRENTTERM asc
					)
		) as STUDENTS
from	OIR O1 
where	FIRSTGRADDATE is not null group by FIRSTGRADDATE order by FIRSTGRADDATE
*/
GO
