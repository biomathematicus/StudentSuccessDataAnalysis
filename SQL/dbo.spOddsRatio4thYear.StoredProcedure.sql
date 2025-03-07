USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spOddsRatio4thYear]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Compute parameters for an odds ratio 
--				analysis for 4rth year graduation rate
-- Example:		exec spOddsRatio4thYear 'MAT'
-- =============================================
CREATE PROCEDURE [dbo].[spOddsRatio4thYear] 
		@Subject varchar(5)

AS
BEGIN

	create table #temp (a varchar(7)); insert into #temp select x from (values ('2014.66'),('2015.0'),('2015.33')) temp(x)

	-- a = Number of exposed cases: All students who took math classes and have no 4000 courses
	select	1, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)
			--and cast(CT_SUBJECT as integer) < 2000 -- this condition is to ensure that only freshmen are considered
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) = 0
			and @Subject in (select SHRTCKN_SUBJ_CODE from oir o2 where o1.identifier = o2.IDENTIFIER)
	union
	-- b = Number of exposed non-cases: Students who took math classes and have 4000 courses
	select	2, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)
			--and cast(CT_SUBJECT as integer) < 2000 -- this condition is to ensure that only freshmen are considered
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) > 0
			and @Subject in (select SHRTCKN_SUBJ_CODE from oir o2 where o1.identifier = o2.IDENTIFIER)
	union
	-- c = Number of unexposed cases: Students who never took a math class and do not have 4000 courses 
	select	3, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)
			--and cast(CT_SUBJECT as integer) < 2000 -- this condition is to ensure that only freshmen are considered
			--and IDENTIFIER in (select  identifier from OIR where SHRTCKN_SUBJ_CODE <> @Subject)
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) = 0
			and @Subject not in (select SHRTCKN_SUBJ_CODE from oir o2 where o1.identifier = o2.IDENTIFIER)
	union
	-- d = Number of unexposed non-cases: Students who never took a math class and have 4000 courses 
	select	4, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)
			--and cast(CT_SUBJECT as integer) < 2000 -- this condition is to ensure that only freshmen are considered
			--and IDENTIFIER in (select  identifier from OIR where SHRTCKN_SUBJ_CODE <> @Subject  group by identifier)
			and (select count(distinct identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) > 0
			and @Subject not in (select SHRTCKN_SUBJ_CODE from oir o2 where o1.identifier = o2.IDENTIFIER)
	/*
	union
	-- Case control. Check totals to verify quality of retrieval
	select	5, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)

	union
	select	6, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)
			and @Subject in (select distinct SHRTCKN_SUBJ_CODE from oir o2 where o1.identifier = o2.IDENTIFIER)
	union
	select	7, count(distinct IDENTIFIER) 
	from	oir o1
	where	CURRENTTERM in (select * from #temp)
			and @Subject not in (select distinct SHRTCKN_SUBJ_CODE from oir o2 where o1.identifier = o2.IDENTIFIER)
	*/

END
GO
