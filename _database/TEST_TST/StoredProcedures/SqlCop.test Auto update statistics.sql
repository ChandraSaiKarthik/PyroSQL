SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [SQLCop].[test Auto update statistics]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''
	
    Select @Output = @Output + 'Database not set to Auto Update Statistics' + Char(13) + Char(10)
    Where  DatabaseProperty(db_name(), 'IsAutoUpdateStatistics') = 0
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Auto-update-statistics'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Buffer cache hit ratio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Buffer cache hit ratio]

GO
