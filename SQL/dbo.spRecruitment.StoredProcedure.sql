USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spRecruitment]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Retrieve colleges, students and credit hour per semester
-- Example:		exec spRecruitment '%', '%', 2009.66, 2019.33
-- =============================================
CREATE PROCEDURE [dbo].[spRecruitment] 
	@college varchar(50), @department varchar(50), @start float, @end float 

AS
BEGIN

	SELECT		floor(CURRENTTERM), COLLEGE, DEPARTMENT, count(distinct IDENTIFIER)
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
					)
	group by	CURRENTTERM, COLLEGE, DEPARTMENT
	order by	CURRENTTERM, COLLEGE, DEPARTMENT

END
GO
