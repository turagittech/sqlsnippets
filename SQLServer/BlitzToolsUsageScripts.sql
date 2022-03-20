select bc.CheckDate, bc.CPUWeight, bc.DatabaseName, bc.Warnings, bc.QueryText, bc.QueryPlan from BlitzCache bc
where 1=1
and CheckDate > '2021-05-15'
and DatabaseName like '<dbname>'
and Warnings = 'Frequent Execution, Plan created last 4hrs'
order by ExecutionCount desc
select top 20 bc.* from BlitzCache bc
where 1=1
and CheckDate > '2021-05-15'
and DatabaseName like '<dbname>%'
order by ExecutionCount desc

-- BlitzIndex usage single database
exec dbo.sp_BlitzIndex @DatabaseName = '<dbname>'