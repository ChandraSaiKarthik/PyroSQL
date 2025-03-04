CREATE OR ALTER  FUNCTION [string].[SplitStringByDelimiter] (
	@StringValue	NVARCHAR(MAX)
,   @Delimiter		NVARCHAR(30)
,	@ChunkNumber	SMALLINT		= NULL
)
RETURNS TABLE
WITH SCHEMABINDING AS



	 WITH E1(N) AS ( 
		SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 
		UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 
		UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
	), E2(N) AS (
		SELECT 1 FROM E1 a, E1 b
	), E4(N) AS (
		SELECT 1 FROM E2 a, E2 b
	), E8(N) AS (
		SELECT 1 FROM E4 a, E2 b
	), cteTally(N) AS (
		SELECT 0 
			UNION ALL 
		SELECT 
			TOP (DATALENGTH(ISNULL(@StringValue,1))) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E8
	),	cteStart(ChunkStart, ChunkNumber) AS (
				SELECT 
					t.N + 1
				,	ROW_NUMBER() OVER (ORDER BY t.N +1 )
				FROM 
					cteTally t
                WHERE 
					SUBSTRING(@StringValue, t.N, 1) = @Delimiter 
				OR 
					t.N = 0
	), cteFinal(ChunkStart, ChunkNumber, ChunkNumber_Max) AS (
		SELECT 
			cte.ChunkStart
		,	cte.ChunkNumber
		,	ctm.ChunkNumber_Max
		FROM cteStart AS cte
		CROSS JOIN (
			SELECT MAX(ChunkNumber) AS ChunkNumber_Max FROM cteStart
		) AS ctm
	)
	SELECT
		Item = SUBSTRING(@StringValue, f.ChunkStart, ISNULL(NULLIF(CHARINDEX(@Delimiter, @StringValue, f.ChunkStart), 0) - f.ChunkStart, 8000))
	FROM 
		cteFinal f
	WHERE
		f.ChunkNumber BETWEEN COALESCE(IIF(@ChunkNumber <= 0, f.ChunkNumber_Max + @ChunkNumber, @ChunkNumber), 0) AND COALESCE(IIF(@ChunkNumber <= 0, f.ChunkNumber_Max, @ChunkNumber), 9999)
																