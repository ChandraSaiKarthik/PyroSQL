CREATE OR ALTER FUNCTION [string].[SplitDelimited] (
    @pString varchar(max),
    @pDelimiter varchar(500)
)
returns table
WITH SCHEMABINDING
as
return
with
a1 as (select 1 as N union all
       select 1 union all
       select 1 union all
       select 1 union all
       select 1 union all
       select 1 union all
       select 1 union all
       select 1 union all
       select 1 union all
       select 1),
a2 as (select
            1 as N
       from
            a1 as a
            cross join a1 as b),
a3 as (select
            1 as N
       from
            a2 as a
            cross join a2 as b),
a4 as (select
            1 as N
       from
            a3 as a
            cross join a2 as b),
Tally as (select top (DATALENGTH(@pString))
            row_number() over (order by N) as N
          from
            a4),
ItemSplit(
    ItemOrder,
    Item
) as (
SELECT
    N,
    SUBSTRING(@pDelimiter + @pString + @pDelimiter,N + DATALENGTH(@pDelimiter),CHARINDEX(@pDelimiter,@pDelimiter + @pString + @pDelimiter,N + DATALENGTH(@pDelimiter)) - N - DATALENGTH(@pDelimiter))
FROM
    Tally
WHERE
    N < DATALENGTH(@pDelimiter + @pString + @pDelimiter)
    AND SUBSTRING(@pDelimiter + @pString + @pDelimiter,N,DATALENGTH(@pDelimiter)) = @pDelimiter --Notice how we find the delimiter
)
select
    row_number() over (order by ItemOrder) as ItemID,
    Item
from
    ItemSplit
GO

