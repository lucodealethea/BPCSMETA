@AbapCatalog.sqlViewName: 'ZVBPC_DMPCKG_STA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BPC DataManager Packages Status'
define view ZBPC_DMPCKG_STA as select from ujd_packages2 as PCK
left outer join ujd_packagest2 as TX
on PCK.mandt = TX.mandt and PCK.guid = TX.guid
left outer join ujd_status as ST on ST.mandt = PCK.mandt
and ST.application_id = PCK.app_id
and ST.appset_id = PCK.appset_id
and ST.package_id = PCK.package_id
and ST.chain_id = PCK.chain_id
left outer join tbtco as BJ on BJ.jobcount =  ST.job_id
and BJ.jobname = ST.job_name
left outer join ujd_lk_task_log as TL on ST.mandt = TL.mandt and ST.log_id = TL.task_instance_id
{
key PCK.mandt,
key PCK.guid,
key ST.log_id,
key PCK.appset_id,
key PCK.app_id,
key BJ.wpprocid,
PCK.group_id as group_link_name,
case TL.process_result when '1' then 'Success' when '2' then 'Warning'  when '3' then 'Failure' else
   '' end as result_plink,
TL.name as task_name,
PCK.package_id,
PCK.chain_id,
PCK.package_type,
PCK.user_group,
TX.package_desc,
left(ST.log_file,26) as pseudo_application_id,
ST.status,
PCK.team_id,
ST.user_id as user_id,
BJ.status as sm37_status,
ST.timestamp,
ST.timestamp_end,
ST.log_file,
ST.job_id,
ST.process_id,
ST.job_name,
ST.pkur_type,
ST.not_allow_abort
}
where TX.langu = $session.system_language
