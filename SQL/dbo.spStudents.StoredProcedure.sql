USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spStudents]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Retrieve colleges, students and credit hour per semester
-- Example:		exec spStudents '%', '%', 2009.66, 2019.33
--				exec spStudents 'Sciences','Mathematics',2014.66,2019
--				exec spStudents 'Sciences','%',2014.66,2019
-- =============================================
CREATE PROCEDURE [dbo].[spStudents] 
	@college varchar(50), @department varchar(50), @start float, @end float 

AS
BEGIN
--SELECT DISTINCT [FIRSTGENERATIONSTATUS] FROM OIR
	SELECT		O.COLLEGE, O.DEPARTMENT, O.CURRENTTERM, sum(O.[SHRTCKG_CREDIT_HOURS]) as CH,
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
							--and D1.COLLEGE <> 'NA' 
							--and D.COLLEGE = D1.COLLEGE
							--and D.DEPARTMENT = D1.DEPARTMENT
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
				) as STUDENTS,
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[STUDENTTYPE] = 'New'
							and O1.[FIRSTGENERATIONSTATUS] <> 'First Generation'
				) as [NEWNONFIRST],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[STUDENTTYPE] = 'New'
							and O1.[FIRSTGENERATIONSTATUS] = 'First Generation'
				) as [NEWFIRSTGEN],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[STUDENTTYPE] = 'Transfer'
							and O1.[FIRSTGENERATIONSTATUS] <> 'First Generation'
				) as [TRANSFERNONFIRST],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[STUDENTTYPE] = 'Transfer'
							and O1.[FIRSTGENERATIONSTATUS] = 'First Generation'
				) as [TRANSFERFIRSTGEN],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[GENDER] = 'Female'
				) as [FEMALE],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[GENDER] = 'Male'
				) as [MALE],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[PELLSTATUS] = 'Pell Paid'
				) as [PELL],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 --join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	O1.CURRENTTERM = O.CURRENTTERM
							and O1.COLLEGE = O.COLLEGE
							and O1.DEPARTMENT = O.DEPARTMENT
					--where	D1.COLLEGE <> 'NA' 
					--		and O1.CURRENTTERM = O.CURRENTTERM
					--		and D.COLLEGE = D1.COLLEGE
					--		and D.DEPARTMENT = D1.DEPARTMENT
							and O1.[PELLSTATUS] = 'No Pell'
				) as [NOPELL]

	from		DEPT D join OIR O on D.[SUBJECT]= O.[SHRTCKN_SUBJ_CODE]
	where		D.COLLEGE <> 'NA' 
				and O.CURRENTTERM >= @start 
				and O.CURRENTTERM <= @end
				and D.COLLEGE like  @college
				and D.DEPARTMENT like @department
				and O.COLLEGE like  @college
				and O.DEPARTMENT like @department
	group by	O.CURRENTTERM, O.COLLEGE, O.DEPARTMENT
	order by	O.CURRENTTERM, O.COLLEGE, O.DEPARTMENT

END
GO
