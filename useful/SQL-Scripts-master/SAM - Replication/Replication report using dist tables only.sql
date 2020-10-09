use distribution
GO

SELECT 
	case 
	when cur_latency>900 then 'Warning'
	else 'Good' end as repl_status,
	md.publisher,
	md.publication,
	md.publisher_db,
	ss.srvname as subscriber,
	da.subscriber_db,
	CONVERT(CHAR(8),DATEADD(second,cur_latency,0),108) as latency,

	case 
		when md.publication_type=1 then 'Snapshot'
		when md.publication_type=0 then 'Transactional'
	end as publication_desc,
	case when msa.publication_type=1
		then max(start_time) 
		else NULL end as snap_repl_last_run_success
FROM [distribution]..[MSreplication_monitordata] md
join MSsnapshot_agents msa on md.publication=msa.publication
	join MSsnapshot_history h on msa.id=h.agent_id
	join MSdistribution_agents da on md.publication=da.publication
	join sys.sysservers ss on da.subscriber_id=ss.srvid
where md.agent_type=3 and h.runstatus=2
and subscriber_db<>'virtual'
group by 
	cur_latency,
	md.publisher,
	md.publication_type,
	msa.publication_type,
	md.warning,
	md.publication,
	md.publisher_db,
	ss.srvname,
	da.subscriber_db
order by cur_latency desc

