USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spDonorAcceptor]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	Donor and acceptor majors
-- Example:		exec spDonorAcceptor 'MAT', 2014.66,2019.33
-- =============================================
CREATE PROCEDURE [dbo].[spDonorAcceptor] 
	@subject varchar(6),
	@start float,
	@end float


AS
BEGIN
	select	distinct identifier, 
			(select top 1 DEPARTMENT from OIR O3 where O3.IDENTIFIER = O1.IDENTIFIER order by [CURRENTTERM] asc) as FIRSTMAJOR,
			(select top 1 DEPARTMENT from OIR O4 where O4.IDENTIFIER = O1.IDENTIFIER order by [CURRENTTERM] desc) as LASTMAJOR,
			(select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]=@subject) as SUBJECTGPA, 
			(select avg([SHRGRDE_QUALITY_POINTS]) from OIR O5 where O5.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]<>@subject) as NONSUBJECTGPA
	from	OIR O1
	where	(select top 1 DEPARTMENT from OIR O3 where O3.IDENTIFIER = O1.IDENTIFIER order by [CURRENTTERM] asc) 
			<> 
			(select top 1 DEPARTMENT from OIR O4 where O4.IDENTIFIER = O1.IDENTIFIER order by [CURRENTTERM] desc)
			and (select avg([SHRGRDE_QUALITY_POINTS]) from OIR O2 where O2.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]=@subject) is not null 
			and (select avg([SHRGRDE_QUALITY_POINTS]) from OIR O5 where O5.IDENTIFIER=O1.IDENTIFIER and [SHRTCKN_SUBJ_CODE]<>@subject) is not null
			and CURRENTTERM >= @start 
			and CURRENTTERM <= @end

END
GO
