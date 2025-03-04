select 
	tab.schema_id
,	sch.name
,	tab.object_id
,	tab.name as fk_par
 ,   col.column_id
 ,   col.name as column_name
,    case when fk.object_id is not null then '>-' else null end as rel
,    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table
,    pk_col.name as pk_column_name
 ,   fk.name as fk_constraint_name
from sys.tables tab
	inner join sys.schemas AS sch
	on sch.schema_id = tab.schema_id
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
order by schema_name(tab.schema_id) + '.' + tab.name,
    col.column_id