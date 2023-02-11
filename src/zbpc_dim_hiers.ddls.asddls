@AbapCatalog.sqlViewName: 'ZVBPC_DIM_HIERS'
@EndUserText.label: 'MetaData For BPC Hierarchies'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view ZBPC_DIM_HIERS as 
select from uja_dim_hier2 as H
inner join uja_dimension as D
    on H.appset_id = D.appset_id and H.dimension = D.dimension and H.mandt = D.mandt and H.mandt = $session.client
inner join uja_dim_hie_map2 as H2 on H2.dim_tech_name = D.tech_name and H2.hier_name = H.hierarchy_name and H2.mandt = H.mandt
inner join rshiedir as DIR on DIR.iobjnm = D.tech_name and DIR.hienm = H.hierarchy_name and DIR.objvers = 'A'    
//b28/h
{
key D.appset_id as AppsetId,
key DIR.hieid,
key D.dimension as Dimension,
D.num_hier as NumHier,
D.tech_name as TechName,
DIR.hienm,
H.datefrom,
H.dateto,
H.caption,
D.hier_time_dep as HierTimeDep,
H2.hier_table,
concat('/B28/H',substring(D.tech_name,7,10))as BW,
DIR.hietype,
DIR.startlevel,
DIR.numberlevel,
DIR.rootid,
DIR.maxnodeid,
DIR.timestmp,
D.struc_modif_date as StrucModifDate,
D.struc_modif_time as StrucModifTime,
D.mbr_modif_date as MbrModifDate,
D.mbr_modif_time as MbrModifTime,
D.data_table as DataTable,
D.desc_table as DescTable,
D.hier_data_table as HierDataTable,
D.tda_table as TdaTable    
}
where H.mandt = $session.client
