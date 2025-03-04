SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[end_batch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[end_batch] AS' 
END
GO
	  
/*------------------------------------------------------------------------------------------------
-- BETL, meta data driven ETL generation, licensed under GNU GPL https://github.com/basvdberg/BETL 
--------------------------------------------------------------------------------------------------
-- 2012-12-21 BvdB log ending of batch. allow custom code integration with external logging. 
declare @batch_id int 
exec dbo.end_batch @batch_id output 
print @batch_id 
*/
ALTER   PROCEDURE [dbo].[end_batch] 
	@batch_id int output ,
	@status as varchar(255) ,
	@transfer_id as int = null 
as 
begin 
	declare @status_id as int 
		,@nu as datetime = getdatE() 
		,@proc_name as varchar(255) =  object_name(@@PROCID);
	exec dbo.log @transfer_id, 'step', '?(b?,t?) status ?', @proc_name , @batch_id, @transfer_id ,  @status
	if not @batch_id > 0 
		goto footer
	select @status_id =status_id 
	from static.Status 
	where status_name = @status
	update [dbo].[Batch]
	set [status_id] = @status_id , batch_end_dt =@nu
	where batch_id = @batch_id 
	and status_id <> 200 -- never overwrite error batch status
	footer:
end












GO
