USE [UTSA]
GO
/****** Object:  StoredProcedure [dbo].[spSurvivorCurve]    Script Date: 2/27/2024 12:31:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Juan B. Gutiérrez
-- Create date: 9/2019
-- Description:	DFW by faculty
-- Example:		exec spSurvivorCurve 2014.66,2019.66,'MAT','1214','%'
-- Paremeters:	fStart, fEnd sSubjectCode sInstructor sCourseNumber sGrades 
-- =============================================
alter PROCEDURE [dbo].[spSurvivorCurve] 
    @StartYear float,
    @End float,
    @SubjectCode varchar(10),
    @CourseNumber varchar(10),
    @Instructor varchar(50)
AS
BEGIN

declare @NumStud float

-- Calculate the total number of students for the given start term
SELECT @NumStud = COUNT(*) 
FROM OIR AS o 
WHERE o.[CURRENTTERM] = @StartYear 
    AND o.[SHRTCKN_SUBJ_CODE] LIKE @SubjectCode 
    AND o.[CT_SUBJECT] LIKE @CourseNumber 
    AND o.[INSTRUCTORNAME] LIKE @Instructor
	and o.[SHRTCKG_GRDE_CODE_FINAL] is not null
    AND o.CAP = 0;

-- Adjusted SQL to handle NULL values and ensure proper grouping
SELECT 
    CASE 
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('A', 'A-', 'A+', 'B', 'B+', 'B-') THEN 'AB'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('C', 'C-', 'C+') THEN 'C'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('D', 'D+', 'D-', 'F', 'IN', 'NC', 'NR', 'W') THEN 'DFW'
    END AS Grade,
    CASE 
        WHEN o.firstgraddate IS NULL THEN NULL
        ELSE ABS(YEAR(o.firstgraddate) - FLOOR(@StartYear))
    END AS Years2Grad,
    COUNT(*) AS NumGrads, 
    FLOOR(COUNT(*) / @NumStud * 10000) / 100 AS Percentage
FROM 
    [dbo].[OIR] o
WHERE 
    o.[CURRENTTERM] = @StartYear
    AND o.[SHRTCKN_SUBJ_CODE] LIKE @SubjectCode
    AND o.[CT_SUBJECT] LIKE @CourseNumber
    AND o.[INSTRUCTORNAME] LIKE @Instructor
	and o.[SHRTCKG_GRDE_CODE_FINAL] is not null
    AND o.CAP = 0
GROUP BY 
    CASE 
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('A', 'A-', 'A+', 'B', 'B+', 'B-') THEN 'AB'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('C', 'C-', 'C+') THEN 'C'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('D', 'D+', 'D-', 'F', 'IN', 'NC', 'NR', 'W') THEN 'DFW'
    END,
    CASE 
        WHEN o.firstgraddate IS NULL THEN NULL
        ELSE ABS(YEAR(o.firstgraddate) - FLOOR(@StartYear))
    END
ORDER BY Grade, Years2Grad;

END
 /*
 
USE utsa;

DECLARE 
    @NumStud FLOAT, 
    @StartYear FLOAT,
    @EndYear FLOAT,
    @SubjectCode VARCHAR(10),
    @Instructor VARCHAR(50), 
    @CourseNumber VARCHAR(10);

SET @StartYear = 2014.66;
SET @EndYear = 2019.66;
SET @SubjectCode = 'MAT';
SET @CourseNumber = '1073';
SET @Instructor = '%';

-- Calculate the total number of students for the given start term
SELECT @NumStud = COUNT(*) 
FROM OIR AS o 
WHERE o.[CURRENTTERM] = @StartYear 
    AND o.[SHRTCKN_SUBJ_CODE] LIKE @SubjectCode 
    AND o.[CT_SUBJECT] LIKE @CourseNumber 
    AND o.[INSTRUCTORNAME] LIKE @Instructor
	and o.[SHRTCKG_GRDE_CODE_FINAL] is not null
    AND o.CAP = 0;

-- Adjusted SQL to handle NULL values and ensure proper grouping
SELECT 
    CASE 
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('A', 'A-', 'A+', 'B', 'B+', 'B-') THEN 'AB'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('C', 'C-', 'C+') THEN 'C'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('D', 'D+', 'D-', 'F', 'IN', 'NC', 'NR', 'W') THEN 'DFW'
    END AS Grade,
    CASE 
        WHEN o.firstgraddate IS NULL THEN NULL
        ELSE ABS(YEAR(o.firstgraddate) - FLOOR(@StartYear))
    END AS Years2Grad,
    COUNT(*) AS NumGrads, 
    FLOOR(COUNT(*) / @NumStud * 10000) / 100 AS Percentage
FROM 
    [dbo].[OIR] o
WHERE 
    o.[CURRENTTERM] = @StartYear
    AND o.[SHRTCKN_SUBJ_CODE] LIKE @SubjectCode
    AND o.[CT_SUBJECT] LIKE @CourseNumber
    AND o.[INSTRUCTORNAME] LIKE @Instructor
	and o.[SHRTCKG_GRDE_CODE_FINAL] is not null
    AND o.CAP = 0
GROUP BY 
    CASE 
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('A', 'A-', 'A+', 'B', 'B+', 'B-') THEN 'AB'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('C', 'C-', 'C+') THEN 'C'
        WHEN o.[SHRTCKG_GRDE_CODE_FINAL] IN ('D', 'D+', 'D-', 'F', 'IN', 'NC', 'NR', 'W') THEN 'DFW'
    END,
    CASE 
        WHEN o.firstgraddate IS NULL THEN NULL
        ELSE ABS(YEAR(o.firstgraddate) - FLOOR(@StartYear))
    END
ORDER BY Grade, Years2Grad;



 */

 select count(*) from OIR 