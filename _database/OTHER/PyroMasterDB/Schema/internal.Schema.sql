IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'internal')
EXEC sys.sp_executesql N'CREATE SCHEMA [internal]'
GO
