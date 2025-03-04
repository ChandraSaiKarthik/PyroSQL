A reliable way to verify T-SQL stored procedures
Solution:
You can choose different ways. First of all SQL SERVER 2008 supports dependencies which exist in DB inclusive dependencies of STORED PROCEDURE (see http://msdn.microsoft.com/en-us/library/bb677214%28v=SQL.100%29.aspx, http://msdn.microsoft.com/en-us/library/ms345449.aspx and http://msdn.microsoft.com/en-us/library/cc879246.aspx). You can use sys.sql_expression_dependencies and sys.dm_sql_referenced_entities to see and verify there.

But the most simple way to do verification of all STORED PROCEDURE is following:

export all STORED PROCEDURE
drop old existing STORED PROCEDURE
import just exported STORED PROCEDURE.
If you upgrade DB the existing Stored Procedure will be not verified, but if you create a new one, the procedure will be verified. So after exporting and exporting of all Stored Procedure you receive all existing error reported.

You can also see and export the code of a Stored Procedure with a code like following

SELECT definition
FROM sys.sql_modules
WHERE object_id = (OBJECT_ID(N'spMyStoredProcedure'))
UPDATED: To see objects (like tables and views) referenced by Stored Procedure spMyStoredProcedure you can use following:

SELECT OBJECT_NAME(referencing_id) AS referencing_entity_name 
    ,referenced_server_name AS server_name
    ,referenced_database_name AS database_name
    ,referenced_schema_name AS schema_name
    , referenced_entity_name
FROM sys.sql_expression_dependencies 
WHERE referencing_id = OBJECT_ID(N'spMyStoredProcedure');
UPDATED 2: In the comment to my answer Martin Smith suggested to use sys.sp_refreshsqlmodule instead of recreating a Stored Procedure. So with the code

SELECT 'EXEC sys.sp_refreshsqlmodule ''' + OBJECT_SCHEMA_NAME(object_id) +
              '.' + name + '''' FROM sys.objects WHERE type in (N'P', N'PC')
one receive a script, which can be used for verifying of Stored Procedure dependencies. The output will look like following (example with AdventureWorks2008):

EXEC sys.sp_refreshsqlmodule 'dbo.uspGetManagerEmployees'
EXEC sys.sp_refreshsqlmodule 'dbo.uspGetWhereUsedProductID'
EXEC sys.sp_refreshsqlmodule 'dbo.uspPrintError'
EXEC sys.sp_refreshsqlmodule 'HumanResources.uspUpdateEmployeeHireInfo'
EXEC sys.sp_refreshsqlmodule 'dbo.uspLogError'
EXEC sys.sp_refreshsqlmodule 'HumanResources.uspUpdateEmployeeLogin'
EXEC sys.sp_refreshsqlmodule 'HumanResources.uspUpdateEmployeePersonalInfo'
EXEC sys.sp_refreshsqlmodule 'dbo.uspSearchCandidateResumes'
EXEC sys.sp_refreshsqlmodule 'dbo.uspGetBillOfMaterials'
EXEC sys.sp_refreshsqlmodule 'dbo.uspGetEmployeeManagers'

Here is what worked for me:

-- Based on comment from http://blogs.msdn.com/b/askjay/archive/2012/07/22/finding-missing-dependencies.aspx
-- Check also http://technet.microsoft.com/en-us/library/bb677315(v=sql.110).aspx

select o.type, o.name, ed.referenced_entity_name, ed.is_caller_dependent
from sys.sql_expression_dependencies ed
join sys.objects o on ed.referencing_id = o.object_id
where ed.referenced_id is null
You should get all missing dependencies for your SPs, solving problems with late binding.

Exception: is_caller_dependent = 1 does not necessarily mean a broken dependency. It just means that the dependency is resolved on runtime because the schema of the referenced object is not specified. You can avoid it specifying the schema of the referenced object (another SP for example).

Credits to Jay's blog and the anonymous commenter...