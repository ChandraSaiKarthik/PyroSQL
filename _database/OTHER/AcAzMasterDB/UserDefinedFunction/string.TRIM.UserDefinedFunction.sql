SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[string].[TRIM]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [string].[TRIM](
			@string VARCHAR)
	    RETURNS VARCHAR
			AS
			BEGIN
		    RETURN (LTRIM(RTRIM(@string)));
	    END;
' 
END
GO
