/*============================
sp_BlitzTrace
==============================*/

--Start Trace
--Drops and recreates existing traces
--Trace files need to be manually cleaned up
exec sp_BlitzTrace @SessionId=@@spid, @action='start', @TargetPath='C:\Xevents\Traces\'

select name,state_desc
from sys.databases

--Read Trace
exec dbo.sp_BlitzTrace @Action='read'

--Stop Trace
exec dbo.sp_BlitzTrace @Action='stop'

--drop Trace
exec dbo.sp_BlitzTrace @Action='drop'


/*==========================
Sp_Blitz common example
===========================*/

EXEC [master].[dbo].[sp_Blitz]
    @CheckUserDatabaseObjects = 1 ,
    @CheckProcedureCache = 0 ,
    @OutputType = 'TABLE' ,
    @OutputProcedureCache = 0 ,
    @CheckProcedureCacheFilter = NULL,
    @CheckServerInfo = 1

