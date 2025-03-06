USE [UTSA]
GO
/****** Object:  Table [dbo].[WEIGHT]    Script Date: 3/6/2025 2:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WEIGHT](
	[SUBJECT] [varchar](4) NOT NULL,
	[CODE] [varchar](4) NOT NULL,
	[WEIGHT] [float] NOT NULL
) ON [PRIMARY]
GO
