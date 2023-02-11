@AbapCatalog.sqlViewName: 'ZVBPC_ATTRIBUTES'
@EndUserText.label: 'BPC Dimension Attributes'
@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view ZBPC_ATTRIBUTES as 
select from uja_dim_attr as A
inner join uja_dimension as D 
    on A.appset_id = D.appset_id
    and A.dimension = D.dimension
    and A.mandt = D.mandt and D.mandt = $session.client
left outer join trese as RW on RW.name = A.attribute_name    
{
key A.appset_id
,key A.dimension
,key replace(D.tech_name,'/CPMB/','') as ROOT
,key A.tech_name as attr_tech_name
,case 
when RW.sourcehint is null then  
 case A.attribute_name when 'REVERSE' then 'REVERSE_' else A.attribute_name end
else concat(A.attribute_name,'1') 
end as attribute_name
,D.dim_type
,D.dim_type_index
,D.ref_dim
,D.num_hier
,D.tech_name
,D.server_version
,D.file_version
,D.file_lock
,D.process_state
,D.locked_by
,D.caption
,D.hier_time_dep
,D.process_date
,D.process_time
,D.struc_modif_date
,D.struc_modif_time
,D.mbr_modif_date
,D.mbr_modif_time
,D.data_table
,concat('/B28/P',substring(D.tech_name,7,12))as mdata_bw_table
,case when A.attribute_name = 'EVDESCRIPTION' then ''
else replace(A.tech_name,'/CPMB/','/B28/S') 
end as mdats_bw_table
,D.desc_table
,D.hier_data_table
,D.tda_table

,replace(A.tech_name,'/CPMB/','/B28/S_') as bw_fieldname

,A.attribute_size
,A.attribute_type
,A.time_dependent
,A.caption as attr_caption
,A.f_display
,A.f_generate
,A.f_uppercase
,A.valid_id
,concat(concat('SELECT DISTINCT "',replace(A.tech_name,'/CPMB/','/B28/S_')),'" AS ID,') as string_one
,concat(concat('''',A.attribute_name),''' AS ATTRIBUTE,') as string_two
,concat(concat('''',A.dimension),''' AS DIM FROM "') as string_three
,concat(concat(concat('" WHERE LOCATE_REGEXPR( ',concat('''(?=.*[a-z])',''' in "')),replace(A.tech_name,'/CPMB/','/B28/S_')),'") = 1;') as regular_exp

}
