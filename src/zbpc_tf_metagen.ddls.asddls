@EndUserText.label: 'Generate MetaData From BPC Models'
@ClientHandling.type: #CLIENT_INDEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZBPC_TF_METAGEN

with parameters 
p_appset : uj_appset_id,
p_app : uj_appl_id
returns {
   
  APPLICATION_ID              : uj_appl_id;
  ADSO                        : rsoadsonm;
  ADSO_VIEW                   : table_name;
  CUSTOM_VIEW                 : table_name;
  CUSTOM_CDS_VIEW             : ddlname;
  CUSTOM_TF                   : ddlname;      
  POSITION                    : tabfdpos;
  DIMENSION                   : uj_dim_name;
  BW_FIELDNAME                : fieldname;
  MDATA_BW_TABLE              : table_name;
  ROLLNAME                    : rollname;
  FIELDS_GROUPBY              : rrtmdxstatement;
  FIELDS_SELECT               : rrtmdxstatement;
  FIELDS_GROUPBY_CDS          : rrtmdxstatement;
  FIELDS_SELECT_CDS           : rrtmdxstatement;
  FIELDS_TF                   : rrtmdxstatement;
  
  
}
implemented by method ZCL_BPC_METADATA=>GET_METADATA_FOR_MODEL;
