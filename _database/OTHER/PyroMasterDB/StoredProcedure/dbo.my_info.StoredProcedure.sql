SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[my_info]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[my_info] AS' 
END
GO
	  
/*------------------------------------------------------------------------------------------------
-- BETL, meta data driven ETL generation, licensed under GNU GPL https://github.com/basvdberg/BETL 
--------------------------------------------------------------------------------------------------
-- 2012-03-02 BvdB this proc prints out all user bound properties / settings 
exec [dbo].[my_info]
*/
ALTER   PROCEDURE [dbo].[my_info]
	@transfer_id as int=-1
AS
BEGIN
	-- standard BETL header code... 
	set nocount on 
	declare  
		@nesting as smallint
		, @proc_name as varchar(255) =  object_name(@@PROCID);
	exec dbo.log @transfer_id, 'header', '? ', @proc_name 
	-- END standard BETL header code... 

	declare @output as varchar(max) = ''-- '-- Properties for '+ suser_sname() + ': 
	--exec dbo.log @transfer_id, 'INFO', 'Properties for ? : ', suser_sname() 

	set @nesting = @@NESTLEVEL
	if @nesting > 2 set @nesting+=-2 else set @nesting=0 -- nesting always starts at 2  ( because there is always one calling proc that calls the log proc). 

--	exec dbo.getp 'nesting' , @nesting output
	select @output += replicate('  ', @nesting)+'-- ' +  isnull(property,'?') + ' = ' + isnull(value, '?') + '
'
	from dbo.Prop_ext
--	cross apply dbo.log 'footer', 'DONE ? ', @proc_name 
	where [full_obj_name] = suser_sname() 
	print @output 
    footer:
	exec dbo.log @transfer_id, 'footer', 'DONE ? ', @proc_name 
END











GO
