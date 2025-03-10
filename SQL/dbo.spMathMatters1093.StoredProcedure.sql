USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spMathMatters1093]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	MathMatters 1093
-- Example:		exec spMathMatters1093
-- =============================================
CREATE PROCEDURE [dbo].[spMathMatters1093] 

AS
BEGIN
	select abc123, 1, grade  
	from	F19_1093T1 F
			--join OIR O on O.[IDENTIFIER] = F.abc123
	where	(select count(IDENTIFIER) from OIR where F.abc123 = OIR.identifier and [CT_SUBJECT] in ('1073','1053') and [SHRTCKN_SUBJ_CODE]='MAT')  > 0
			and F.grade is not null 
	union
	select abc123, 0, grade  
	from	F19_1093T1 F
			--join OIR O on O.[IDENTIFIER] = F.abc123
	where	(select count(IDENTIFIER) from OIR where F.abc123 = OIR.identifier and [CT_SUBJECT] in ('1073','1053') and [SHRTCKN_SUBJ_CODE]='MAT')  = 0 
			and F.grade is not null 
	order by abc123
END

--select IDENTIFIER from OIR where 'aia114' = OIR.identifier and [CT_SUBJECT]  in ('1073','1053') and [SHRTCKN_SUBJ_CODE]='MAT'
--select * from oir where identifier = 'aia114'
GO
