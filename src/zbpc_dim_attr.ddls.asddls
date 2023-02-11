@AbapCatalog.sqlViewName: 'ZVBPC_DIM_ATTR'
@EndUserText.label: 'BPC Dimension Attributes'
@ClientHandling.type: #INHERITED
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view ZBPC_DIM_ATTR as 
select distinct from zvbpc_attributes as A
left outer join dd03l as DD on DD.tabname = A.data_table
and DD.fieldname = A.attr_tech_name
left outer join dd03l as DDBW on DDBW.tabname = A.mdata_bw_table
and DDBW.fieldname = A.bw_fieldname
left outer join ujm_iobj_slt as F on F.iobjnm = A.tech_name 
and F.mandt = $session.client

{
key A.appset_id,
key A.dimension,
key root,
key A.tech_name,
key A.attribute_name,
key A.attr_tech_name,
case A.attribute_name
when 'EVDESCRIPTION' then '0096'
when 'CALC' then '0097'
when 'SCALING' then '0098'
when 'HIR' then '0099'
else DD.position end as sortnr,
A.num_hier, 
case A.attribute_name
when 'EVDESCRIPTION' then '/BI0/OBPCTXTLG'    
else    DDBW.rollname end as rollname,
    F.formula as IS_FORMULA,
    F.tabname,
    A.attribute_size,
    A.attribute_type,
    A.time_dependent,
    A.attr_caption,
    A.f_display,
    A.f_generate,
    A.f_uppercase,
    A.valid_id,    

    A.data_table,                                                                                      
    A.mdata_bw_table,
    A.mdats_bw_table,  
    A.bw_fieldname,  
//descendants table where NIV = 0 equals  data_table where /CPMB/CALC = N
// but have to exclude hier nodes without children with IS_BAS_EQ_NODE = Y 
// this property is custom and exists only in OBS  
    replace(A.tech_name,'/CPMB/','/1CPMB/P') as desc_table,
    A.desc_table as text_tabl,                                                                       
    A.hier_data_table as hier_table,
    concat(',',concat(A.bw_fieldname,' AS ')) as select_string_cds,
    concat(',',A.attribute_name) as select_string_cds2,
    concat(concat(concat(',"',A.bw_fieldname),'" AS'),concat(concat(' "',A.attribute_name),'"')) as select_string,
    //concat(concat(concat(concat('SELECT DISTINCT "',A.bw_fieldname),'"  AS ID'),concat(concat(concat(' FROM "',A.mdats_bw_table),''),A.regular_exp)),concat(A.bw_fieldname,'") = 1;')) as select_string2
    concat(concat(concat(A.string_one,A.string_two),A.string_three),mdats_bw_table) as lowerc_string1,
    A.regular_exp,
    concat(concat(concat(A.attribute_name,' : '),DDBW.rollname),';') as tf_hier_string
    
}
where A.appset_id = 'TRACTEBEL_TEMIS'
