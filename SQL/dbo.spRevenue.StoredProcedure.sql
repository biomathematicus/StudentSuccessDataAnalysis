USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spRevenue]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 1/2020
-- Description:	Calculation of credit hours by college of instruction and college of record
-- Example: exec spRevenue 'Sciences', 'Mathematics'
-- =============================================
CREATE PROCEDURE [dbo].[spRevenue] 
	@College varchar(100), 
	@Department varchar(100)
AS
BEGIN
	-- Total credit hours
	select y.SHRTCKN_SUBJ_CODE + y.CT_SUBJECT,  1 as GroupID, 
			(case when [2014.66] is null then 0 else [2014.66] end) 
			+ (case when [2015] is null then 0 else [2015] end) 
			+ (case when [2015.33] is null then 0 else [2015.33] end) 
			as Y14_15,
			(case when [2015.66] is null then 0 else [2015.66] end) 
			+ (case when [2016] is null then 0 else [2016] end) 
			+ (case when [2016.33] is null then 0 else [2016.33] end) 
			as Y15_16,
			(case when [2016.66] is null then 0 else [2016.66] end) 
			+ (case when [2017] is null then 0 else [2017] end) 
			+ (case when [2017.33] is null then 0 else [2017.33] end) 
			as Y16_17,
			(case when [2017.66] is null then 0 else [2017.66] end) 
			+ (case when [2018] is null then 0 else [2018] end) 
			+ (case when [2018.33] is null then 0 else [2018.33] end) 
			as Y17_18,
			(case when [2018.66] is null then 0 else [2018.66] end) 
			+ (case when [2019] is null then 0 else [2019] end) 
			+ (case when [2019.33] is null then 0 else [2019.33] end) 
			as Y18_19			
	from 
	(
		SELECT	O.SHRTCKN_SUBJ_CODE, O.CT_SUBJECT, O.CURRENTTERM, O.SHRTCKG_CREDIT_HOURS
		FROM	OIR O --JOIN [WEIGHT] W on O.CT_SUBJECT = W.CODE 	
		where	O.SHRTCKN_SUBJ_CODE in 
				(select [SUBJECT] from  [DEPT]  where [DEPARTMENT] = @Department)
	) as x
	pivot 
	(
		SUM([SHRTCKG_CREDIT_HOURS]) 
		for CURRENTTERM in ([2014.66], [2015], [2015.33], [2015.66], [2016], [2016.33], [2016.66], [2017], [2017.33], [2017.66], [2018], [2018.33], [2018.66], [2019], [2019.33]) 
	) as y
	where	(
				case when [2018.66] is null then 0 else [2018.66] end) 
				+ (case when [2019] is null then 0 else [2019] end) 
				+ (case when [2019.33] is null then 0 else [2019.33] end
			) > 0
	-- College of record credit hours
	union 
	select y.SHRTCKN_SUBJ_CODE + y.CT_SUBJECT,  2  as GroupID, 
			(case when [2014.66] is null then 0 else [2014.66] end) 
			+ (case when [2015] is null then 0 else [2015] end) 
			+ (case when [2015.33] is null then 0 else [2015.33] end) 
			as Y14_15,
			(case when [2015.66] is null then 0 else [2015.66] end) 
			+ (case when [2016] is null then 0 else [2016] end) 
			+ (case when [2016.33] is null then 0 else [2016.33] end) 
			as Y15_16,
			(case when [2016.66] is null then 0 else [2016.66] end) 
			+ (case when [2017] is null then 0 else [2017] end) 
			+ (case when [2017.33] is null then 0 else [2017.33] end) 
			as Y16_17,
			(case when [2017.66] is null then 0 else [2017.66] end) 
			+ (case when [2018] is null then 0 else [2018] end) 
			+ (case when [2018.33] is null then 0 else [2018.33] end) 
			as Y17_18,
			(case when [2018.66] is null then 0 else [2018.66] end) 
			+ (case when [2019] is null then 0 else [2019] end) 
			+ (case when [2019.33] is null then 0 else [2019.33] end) 
			as Y18_19			
	from 
	(
		SELECT	O.SHRTCKN_SUBJ_CODE, O.CT_SUBJECT, O.CURRENTTERM, O.SHRTCKG_CREDIT_HOURS
		FROM	OIR O --outer JOIN (select distinct SHRTCKN_SUBJ_CODE, CT_SUBJECT from OIR O0) O1 on O.CT_SUBJECT = W.CODE 	
		where	O.SHRTCKN_SUBJ_CODE in 
				(select [SUBJECT] from  [DEPT]  where [DEPARTMENT] = @Department)
				and O.COLLEGE = @College  -- College of record
	) as x
	pivot 
	(
		SUM([SHRTCKG_CREDIT_HOURS]) 
		for CURRENTTERM in ([2014.66], [2015], [2015.33], [2015.66], [2016], [2016.33], [2016.66], [2017], [2017.33], [2017.66], [2018], [2018.33], [2018.66], [2019], [2019.33]) 
	) as y
	where	(
				case when [2018.66] is null then 0 else [2018.66] end) 
				+ (case when [2019] is null then 0 else [2019] end) 
				+ (case when [2019.33] is null then 0 else [2019.33] end
			) > 0
	-- College of instruction credit hours
	union 
	select y.SHRTCKN_SUBJ_CODE + y.CT_SUBJECT,  3  as GroupID, 
			(case when [2014.66] is null then 0 else [2014.66] end) 
			+ (case when [2015] is null then 0 else [2015] end) 
			+ (case when [2015.33] is null then 0 else [2015.33] end) 
			as Y14_15,
			(case when [2015.66] is null then 0 else [2015.66] end) 
			+ (case when [2016] is null then 0 else [2016] end) 
			+ (case when [2016.33] is null then 0 else [2016.33] end) 
			as Y15_16,
			(case when [2016.66] is null then 0 else [2016.66] end) 
			+ (case when [2017] is null then 0 else [2017] end) 
			+ (case when [2017.33] is null then 0 else [2017.33] end) 
			as Y16_17,
			(case when [2017.66] is null then 0 else [2017.66] end) 
			+ (case when [2018] is null then 0 else [2018] end) 
			+ (case when [2018.33] is null then 0 else [2018.33] end) 
			as Y17_18,
			(case when [2018.66] is null then 0 else [2018.66] end) 
			+ (case when [2019] is null then 0 else [2019] end) 
			+ (case when [2019.33] is null then 0 else [2019.33] end) 
			as Y18_19			
	from 
	(
		SELECT	O.SHRTCKN_SUBJ_CODE, O.CT_SUBJECT, O.CURRENTTERM, O.SHRTCKG_CREDIT_HOURS
		FROM	OIR O --JOIN [WEIGHT] W on O.CT_SUBJECT = W.CODE 	
		where	O.SHRTCKN_SUBJ_CODE in 
				(select [SUBJECT] from  [DEPT]  where [DEPARTMENT] = @Department)
				and O.COLLEGE <> @College -- College of instruction
	) as x
	pivot 
	(
		SUM([SHRTCKG_CREDIT_HOURS]) 
		for CURRENTTERM in ([2014.66], [2015], [2015.33], [2015.66], [2016], [2016.33], [2016.66], [2017], [2017.33], [2017.66], [2018], [2018.33], [2018.66], [2019], [2019.33]) 
	) as y
	where	(
				case when [2018.66] is null then 0 else [2018.66] end) 
				+ (case when [2019] is null then 0 else [2019] end) 
				+ (case when [2019.33] is null then 0 else [2019.33] end
			) > 0
	order by GroupID, Y18_19 desc


END
GO
