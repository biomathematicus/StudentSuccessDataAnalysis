USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spOddsRatioFM]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Compute parameters for an odds ratio analysis for male/female bias
-- Example:		exec spOddsRatioFM 'MAT', '1124', 2014.66, 2015.66
-- =============================================
CREATE PROCEDURE [dbo].[spOddsRatioFM] 
	@subject varchar(6),
	@courseNmbr varchar(6),
	@start float,
	@end float


AS
BEGIN

	-- a = Number of exposed cases: female students who took math classes and failed
	select	1,count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM >= @start and CURRENTTERM <= @end
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) = 0
			and SHRTCKN_SUBJ_CODE = @subject
	union
	-- b = Number of exposed non-cases: female students who took math classes and passed
	select	2,count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM >= @start and CURRENTTERM <= @end
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) > 0
			and SHRTCKN_SUBJ_CODE = @subject
	union
	-- c = Number of unexposed cases: Students who never took a math class and do not have 4000 courses 
	select	3,count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM >= @start and CURRENTTERM <= @end
			and cast(CT_SUBJECT as integer) < 2000
			and IDENTIFIER in (select  identifier from OIR where SHRTCKN_SUBJ_CODE <> @subject  group by identifier)
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) = 0
	union
	-- d = Number of unexposed non-cases: Students who never took a math class and have 4000 courses 
	select	4,count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM >= @start and CURRENTTERM <= @end
			and cast(CT_SUBJECT as integer) < 2000
			and IDENTIFIER in (select  identifier from OIR where SHRTCKN_SUBJ_CODE <> @subject  group by identifier)
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) > 0

END
GO
