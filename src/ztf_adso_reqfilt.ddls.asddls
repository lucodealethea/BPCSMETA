@ClientHandling.type: #CLIENT_INDEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZBPC_TF_REQFILT'

define table function ZTF_ADSO_REQFILT
with parameters p_objectname : sobj_name
returns {
  FILTER : uj_max_txt;
}
implemented by method zcl_bpc_derive_adso_filter=>read_req_tsn;
