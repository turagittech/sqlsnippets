Queries for ForeignKeys

/****************************************************************
Find all foreign keys in a database and table which as foriegn keys
*/

 select 
	t.name,
	fk.name,
	t.object_id as table_id,  
	fk.object_id as fk_id		
from sys.tables as t
join sys.foreign_keys as fk on
	fk.referenced_object_id = t.object_id


/* 
Show table, key name and table referenced
 */

 select t.name as tablename, t.object_id, fk.name as foreign_key, t1.name as referenced_table_name from sys.tables t
left join  sys.foreign_keys fk on fk.parent_object_id = t.object_id
left join sys.tables t1 on fk.referenced_object_id = t1.object_id
order by t.name, fk.name