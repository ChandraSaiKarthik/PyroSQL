SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[adf].[GetTimeStringFromTimeStringValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

/*
	Created By		: Emile Fraser
	Date			: 2020-10-22
	Decription		: Gets a time representation of a given time

	Test1: SELECT [adf].[GetTimeStringFromTimeStringValue]  (''212022'')
*/
CREATE     FUNCTION [adf].[GetTimeStringFromTimeStringValue] (
	@TimeString NVARCHAR(6)
)
RETURNS  NVARCHAR(8)
BEGIN

	RETURN (
			TRY_CONVERT(
				VARCHAR(8)
			,	STUFF(
					STUFF(
						@TimeString, 3, 0, '':''
					), 6, 0, '':''
				), 8
			) 
	)


END;

' 
END
GO
