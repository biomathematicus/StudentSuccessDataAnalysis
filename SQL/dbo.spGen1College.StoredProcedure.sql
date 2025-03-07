USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spGen1College]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Retrieve colleges, students and credit hour per semester
-- Example:		exec [spGen1College]
-- =============================================
CREATE PROCEDURE [dbo].[spGen1College] 
	@start float, @end float

AS
BEGIN
--SELECT DISTINCT [FIRSTGENERATIONSTATUS] FROM OIR
	SELECT		D.COLLEGE, O.CURRENTTERM, sum(O.[SHRTCKG_CREDIT_HOURS]) as CH,
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	D1.COLLEGE <> 'NA' 
							and O1.CURRENTTERM = O.CURRENTTERM
							and D.COLLEGE = D1.COLLEGE
				) as STUDENTS,
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	D1.COLLEGE <> 'NA' 
							and O1.CURRENTTERM = O.CURRENTTERM
							and D.COLLEGE = D1.COLLEGE
							and O1.[STUDENTTYPE] = 'New'
				) as [NEW],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	D1.COLLEGE <> 'NA' 
							and O1.CURRENTTERM = O.CURRENTTERM
							and D.COLLEGE = D1.COLLEGE
							and O1.[STUDENTTYPE] = 'New'
							and O1.[FIRSTGENERATIONSTATUS] = 'First Generation'
				) as [NEWFIRSTGEN],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	D1.COLLEGE <> 'NA' 
							and O1.CURRENTTERM = O.CURRENTTERM
							and D.COLLEGE = D1.COLLEGE
							and O1.[STUDENTTYPE] = 'Transfer'
				) as [TRANSFER],
				(
					select	count(distinct O1.IDENTIFIER)
					from	OIR O1 join DEPT D1 on O1.COLLEGE = D1.COLLEGE
					where	D1.COLLEGE <> 'NA' 
							and O1.CURRENTTERM = O.CURRENTTERM
							and D.COLLEGE = D1.COLLEGE
							and O1.[STUDENTTYPE] = 'Transfer'
							and O1.[FIRSTGENERATIONSTATUS] = 'First Generation'
				) as [TRANSFERFIRSTGEN]
	from		DEPT D join OIR O on D.[SUBJECT]= O.[SHRTCKN_SUBJ_CODE]
	where		D.COLLEGE <> 'NA' 
				and O.CURRENTTERM >= @start and O.CURRENTTERM <= @end
	group by	O.CURRENTTERM, D.COLLEGE
	order by	O.CURRENTTERM, D.COLLEGE

END
GO
