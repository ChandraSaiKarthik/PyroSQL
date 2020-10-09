SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [SQLCop].[test Login Language]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Declare @DefaultLanguage VarChar(100)  
    
	Set @Output = ''
    
    Select  @DefaultLanguage = L.Name
    From    master.dbo.sysconfigures C
            Inner Join master.dbo.syslanguages L
              On C.Value = L.LangId
              And C.Comment = 'default Language'

    Select  @Output = @Output + Name + Char(13) + Char(10)
    From    master..syslogins
    Where   Language <> @DefaultLanguage
    Order By Name
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Login-language'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End  
END;
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Max degree of parallelism]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Max degree of parallelism]

GO
