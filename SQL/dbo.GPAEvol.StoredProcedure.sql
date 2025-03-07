USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[GPAEvol]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Retrieve GPA across semesters
-- Example:		exec [GPAEvol]
-- =============================================
CREATE PROCEDURE [dbo].[GPAEvol] 

AS
BEGIN

	select	0, [CURRENTTERM],
			--(select count(*) from OIR O2 where O2.[SHRTCKN_CRN]=O1.[SHRTCKN_CRN]) as SIZE,
			(select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.[CURRENTTERM]=O1.[CURRENTTERM] 
			and [SHRTCKN_SUBJ_CODE] not in ('MAT')
			) as GPA
	from	OIR O1
	where	[SHRTCKN_SUBJ_CODE]  not in ('MAT')
	group by [CURRENTTERM]
	union
	select	1, [CURRENTTERM],
			--(select count(*) from OIR O2 where O2.[SHRTCKN_CRN]=O1.[SHRTCKN_CRN]) as SIZE,
			(select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.[CURRENTTERM]=O1.[CURRENTTERM] 
			and [SHRTCKN_SUBJ_CODE] in ('MAT')
			) as GPA
	from	OIR O1
	where	[SHRTCKN_SUBJ_CODE]   in ('MAT')
	group by [CURRENTTERM]
	union
	select	2, [CURRENTTERM],
			--(select count(*) from OIR O2 where O2.[SHRTCKN_CRN]=O1.[SHRTCKN_CRN]) as SIZE,
			(select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.[CURRENTTERM]=O1.[CURRENTTERM] 
			--and [SHRTCKN_SUBJ_CODE] not in ('MAT')
			) as GPA
	from	OIR O1
	--where	[SHRTCKN_SUBJ_CODE]  not in ('MAT')
	group by [CURRENTTERM]

	order by [CURRENTTERM] asc

END
GO
