USE [MetricsVault]
GO
/****** Object:  StoredProcedure [dbo].[sp_handle_EnsambleMetric]    Script Date: 2020/05/26 12:44:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	DECLARE 
		@ServerName			SYSNAME			= 'TSABISQL02\STAGSSIS'
	,	@DatabaseName		SYSNAME			= 'DataVault'
	,	@SchemaName			SYSNAME			= 'RAW'
	,	@ProcedureName		SYSNAME			= 'sp_loadhub_XT_Terminal'

	EXEC [dbo].[sp_handle_EnsambleMetric]
		@ServerName		= @ServerName
	,	@DatabaseName	= @DatabaseName
	,	@SchemaName		= @SchemaName	
	,	@ProcedureName	= @ProcedureName
*/

-- Inserts plain count of rows to Ensambles
ALTER     PROCEDURE [dbo].[sp_handle_EnsambleMetric]
	@ServerName			SYSNAME
,	@DatabaseName		SYSNAME
,	@SchemaName			SYSNAME
,	@ProcedureName		SYSNAME
AS
BEGIN
	DECLARE 
		@sql_statement					NVARCHAR(MAX)
	,	@sql_parameter					NVARCHAR(MAX)
	,	@sql_message					NVARCHAR(MAX)
	,	@sql_crlf						NVARCHAR(2) = CHAR(13) + CHAR(10)
	,	@sql_tab						NVARCHAR(1) = CHAR(9)
	,	@sql_debug						BIT = 0
	,	@sql_execute					BIT = 1

	DECLARE  
		@ElementID						SMALLINT
	,	@EnsambleID						SMALLINT
	,	@EnsambleName					VARCHAR(100)
	,	@EntityType						VARCHAR(30)
	,	@DataEntityName					SYSNAME
	,	@FullyQualifiedEntityName		NVARCHAR(523)   -- (128 * 4) + (2 * 4) + (1 * 3)  -- SYSNAME + BRACKEETS + DOTS

	DECLARE 
		@config_cursor					CURSOR
	,	@metric_typeid					SMALLINT
	,	@scheduleid						SMALLINT
	,	@timegrainid					SMALLINT
	,	@configid						SMALLINT
	,	@metricprocedureName			SYSNAME
	,	@additional_parameters			NVARCHAR(MAX)

	-- Sets the DT of the Current Insert 
	DECLARE @CreatedDT DATETIME2(7) = GETDATE()

	-- Gets the Entity type being loaded by the Procedure
	-- As well as the entity ultimately loaded 
	SET @EntityType			= (SELECT UPPER(REPLACE(Item, 'load','')) FROM  dbo.udf_split_String(@ProcedureName,'_',2))
	SET @EnsambleName		= (SELECT Item FROM dbo.udf_split_String(@ProcedureName,'_',4))
	SET @DataEntityName		= @EntityType + '_' + @EnsambleName

	-- Fully Qualified Name to figure out on what entity to run the test and then what ElementID relates to the FullyQualifiedName
	SET @FullyQualifiedEntityName = CONCAT_WS('.', QUOTENAME(@ServerName), QUOTENAME(@DatabaseName), QUOTENAME(@SchemaName), QUOTENAME(@DataEntityName))
	SET @ElementID = (SELECT ElementID FROM dbo.Ensamble_Element WHERE [ElementFullyQualified] = @FullyQualifiedEntityName)
	
	SELECT @FullyQualifiedEntityName, @SchemaName, @ProcedureName, @EntityType, @EnsambleName, @DataEntityName, @DatabaseName
	SELECT @ElementID
	
	-- Now Get all the Balancing Config Data Which will be entered into a cursor
	SET @config_cursor = CURSOR FOR 
	SELECT 
		ConfigID
	,	MetricTypeID
	FROM 
		[MetricsVault].[dbo].[Ensamble_Config]
	WHERE
		[ElementID] = @ElementID

	OPEN @config_cursor
	
	FETCH NEXT FROM @config_cursor
	INTO @configid, @metric_typeid

	select * from dbo.ensamble_config

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		-- Gets the procedure name to be executed as well as any additional fields we will require
		SELECT 
			@metricprocedureName = 
		FROM 
			dbo.Ensamble_MetricType 
		WHERE 
			MetricTypeID =  @metric_typeid)
		SELECT @metricprocedureName, @configid, @additional_parameters

		FETCH NEXT FROM @config_cursor
		INTO @configid, @metric_typeid
	END

/*

	SET @sql_statement = '
		SELECT 
			@count = COUNT(1)
		FROM ' + @sql_crlf + REPLICATE(@sql_tab, 3) +
			IIF(@ServerName IS NOT NULL, QUOTENAME(@ServerName) + '.', '') + 
			QUOTENAME(@DatabaseName) + '.' +
			QUOTENAME(@SchemaName) + '.' +
			QUOTENAME(@EntityName) + '
		WHERE
			[LoadEndDT] IS NULL'

	SET @sql_parameter = N'@count INT OUTPUT'

	IF(@sql_debug = 1)
		RAISERROR(@sql_statement, 0, 1)

	IF(@sql_execute = 1)
	BEGIN
		EXEC sp_executesql 
			@stmt  = @sql_statement
		,	@param = @sql_parameter
		,	@count = @count OUTPUT
	END

	*/
END
