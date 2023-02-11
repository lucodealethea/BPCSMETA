REPORT zbpc_dim_app.

PARAMETERS:
p_env TYPE uj_appset_id DEFAULT 'TRACTEBEL_TEMIS' ,
p_app TYPE uj_appl_id DEFAULT 'SGA'.

TYPE-POOLS: abap.

DATA:       m3      TYPE string,
            l_title TYPE sy-title,
            ls_metadata TYPE REF TO data,
*Table to hold the components
            tab_return TYPE abap_compdescr_tab,
*Work area for the component table
            components LIKE LINE OF tab_return,
            w_typ TYPE REF TO cl_abap_elemdescr,
            lt_tot_comp    TYPE cl_abap_structdescr=>component_table,
            lt_comp        TYPE cl_abap_structdescr=>component_table,
            la_comp        LIKE LINE OF lt_comp,
            lo_new_type    TYPE REF TO cl_abap_structdescr,
            lo_table_type  TYPE REF TO cl_abap_tabledescr,
            w_tref         TYPE REF TO data,
            w_dy_line      TYPE REF TO data.


FIELD-SYMBOLS: <dyn_tab>  TYPE STANDARD TABLE,
               <dyn_wa>,
               <dyn_field>.

START-OF-SELECTION.

SELECT
   zbpc_tf_metagen~application_id,
   zbpc_tf_metagen~adso,
   zbpc_tf_metagen~adso_view,
   zbpc_tf_metagen~custom_view,
   zbpc_tf_metagen~custom_cds_view,
   zbpc_tf_metagen~custom_tf,
   zbpc_tf_metagen~position,
   zbpc_tf_metagen~dimension,
   zbpc_tf_metagen~bw_fieldname,
   zbpc_tf_metagen~mdata_bw_table,
   zbpc_tf_metagen~rollname,
   zbpc_tf_metagen~fields_groupby,
   zbpc_tf_metagen~fields_select,
   zbpc_tf_metagen~fields_groupby_cds,
   zbpc_tf_metagen~fields_select_cds,
   zbpc_tf_metagen~fields_tf
 FROM
  zbpc_tf_metagen( p_appset = @p_env, p_app = @p_app )
  INTO TABLE @DATA(lt_metadata)
  ##db_feature_mode[amdp_table_function].

CREATE DATA ls_metadata LIKE LINE OF lt_metadata.

CONCATENATE 'Metadata--' p_app '--' INTO l_title.


*Call Perform to get the Int. Table Components
PERFORM get_int_table_fields USING    lt_metadata
                            CHANGING  tab_return.
* break-point.
* LENGTH, DECIMALS, TYPE_KIND, NAME

* for example only, in case we want to remove some fields,
* DELETE tab_return WHERE name = 'MDATA_BW_TABLE'.
* perform build_another_it using tab_return.

* and pass lt_metadata content into the newly created table

PERFORM callback_alv
USING l_title abap_true lt_metadata.
*using l_title abap_true <dyn_tab>.

FORM callback_alv USING
  VALUE(i_title) TYPE sy-title
  VALUE(i_sort)  TYPE abap_bool
  it_data        TYPE ANY TABLE.

  IF it_data IS INITIAL.
  CONCATENATE 'No data found with : ' p_env '/' p_app  INTO m3.
    MESSAGE i799(rsm1) WITH m3.

  ELSE.

    IF i_sort = abap_true.
      SORT it_data.
    ENDIF.

    CALL FUNCTION 'RSDU_CALL_ALV_TABLE'
      EXPORTING
        i_title   = i_title
        i_ta_data = it_data.

  ENDIF.

ENDFORM.                    "callback_alv

FORM get_int_table_fields  USING    t_data TYPE ANY TABLE
                           CHANGING t_return TYPE abap_compdescr_tab.

  DATA:
  oref_table TYPE REF TO cl_abap_tabledescr,
  oref_struc TYPE REF TO cl_abap_structdescr,
  oref_error TYPE REF TO cx_root,
  text TYPE string.
*Get the description of data object type
  TRY.
      oref_table ?=
      cl_abap_tabledescr=>describe_by_data( t_data ).
    CATCH cx_root INTO oref_error.
      text = oref_error->get_text( ).
      WRITE: / text.
      EXIT.
  ENDTRY.
*Get the line type
  TRY.
      oref_struc ?= oref_table->get_table_line_type( ).
    CATCH cx_root INTO oref_error.
      text = oref_error->get_text( ).
*      write: / text.
      EXIT.
  ENDTRY.
**  begin of abap_compdescr,
*    length    type i,
*    decimals  type i,
*    type_kind type abap_typekind,
*    name      type abap_compname,
*  end of abap_compdescr,
  APPEND LINES OF oref_struc->components TO t_return.
  CLEAR: components.

ENDFORM.                    " GET_INT_TABLE_FIELDS

FORM build_another_it USING w_data TYPE ANY TABLE.

 LOOP AT w_data INTO components.
  CASE components-type_kind.
      WHEN 'STRING'.  w_typ = cl_abap_elemdescr=>get_string( ).
      WHEN 'XSTRING'. w_typ = cl_abap_elemdescr=>get_xstring( ).
      WHEN 'I'.       w_typ = cl_abap_elemdescr=>get_i( ).
      WHEN 'F'.       w_typ = cl_abap_elemdescr=>get_f( ).
      WHEN 'D'.       w_typ = cl_abap_elemdescr=>get_d( ).
      WHEN 'T'.       w_typ = cl_abap_elemdescr=>get_t(  ).
      WHEN 'C'.       w_typ = cl_abap_elemdescr=>get_c( p_length = components-length ).
      WHEN 'N'.       w_typ = cl_abap_elemdescr=>get_n( p_length = components-length ).
      WHEN 'X'.       w_typ = cl_abap_elemdescr=>get_x( p_length = components-length ).
      WHEN 'P'.       w_typ = cl_abap_elemdescr=>get_p( p_length = components-length p_decimals = components-decimals ).
  ENDCASE.

 CLEAR la_comp.
    la_comp-type = w_typ.               "Field type
    la_comp-name = components-name.       "Field name   ex: FIELD1
    APPEND la_comp TO lt_tot_comp.      "Add entry to component table

  ENDLOOP.

* Create new type from component table
  lo_new_type = cl_abap_structdescr=>create( lt_tot_comp ).

* Create new table type
  lo_table_type = cl_abap_tabledescr=>create( lo_new_type ).

* Create dynamic internal table and assign to Field Symbol
  CREATE DATA w_tref TYPE HANDLE lo_table_type.
  ASSIGN w_tref->* TO <dyn_tab>.

* Create dynamic work area and assign to Field Symbol
  CREATE DATA w_dy_line LIKE LINE OF <dyn_tab>.
  ASSIGN w_dy_line->* TO <dyn_wa>.

     cl_abap_corresponding=>create(
      source            = lt_metadata
      destination       = <dyn_tab>
      mapping           = VALUE cl_abap_corresponding=>mapping_table(  )
      )->execute( EXPORTING source      = lt_metadata
                  CHANGING  destination = <dyn_tab> ).

ENDFORM.                    "build_another_it
