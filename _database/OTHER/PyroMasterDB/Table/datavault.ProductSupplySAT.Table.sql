SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[datavault].[ProductSupplySAT]') AND type in (N'U'))
BEGIN
CREATE TABLE [datavault].[ProductSupplySAT](
	[ProductVID] [bigint] NOT NULL,
	[LoadDateTime] [datetime] NOT NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ReorderPoint] [int] NOT NULL,
	[SafetyStockLevel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductVID] ASC,
	[LoadDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[datavault].[FK__ProductSu__Produ__2A61254E]') AND parent_object_id = OBJECT_ID(N'[datavault].[ProductSupplySAT]'))
ALTER TABLE [datavault].[ProductSupplySAT]  WITH CHECK ADD FOREIGN KEY([ProductVID])
REFERENCES [datavault].[ProductHUB] ([ProductVID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[datavault].[FK__ProductSu__Produ__338B682C]') AND parent_object_id = OBJECT_ID(N'[datavault].[ProductSupplySAT]'))
ALTER TABLE [datavault].[ProductSupplySAT]  WITH CHECK ADD FOREIGN KEY([ProductVID])
REFERENCES [datavault].[ProductHUB] ([ProductVID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[datavault].[FK__ProductSu__Produ__35F2D38B]') AND parent_object_id = OBJECT_ID(N'[datavault].[ProductSupplySAT]'))
ALTER TABLE [datavault].[ProductSupplySAT]  WITH CHECK ADD FOREIGN KEY([ProductVID])
REFERENCES [datavault].[ProductHUB] ([ProductVID])
GO
