USE [UTSA]
GO
/****** Object:  Table [dbo].[OIR]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OIR](
	[IDENTIFIER] [varchar](6) NOT NULL,
	[ETHNICITY] [varchar](41) NULL,
	[GENDER] [varchar](6) NULL,
	[FA_APPLIED] [varchar](25) NULL,
	[AGI] [varchar](15) NULL,
	[PELLSTATUS] [varchar](25) NULL,
	[FIRSTGENERATIONSTATUS] [varchar](20) NULL,
	[ZIPCODE] [varchar](20) NULL,
	[STUDENTTYPE] [varchar](8) NULL,
	[CAP] [tinyint] NULL,
	[FIRSTTERMDESC] [varchar](11) NULL,
	[FIRSTTERMCODE] [float] NULL,
	[SAT_COMPOSITE] [float] NULL,
	[SAT_MATH] [float] NULL,
	[SAT_ERW] [float] NULL,
	[SAT_COMPOSITE_OLD] [float] NULL,
	[SAT_MATH_OLD] [float] NULL,
	[SAT_VERBAL_OLD] [float] NULL,
	[SAT_WRITING_OLD] [float] NULL,
	[SATOLD_WCR] [float] NULL,
	[SAT_COMPOSITE_CONVERTED] [float] NULL,
	[SAT_MATH_CONVERTED] [float] NULL,
	[SAT_WCR_CONVERTED] [float] NULL,
	[ACT_COMPOSITE] [float] NULL,
	[ACT_MATH] [float] NULL,
	[ACT_ENG] [float] NULL,
	[ACT_READ] [float] NULL,
	[ACT_ER] [float] NULL,
	[ACT_SCIREAS] [float] NULL,
	[ACT_WRITE] [float] NULL,
	[ACT_COMPOSITE_CONVERTED] [float] NULL,
	[ACT_MATH_CONVERTED] [float] NULL,
	[ACT_ER_CONVERTED] [float] NULL,
	[HIGHEST_SATACT_COMPOSITE] [float] NULL,
	[HIGHEST_SATACT_MATH] [float] NULL,
	[HIGHEST_SATACT_ERW] [float] NULL,
	[HIGHSCHOOLNAME] [varchar](100) NULL,
	[HIGHSCHOOLCITY] [varchar](100) NULL,
	[HIGHSCHOOLSTATE] [varchar](50) NULL,
	[HIGHSCHOOLZIP] [varchar](20) NULL,
	[MAT1073_AP_GRDE] [varchar](2) NULL,
	[MAT1073_DUAL_GRDE] [varchar](2) NULL,
	[MAT1073_CLEP_GRDE] [varchar](2) NULL,
	[MAT1093_AP_GRDE] [varchar](2) NULL,
	[MAT1093_DUAL_GRDE] [varchar](2) NULL,
	[MAT1093_CLEP_GRDE] [varchar](2) NULL,
	[MAT1214_AP_GRDE] [varchar](2) NULL,
	[MAT1214_DUAL_GRDE] [varchar](2) NULL,
	[MAT1214_CLEP_GRDE] [varchar](2) NULL,
	[MAT1224_AP_GRDE] [varchar](2) NULL,
	[MAT1224_DUAL_GRDE] [varchar](2) NULL,
	[MAT1224_CLEP_GRDE] [varchar](2) NULL,
	[CURRENTTERMCODE] [varchar](50) NOT NULL,
	[CURRENTTERM] [float] NULL,
	[PROGRAM] [varchar](100) NULL,
	[COLLEGE] [varchar](50) NULL,
	[DEPARTMENT] [varchar](50) NULL,
	[SHRTCKN_SUBJ_CODE] [varchar](4) NULL,
	[CT_SUBJDESC] [varchar](50) NULL,
	[CT_SUBJECT] [char](4) NULL,
	[SHRTCKN_SEQ_NUMB] [varchar](3) NULL,
	[SHRTCKN_CRN] [int] NOT NULL,
	[SHRTCKN_CRSE_TITLE] [varchar](50) NULL,
	[PRIMARY_INSTRUCTOR_ID] [varchar](9) NULL,
	[INSTRUCTORNAME] [varchar](50) NULL,
	[SHRTCKG_CREDIT_HOURS] [tinyint] NULL,
	[MIDTERM_GRADE] [varchar](3) NULL,
	[SHRTCKG_GRDE_CODE_FINAL] [varchar](2) NULL,
	[SHRGRDE_QUALITY_POINTS] [float] NULL,
	[SHRGRDE_GPA_IND] [char](1) NULL,
	[SHRTCKN_REPEAT_COURSE_IND] [char](1) NULL,
	[STVSCHD_DESC] [varchar](30) NULL,
	[FIRSTGRADDATE] [datetime2](7) NULL,
	[FIRSTGRADPROGRAM] [varchar](75) NULL,
	[FIRSTGRADCOLLEGE] [varchar](40) NULL,
	[FIRSTGRADDEPT] [varchar](50) NULL
) ON [PRIMARY]
GO
