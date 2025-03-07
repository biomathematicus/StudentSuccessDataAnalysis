USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spStudentDemographics]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Student demographics
-- Example:		exec spStudentDemographics 'new', 2018.66,2019.33
-- =============================================
CREATE PROCEDURE [dbo].[spStudentDemographics] 
	@StudType varchar(15),
	@Start float,
	@End float
--select distinct SHRTCKN_REPEAT_COURSE_IND from oir  --exec spStudentDemographics 'new', 2018.66,2019.33
AS
BEGIN
	select	--[IDENTIFIER],
			case [GENDER]						
				when 'Female' then 1 
				--when 'Not First Generation' then 0 
				else 0 
			end as GEND,
			case [FIRSTGENERATIONSTATUS]						
				when 'First Generation' then 1 
				--when 'Not First Generation' then 0 
				else 0 
			end as FIRSTGEN,
			case [ETHNICITY]								
				when 'Hispanic or Latino' then 1
				--when 'American Indian or Alaskan Native' then 2
				--when 'Black or African-American' then 3
				--when 'White' then 4
				--when 'Native Hawaiian or Other Pacific Islander' then 5
				--when 'Asian' then 6
				else 0
			end AS ETH,
			case [PELLSTATUS]
				when 'Pell Paid' then 1
				--when 'No Pell' then 0
				else 0
			end AS PELL,
			count(distinct [DEPARTMENT]) as [DEPARTMENTS],	
			SAT_COMPOSITE_CONVERTED,
			SAT_MATH_CONVERTED,
			SAT_WCR_CONVERTED,
			case when AGI='No FAFSA' then 0 else CAST(AGI as float) end,
			cast([ZIPCODE] as integer),
			--ACT_COMPOSITE,
			--ACT_MATH,
			--ACT_COMPOSITE_CONVERTED, 
			--ACT_MATH_CONVERTED, 
			--HIGHEST_SATACT_COMPOSITE, 
			--HIGHEST_SATACT_MATH,
			--(select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.IDENTIFIER=O1.IDENTIFIER) as GPA, 
			case 
				--when (select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]='MAT' and cast([CT_SUBJECT] as float)<2000)  < 1.67 then 1
				when (select count(*) from OIR O2 where O2.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]='MAT' and cast([CT_SUBJECT] as float)<2000 and [SHRGRDE_QUALITY_POINTS] < 1.67) > 0   then 1
				--when (select count(SHRTCKN_REPEAT_COURSE_IND) from OIR O2 where O2.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]='MAT' and cast([CT_SUBJECT] as float)<2000 and SHRTCKN_REPEAT_COURSE_IND is not null)  > 0 then 1
				--when (select count(identifier) from oir o2 where o1.identifier=o2.identifier and cast(CT_SUBJECT as integer) > 4000) = 0 then 1
				else 0
			end
			as FAIL
			--(select top 1 DEPARTMENT from OIR O3 where O3.IDENTIFIER = O1.IDENTIFIER order by [CURRENTTERM] asc) as FIRSTMAJOR,
			--(select top 1 DEPARTMENT from OIR O4 where O4.IDENTIFIER = O1.IDENTIFIER order by [CURRENTTERM] desc) as LASTMAJOR
	from	OIR O1
	where	STUDENTTYPE = @StudType 
			and  SAT_COMPOSITE_CONVERTED is not null
			and SAT_MATH_CONVERTED is not null
			and SAT_WCR_CONVERTED is not null
			and SHRTCKN_SUBJ_CODE = 'MAT'
			and cast(CT_SUBJECT as integer) < 2000
			and CURRENTTERM >=@Start 
			and CURRENTTERM <=@End
			and isnumeric(ZIPCODE)=1
	group by [IDENTIFIER], [GENDER], [FIRSTGENERATIONSTATUS], [ETHNICITY], [PELLSTATUS],		
			--SAT_COMPOSITE,	
			--SAT_MATH, 
			SAT_COMPOSITE_CONVERTED,
			SAT_MATH_CONVERTED,
			SAT_WCR_CONVERTED,
			AGI,
			[ZIPCODE]
			--ACT_COMPOSITE,
			--ACT_MATH,
			--ACT_COMPOSITE_CONVERTED, 
			--ACT_MATH_CONVERTED, 
			--HIGHEST_SATACT_COMPOSITE, 
			--HIGHEST_SATACT_MATH			
	order by [DEPARTMENTS] desc
			
END
GO
