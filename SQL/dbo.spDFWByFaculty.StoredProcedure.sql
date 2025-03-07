USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spDFWByFaculty]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	DFW by faculty
-- Example:		exec spDFWByFaculty 2018.66,2019.33,'MAT','%','%','create table temp (a varchar(100)); insert into temp select x from (values (''F''),(''W'')) temp(x)'
-- Paremeters:	fStart, fEnd sSubjectCode sInstructor sCourseNumber sGrades 
-- =============================================
CREATE PROCEDURE [dbo].[spDFWByFaculty] 
	@Start float,
	@End float,
	@SubjectCode varchar(10),
	@Instructor varchar(50), 
	@CourseNumber varchar(10),
	@sGradesSQL nvarchar(max)

AS
BEGIN

	begin try
		drop table temp
	end try 
	begin catch
		--
	end catch

	execute(@sGradesSQL)

	select		[INSTRUCTORNAME], 
				(
				select	count(*) 
				from	OIR R1
				where	R1.[INSTRUCTORNAME] = R0.[INSTRUCTORNAME]
						and R1.[CURRENTTERM] like R0.[CURRENTTERM]
						and R1.[CT_SUBJECT] = R0.[CT_SUBJECT]
						and R1.[SHRTCKN_SUBJ_CODE] like @SubjectCode
						and	R1.[SHRTCKG_GRDE_CODE_FINAL] in (select a from temp)					
				)  as DFW,
				(
				select	count(*) 
				from	OIR R1
				where	R1.[INSTRUCTORNAME] = R0.[INSTRUCTORNAME]
						and R1.[CURRENTTERM] like R0.[CURRENTTERM]
						and R1.[CT_SUBJECT] = R0.[CT_SUBJECT]
						and  R1.[SHRTCKN_SUBJ_CODE] like @SubjectCode
				) as TOTAL,
				0, -- placeholder for DFW ratio
				cast(CT_SUBJECT as integer) as LEVEL,
				[CURRENTTERM],
				[SHRTCKN_CRSE_TITLE]
	from		OIR R0
	where		--sTerm sSubjectCode sInstructor sCourseNumber sGrades 
				[INSTRUCTORNAME] like @Instructor
				and [CURRENTTERM] >= @Start
				and [CURRENTTERM] <= @End
				and [CT_SUBJECT] like @CourseNumber
				and [SHRTCKN_SUBJ_CODE] like @SubjectCode				 
	group by	[INSTRUCTORNAME], [CT_SUBJECT], [CURRENTTERM],[SHRTCKN_CRSE_TITLE]
	--having		TOTAL > 10
	order by	[CURRENTTERM], DFW desc

	begin try
		drop table temp
	end try 
	begin catch
		--
	end catch
END
GO
