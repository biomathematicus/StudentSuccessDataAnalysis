USE [UTSA]
GO
/****** Object:  Table [dbo].[DEPT]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEPT](
	[SUBJECT] [varchar](4) NOT NULL,
	[COLLEGE] [varchar](50) NOT NULL,
	[DEPARTMENT] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
