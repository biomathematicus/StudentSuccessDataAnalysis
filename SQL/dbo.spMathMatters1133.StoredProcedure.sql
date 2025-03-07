USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spMathMatters1133]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	MathMatters1133
-- Example:		exec spMathMatters1133
-- =============================================
CREATE PROCEDURE [dbo].[spMathMatters1133] 

AS
BEGIN
	select 1, P1,P2,P3,P4,P5 
	from	[dbo].[F19_1133] F
			join OIR O on O.[IDENTIFIER] = F.ID
	where	--F.ID in (select IDENTIFIER from OIR where [CT_SUBJECT] in ('1073','1053')) 
			(select count(IDENTIFIER) from OIR where F.ID = OIR.identifier and [CT_SUBJECT] in ('1073','1053') and [SHRTCKN_SUBJ_CODE]='MAT')  > 0
			and F.p1 is not null 
	union
	select 0, P1,P2,P3,P4,P5 
	from	[dbo].[F19_1133] F
			join OIR O on O.[IDENTIFIER] = F.ID
	where	(select count(IDENTIFIER) from OIR where F.ID = OIR.identifier and [CT_SUBJECT] in ('1073','1053') and [SHRTCKN_SUBJ_CODE]='MAT')  = 0
			and F.p1 is not null 
END
GO
