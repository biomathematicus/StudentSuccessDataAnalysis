USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spDemographics]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Retrieve demographic information 
-- Example:		exec spDemographics '%', '%', 2009.66, 2019.33
-- =============================================
CREATE PROCEDURE [dbo].[spDemographics] 
	@college varchar(50), @department varchar(50), @start float, @end float 

AS
BEGIN

	select		ETHNICITY, FIRSTGRADCOLLEGE, FIRSTGRADDEPT, 
				count(distinct IDENTIFIER), 1
	from		OIR O --join DEPT D on D.[SUBJECT]= O.[SHRTCKN_SUBJ_CODE]
	where		--D.COLLEGE <> 'NA' 
				CURRENTTERM >= @start 
				and CURRENTTERM <= @end
				and FIRSTGRADCOLLEGE like  @college
				and FIRSTGRADDEPT like @department
				and FIRSTGRADDATE is not null
	group by	ETHNICITY, FIRSTGRADCOLLEGE, FIRSTGRADDEPT
	union
	select		ETHNICITY, COLLEGE, DEPARTMENT, 
				count(distinct IDENTIFIER), 2
	from		OIR O1  
	where		CURRENTTERM >= @start 
				and CURRENTTERM <= @end
				and COLLEGE like  @college
				and DEPARTMENT like @department
				--and FIRSTGRADDATE is not null
				and CURRENTTERM in 
					(
						select	top 1 CURRENTTERM 
						from	OIR O2 
						where	O1.IDENTIFIER = O2.IDENTIFIER
						order by CURRENTTERM asc
					)
	group by	ETHNICITY, COLLEGE, DEPARTMENT
	order by	ETHNICITY
END
GO
