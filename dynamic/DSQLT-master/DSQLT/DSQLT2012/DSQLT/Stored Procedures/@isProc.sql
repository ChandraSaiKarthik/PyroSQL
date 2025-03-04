﻿CREATE PROCEDURE [DSQLT].[@isProc]
@Database [sysname], @Schema [sysname], @Table [sysname], @Print BIT=0
AS
SET NOCOUNT ON
-- um das Ergebnis zwischenzuspeichen
DECLARE @ResultTable TABLE(result int)
-- Ergebnis
DECLARE @Result int
-- Template (unten zwischen BEGIN und END) ausführen und Ergebnis nach @Result
DECLARE @Template varchar(max)
exec DSQLT.[Execute] '@isProc',@Schema,@Table,@Template=@Template OUTPUT, @Print=null
INSERT INTO @ResultTable
	exec DSQLT._execSQL @Database,@Template,@Print
SELECT TOP 1 @Result=result from @ResultTable
RETURN @Result
BEGIN
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[@1].[@2]') AND type in (N'P', N'PC'))
		SELECT 1
	ELSE
		SELECT 0
END
