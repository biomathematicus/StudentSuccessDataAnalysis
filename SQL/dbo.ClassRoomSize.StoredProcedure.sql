USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[ClassRoomSize]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Compute GPA by classroom size
-- Example:		exec ClassroomSize 2014.66, 2019.33 
-- =============================================
CREATE PROCEDURE [dbo].[ClassRoomSize] 
	@start float,
	@end float

AS
BEGIN

	select		[CURRENTTERM], [SHRTCKN_SUBJ_CODE], [CT_SUBJECT], [SHRTCKN_SEQ_NUMB], 
				count(distinct IDENTIFIER) as STUDENTS, avg([SHRGRDE_QUALITY_POINTS])  as GPA
	from oir 
	where		[CURRENTTERM] >= @start 
				and [CURRENTTERM] <= @end 
	group by	[CURRENTTERM],[SHRTCKN_SUBJ_CODE],[CT_SUBJECT],[SHRTCKN_SEQ_NUMB]
	having		count(distinct IDENTIFIER) > 10
	order by	[CURRENTTERM],[SHRTCKN_SUBJ_CODE],[CT_SUBJECT],[SHRTCKN_SEQ_NUMB]

END
GO
