SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[obj_id]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'	  

/*------------------------------------------------------------------------------------------------
-- BETL, meta data driven ETL generation, licensed under GNU GPL https://github.com/basvdberg/BETL 
--------------------------------------------------------------------------------------------------
-- 2017-09-06 BvdB Return meta data id for a full object name
select dbo.obj_id''AdventureWorks2014.Person.Person'', null) --> points to table 
select dbo.obj_id''AdventureWorks2014.Person'', null) --> points to schema
select dbo.obj_id''AdventureWorks2014'', null) --> points to db
select dbo.obj_id(''BETL'', null) --> points to db
select dbo.obj_id''MicrosoftAccount\swjvdberg@outlook.com'', null) --> points to db
select * from dbo.Obj
*/
CREATE   FUNCTION [dbo].[obj_id]( @fullObj_name sysname , @scope varchar(255) = null ) 
RETURNS int
AS
BEGIN
	declare @t TABLE (item VARCHAR(8000), i int)
	declare  
	     @elem1 varchar(255)
	     ,@elem2 varchar(255)
	     ,@elem3 varchar(255)
	     ,@elem4 varchar(255)
		, @cnt_elems int 
		, @obj_id int 
--		, @remove_chars varchar(255)
		, @cnt as int 
	
	insert into @t 
	select replace(replace(item, ''['',''''),'']'','''') item, i 
	from util.split(@fullObj_name , ''.'') 
	--select * from @t 
	-- @t contains elemenents of fullObj_name 
	-- can be [server].[db].[schema].[table|view]
	-- as long as it''s unique 
	select @cnt_elems = MAX(i) from @t	
	select @elem1 = item from @t where i=@cnt_elems
	select @elem2 = item from @t where i=@cnt_elems-1
	select @elem3 = item from @t where i=@cnt_elems-2
	select @elem4 = item from @t where i=@cnt_elems-3
	select @obj_id= max(o.obj_id), @cnt = count(*) 
	from dbo.[Obj] o
	LEFT OUTER JOIN dbo.[Obj] AS parent_o ON o.parent_id = parent_o.[obj_id] 
	LEFT OUTER JOIN dbo.[Obj] AS grand_parent_o ON parent_o.parent_id = grand_parent_o.[obj_id] 
	LEFT OUTER JOIN dbo.[Obj] AS great_grand_parent_o ON grand_parent_o.parent_id = great_grand_parent_o.[obj_id] 
	where 
	(
		o.delete_dt is null 
		and o.obj_type_id<> 60 -- not a user
		and o.[obj_name] = @elem1 
		and ( @elem2 is null or parent_o.[obj_name] = @elem2 ) 
		and ( @elem3 is null or grand_parent_o.[obj_name] = @elem3) 
		and ( @elem4 is null or great_grand_parent_o.[obj_name] = @elem4) 
		and ( @scope is null 
				or @scope = o.scope 
				or @scope = parent_o.scope 
				or @scope = grand_parent_o.scope 
				or @scope = great_grand_parent_o.scope 
				or o.obj_type_id= 50 -- scope not relevant for servers. 
			)  
	) 
	or 
	(
		o.delete_dt is null 
		and o.obj_type_id=60 -- user
		and o.obj_name = @fullObj_name
	) 

	
	declare @res as int
	if @cnt >1 
		set @res =  -@cnt
	else 
		set @res =@obj_id 
	return @res 
END











' 
END
GO
