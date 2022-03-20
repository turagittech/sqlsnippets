  select t.name as tablename, schemas.schema_name as schemaname from sys.tables t
  INNER JOIN (
select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
) schemas ON t.schema_id = schemas.schema_id
WHERE  schemas.schema_name = 'staging'