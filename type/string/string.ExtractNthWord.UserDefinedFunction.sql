CREATE OR ALTER FUNCTION string.ExtractNthWord (	
@ExpressionToSearch nvarchar(max), 
							@ExpressionToFind nvarchar(255) = ',', 
							@Occurrence INT, 
							@DoubleQuotesOn BIT = 0)
RETURNS nvarchar(max)
AS
BEGIN

	-- Declare variables and place-holders
	DECLARE @vFound INT = @Occurrence
	DECLARE @vWord nvarchar(max) = @ExpressionToSearch
	DECLARE @vEnd int
	--
	DECLARE @vResult nvarchar(max)

	-- Start an infinite loop that will only end when the Nth word is found
	WHILE 1=1
	BEGIN
		-- Loop break (1)
		IF @vFound = 1
		BEGIN
			SET @vEnd = dbo.CharIndexWithQuotes(@vWord, @ExpressionToFind, @DoubleQuotesOn)
			IF @vEnd IS NULL or @vEnd = 0
			BEGIN
				SET @vEnd = LEN(@vWord)
			END
			BREAK;
		END
		
		-- Loop break (2)
		-- If the selected word is beyond the number of words, NULL is returned
		IF Coalesce(dbo.CharIndexWithQuotes(@vWord, @ExpressionToFind, @DoubleQuotesOn),0) = 0
		BEGIN
			SET @vWord = NULL;
			BREAK;
		END

		-- Eliminate characters from @ExpressionToSearch
		-- Each iteration of the loop will remove the first word fromt the left
		SET @vWord = RIGHT(@vWord, LEN(@vWord) - dbo.CharIndexWithQuotes(@vWord, @ExpressionToFind, @DoubleQuotesOn));
		SET @vFound = @vFound - 1
	END
	
	SET @vResult = LEFT(@vWord,@vEnd - (CASE WHEN @vEnd = LEN(@vWord) THEN 0 ELSE 1 END))
	IF LEFT(@vResult,1) = '"'
		SET @vResult = RIGHT(@vResult, LEN(@vResult)-1)
	IF RIGHT(@vResult,1) = '"'
		SET @vResult = LEFT(@vResult, LEN(@vResult)-1)
	IF RIGHT(@vResult,1) = @ExpressionToFind
		SET @vResult = LEFT(@vResult, LEN(@vResult)-1)

	RETURN @vResult;
END
