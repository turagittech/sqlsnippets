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




-- Quiery to get parent, child and key name for foreign key relatiohsip

select schema_name(tab.schema_id) + '.' + tab.name as [table],
    col.column_id,
    col.name as column_name,
    case when fk.object_id is not null then '>-' else null end as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,
    pk_col.name as pk_column_name,
    fk_cols.constraint_column_id as no,
    fk.name as fk_constraint_name
from sys.tables tab
    inner join sys.columns col
        on col.object_id = tab.object_id
    left outer join sys.foreign_key_columns fk_cols
        on fk_cols.parent_object_id = tab.object_id
        and fk_cols.parent_column_id = col.column_id
    left outer join sys.foreign_keys fk
        on fk.object_id = fk_cols.constraint_object_id
    left outer join sys.tables pk_tab
        on pk_tab.object_id = fk_cols.referenced_object_id
    left outer join sys.columns pk_col
        on pk_col.column_id = fk_cols.referenced_column_id
        and pk_col.object_id = fk_cols.referenced_object_id
where fk.object_id is not null
order by schema_name(tab.schema_id) + '.' + tab.name,
    col.column_id

 ;


--  Test for a foreign key relathips



create table testparent (
    id int PRIMARY KEY identity (1,1),
    name nvarchar(150))

    CREATE TABLE testchild(
        id int PRIMARY KEY IDENTITY (1,1),
        Parentid int,
        Name NVARCHAR(150))




--Add random data to a table (useful for testing)
Declare @Id int
Set @Id = 1

While @Id <= 12000
Begin
   Insert Into testparent values ('Author - ' + CAST(@Id as nvarchar(10)))
   Print @Id
   Set @Id = @Id + 1
End

Declare @Id int
Set @Id = 1


While @Id <= 12000
Begin
   Insert Into testchild values (@id , 'Author - ' + CAST(@Id as nvarchar(10))
              )
   Print @Id
   Set @Id = @Id + 1
End

-- Add Foreign Key - Doing it this way verifies the key relationship
ALTER TABLE testchild ADD CONSTRAINT FK_Parent_Child FOREIGN KEY (Parentid ) REFERENCES testparent(id)

-- Locate keys refeencing a singpe parent table

-- This was being utilised in some work hence thy aproach that could have ben simplified into a single cte

WITH fkeys AS (
select schema_name(tab.schema_id) + '.' + tab.name as [table],
    col.column_id,
    col.name as column_name,
    case when fk.object_id is not null then '>-' else null end as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,
    pk_col.name as pk_column_name,
    fk_cols.constraint_column_id as no,
    fk.name as fk_constraint_name
from sys.tables tab
    inner join sys.columns col
        on col.object_id = tab.object_id
    left outer join sys.foreign_key_columns fk_cols
        on fk_cols.parent_object_id = tab.object_id
        and fk_cols.parent_column_id = col.column_id
    left outer join sys.foreign_keys fk
        on fk.object_id = fk_cols.constraint_object_id
    left outer join sys.tables pk_tab
        on pk_tab.object_id = fk_cols.referenced_object_id
    left outer join sys.columns pk_col
        on pk_col.column_id = fk_cols.referenced_column_id
        and pk_col.object_id = fk_cols.referenced_object_id
where fk.object_id is not null
        ),
 accts AS (
    Select f.[table], f.primary_table, column_name, fk_constraint_name from fkeys f
    where f.primary_table = 'dbo.testparent'
),
       accts_columns AS(
           select a.[table], column_name from accts a
       )
SELECT * from accts