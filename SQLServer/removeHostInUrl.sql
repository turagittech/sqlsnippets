-- Removes the hostname and port if in url up to and including the leading slash from the UrlString
-- using this creates a list of url objects to be broken up  to analyze the URL
-- This might now be easier in other tech to do the additional work

SELECT LEN(urls.urlString) urlLength, urls.urlString  UrlString, STUFF( urls.URL,1, iu.urlLength+1,'' ) as element, urls.URL FROM(
SELECT top 300 URL, segments.urlString urlString, segments.urlStrId urlId  FROM RequestLog
OUTER APPLY(SELECT * FROM [dbo].[breakUrl](URL, '/')) as segments) urls

inner JOIN (SELECT LEN(innerUrl.urlString) urlLength, innerUrl.urlString as urlString, innerUrl.URL, innerUrl.urlStrId as urlStrId  FROM(
SELECT top 300 URL, segments.urlString, segments.urlStrId FROM RequestLog
OUTER APPLY(SELECT * FROM [dbo].[breakUrl](URL, '/')) as segments)innerUrl 
WHERE innerUrl.urlStrId =3 ) iu  on  iu.URL = urls.URL

-- Variation with extra  feature identifies parameters in URL from present of ? The PATINDEX cane be used in STUFF to grab the parameters

SELECT urls.UserId, urls.FeatureId,  LEN(urls.urlString) urlLength, urls.urlString  UrlString, STUFF( urls.URL,1, iu.urlLength+1,'' ) as element, urls.URL, PATINDEX('%?%', urls.urlString) as paraFlag
FROM(
SELECT top 300 URL, segments.urlString urlString, segments.urlStrId urlId, UserId, FeatureId FROM RequestLog
OUTER APPLY(SELECT * FROM [dbo].[breakUrl](URL, '/')) as segments) urls

inner JOIN (SELECT LEN(innerUrl.urlString) urlLength, innerUrl.urlString as urlString, innerUrl.URL, innerUrl.urlStrId as urlStrId  FROM(
SELECT top 300 URL, segments.urlString, segments.urlStrId FROM RequestLog
OUTER APPLY(SELECT * FROM [dbo].[breakUrl](URL, '/')) as segments)innerUrl 
WHERE innerUrl.urlStrId =3 ) iu  on  iu.URL = urls.URL
