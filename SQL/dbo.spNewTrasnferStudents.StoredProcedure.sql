USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spNewTrasnferStudents]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Compute parameters for an odds ratio analysis
-- Example:		exec spNewTrasnferStudents 2014.66, 2019.33
-- =============================================
CREATE PROCEDURE [dbo].[spNewTrasnferStudents] 
	@start float,
	@end float

AS
BEGIN

	-- Total number of new students who took math
	select		count(distinct IDENTIFIER) from	OIR O1 
	where		CURRENTTERM>=@start 
				and CURRENTTERM<=@end 
				and STUDENTTYPE = 'New' 
				and 'MAT' in (select distinct SHRTCKN_SUBJ_CODE from OIR o2 where O1.identifier = o2.IDENTIFIER)
				and O1.IDENTIFIER not in (select DISTINCT IDENTIFIER from OIR o2 where O1.IDENTIFIER = o2.IDENTIFIER and o2.CURRENTTERM < @start)
	union
	-- Total number of transfer students who took math
	select		count(distinct identifier) from	OIR O1 
	where		CURRENTTERM>=@start 
				and CURRENTTERM<=@end 
				and STUDENTTYPE = 'Transfer' 
				and 'MAT' in (select distinct SHRTCKN_SUBJ_CODE from OIR o2 where O1.identifier = o2.IDENTIFIER)
				and O1.IDENTIFIER not in (select distinct IDENTIFIER from OIR o2 where O1.IDENTIFIER = o2.IDENTIFIER and o2.CURRENTTERM < @start)
	union
	-- Total number of new students who did not take math
	select		count(distinct identifier) from	OIR O1 
	where		CURRENTTERM>=@start 
				and CURRENTTERM<=@end 
				and STUDENTTYPE = 'New' 
				and 'MAT' not in (select distinct SHRTCKN_SUBJ_CODE from OIR o2 where O1.identifier = o2.IDENTIFIER)
				and O1.IDENTIFIER not in (select distinct IDENTIFIER from OIR o2 where O1.IDENTIFIER = o2.IDENTIFIER and o2.CURRENTTERM < @start)
	union
	-- Total number of transfer students who did not take math
	select		count(distinct identifier) from	OIR O1 
	where		CURRENTTERM>=@start 
				and CURRENTTERM<=@end 
				and STUDENTTYPE = 'Transfer' 
				and 'MAT' not in (select distinct SHRTCKN_SUBJ_CODE from OIR o2 where O1.identifier = o2.IDENTIFIER)
				and O1.IDENTIFIER not in (select distinct IDENTIFIER from OIR o2 where O1.IDENTIFIER = o2.IDENTIFIER and o2.CURRENTTERM < @start)

END
GO
