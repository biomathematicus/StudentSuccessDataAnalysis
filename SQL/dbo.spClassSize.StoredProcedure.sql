USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spClassSize]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Student demographics
-- Example:		exec spClassSize
-- =============================================
CREATE PROCEDURE [dbo].[spClassSize] 

AS
BEGIN
	SELECT	CURRENTTERM,INSTRUCTORNAME, SHRTCKN_SUBJ_CODE, CT_SUBJECT, count(distinct IDENTIFIER) as STUDENTS,
			(	
				select count(distinct [IDENTIFIER]) 
				from oir o2 
				where	o1.CURRENTTERM = o2.CURRENTTERM 
						and o1.INSTRUCTORNAME = o2.INSTRUCTORNAME
						and o1.SHRTCKN_SUBJ_CODE = o2.SHRTCKN_SUBJ_CODE
						and o1.CT_SUBJECT  = o2.CT_SUBJECT
						and o2.[SHRTCKG_GRDE_CODE_FINAL] in  ('A', 'A+','A-', 'B', 'B+', 'B-')
			) as AB,
			(	
				select count(distinct [IDENTIFIER]) 
				from oir o2 
				where	o1.CURRENTTERM = o2.CURRENTTERM 
						and o1.INSTRUCTORNAME = o2.INSTRUCTORNAME
						and o1.SHRTCKN_SUBJ_CODE = o2.SHRTCKN_SUBJ_CODE
						and o1.CT_SUBJECT  = o2.CT_SUBJECT
						and o2.[SHRTCKG_GRDE_CODE_FINAL] in  ('C+', 'C', 'C-')
			) C,
			[SHRTCKN_CRN]
	FROM	OIR o1
	--where	SHRTCKN_SUBJ_CODE = 'MAT'
	group by CURRENTTERM, INSTRUCTORNAME, SHRTCKN_SUBJ_CODE, SHRTCKN_CRSE_TITLE, CT_SUBJECT,SHRTCKN_CRN
	order by SHRTCKN_SUBJ_CODE, CT_SUBJECT, CURRENTTERM, INSTRUCTORNAME

				
END
GO
