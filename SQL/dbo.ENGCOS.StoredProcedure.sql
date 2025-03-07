USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[ENGCOS]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Distribution of students and credit hours by COS and ENG
-- Example:		exec [ENGCOS
-- =============================================
CREATE PROCEDURE [dbo].[ENGCOS] 

AS
BEGIN

	select	COUNT(distinct IDENTIFIER), sum(SHRTCKG_CREDIT_HOURS) 
	from	OIR O1 
	where	SHRTCKN_SUBJ_CODE IN ('MAT','BIO','CHE','PHY','GEO','ES','CS')
	--group by IDENTIFIER 
	union
	select	COUNT(distinct IDENTIFIER), sum(SHRTCKG_CREDIT_HOURS) 
	from	OIR O1 
	where	SHRTCKN_SUBJ_CODE IN ('BME','CME','CE','EE','ME')
	--group by IDENTIFIER 
	union
	select	COUNT(distinct IDENTIFIER), sum(SHRTCKG_CREDIT_HOURS) 
	from	OIR O1 
	where	SHRTCKN_SUBJ_CODE not IN ('BME','CME','CE','EE','ME','MAT','BIO','CHE','PHY','GEO','ES','CS')
	--group by IDENTIFIER 
	union
	select	COUNT(distinct IDENTIFIER), sum(SHRTCKG_CREDIT_HOURS) 
	from	OIR O1 
	--group by IDENTIFIER 

END
GO
