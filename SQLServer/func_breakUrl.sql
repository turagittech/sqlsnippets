CREATE Function breakUrl (

 @url VARCHAR(8000), @delimiter char(1))

 returns  @urlStrings table
( 
urlStrId INT,
urlString varchar(300)
)
 BEGIN
-- Slices the url set at the delimter often "/" to create knowldege from the Url

-- Code derived from  https://dba.stackexchange.com/questions/91401/how-to-split-url-in-sql-server-like-this 

WITH E1(N) AS (
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                ),                          --10E+1 or 10 rows
       E2(N) AS (SELECT 1 FROM E1 a, E1 b), --10E+2 or 100 rows
       E4(N) AS (SELECT 1 FROM E2 a, E2 b), --10E+4 or 10,000 rows max
 cteTally(N) AS (
                 SELECT TOP (ISNULL(DATALENGTH(@url),0)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E4
                ),
ctePos(N1) AS (
                 SELECT t.N-1 FROM cteTally t WHERE SUBSTRING(@url,t.N,1) = @delimiter
                 union all 
                 select datalength(@url)
                )
INSERT into @urlStrings select  ROW_NUMBER() OVER(ORDER BY N1) as rowNu, left(@url, N1) + case when ROW_NUMBER() OVER(ORDER BY N1) = 1 then '/' else '' end as URL
from ctePos order by N1 desc

RETURN 
END
