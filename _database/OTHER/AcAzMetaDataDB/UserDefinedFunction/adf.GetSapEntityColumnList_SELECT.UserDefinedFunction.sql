SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[adf].[GetSapEntityColumnList_SELECT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*
	Created By: Emile Fraser
	Date: 2020-09-26
	Description: Gets a select statement for the column list in SAP

	Test1: SELECT [adf].[GetSapEntityColumnList_SELECT]( ''T000'', ''E'')

*/
CREATE            FUNCTION [adf].[GetSapEntityColumnList_SELECT] (
    @SapEntityName				SYSNAME
,	@LanguageCode				NVARCHAR(3) = ''E''
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE 
		@ColumnList			NVARCHAR(MAX) = ''''
	,	@LastColumnPosition	INT	 = 0
	,	@sql_crlf			NVARCHAR(2) = CHAR(13) + CHAR(10)
	,	@sql_tab			NVARCHAR(1) = CHAR(9)
	,	@source_technologytype NVARCHAR(128) = ''ABAP''
	,	@target_technologytype NVARCHAR(128) = ''MSSQL''

	SET  @LastColumnPosition = (
		SELECT 
			MAX(CONVERT(INT, POSITION)) 
		FROM  
			dm.SapFields 
		WHERE
			TABNAME = @SapEntityName
		AND	
			SUBSTRING(FieldName, 1,1) != ''.''
	)

	SELECT @ColumnList += 
		QUOTENAME(FIELDNAME) + IIF(@LastColumnPosition != CONVERT(INT, POSITION), '', '' + @sql_crlf, '''')
	FROM 
		dm.SapFields
	WHERE
		TABNAME = @SapEntityName
	AND
		SUBSTRING(FieldName, 1,1) != ''.''
	ORDER BY 
		CONVERT(INT, POSITION)

	RETURN @ColumnList

END

' 
END
GO
