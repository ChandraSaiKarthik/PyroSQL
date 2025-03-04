SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[kevro].[LoadProcedure]') AND type in (N'U'))
BEGIN
CREATE TABLE [kevro].[LoadProcedure](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProcedureName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedurePhase] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureLoadType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureDefinition] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureRemoveLogging] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
