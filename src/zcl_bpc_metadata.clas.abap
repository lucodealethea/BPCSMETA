class zcl_bpc_metadata definition
  public
  final
  create public .

public section.
 INTERFACES if_amdp_marker_hdb .

 TYPES:
  BEGIN OF g_t_app_meta,
  APPLICATION_ID              TYPE UJ_APPL_ID,
  ADSO                        TYPE RSOADSONM,
  ADSO_VIEW                   TYPE TABLE_NAME,
  CUSTOM_VIEW                 TYPE TABLE_NAME,
  CUSTOM_CDS_VIEW             TYPE TABLE_NAME,
  CUSTOM_TF                   TYPE TABLE_NAME,
  POSITION                    TYPE TABFDPOS,
  DIMENSION                   TYPE UJ_DIM_NAME,
  BW_FIELDNAME                TYPE FIELDNAME,
  MDATA_BW_TABLE              TYPE TABLE_NAME,
  ROLLNAME                    TYPE ROLLNAME,
  FIELDS_GROUBY               TYPE RRTMDXSTATEMENT,
  FIELDS_SELECT               TYPE RRTMDXSTATEMENT,
  FIELDS_GROUBY_CDS           TYPE RRTMDXSTATEMENT,
  FIELDS_SELECT_CDS           TYPE RRTMDXSTATEMENT,
  FIELDS_TF                   TYPE RRTMDXSTATEMENT,
  END OF g_t_app_meta.
  TYPES:
  gtt_app_meta TYPE STANDARD TABLE OF g_t_app_meta.

  CLASS-METHODS:

  GET_METADATA_FOR_MODEL
  FOR TABLE function ZBPC_TF_METAGEN.

protected section.
private section.
ENDCLASS.



CLASS ZCL_BPC_METADATA IMPLEMENTATION.


METHOD  GET_METADATA_FOR_MODEL
    BY DATABASE FUNCTION FOR HDB
          LANGUAGE SQLSCRIPT
          OPTIONS READ-ONLY
          USING UJA_DIMENSION UJA_APPL DD03L UJA_DIM_APPL UJA_APPSET_INFO UJA_DIMENSIONT "DD03K
          DD07V.
 lt_metadata=
 SELECT
  "D"."MANDT",
  "D"."APPSET_ID",
  "DA"."APPLICATION_ID",
  "D"."DIMENSION",
  "D"."TECH_NAME",
  CONCAT(
    N'/B28/OI',
    RTRIM (
      RTRIM(
        SUBSTRING(
          "D"."TECH_NAME",
          7,
          12
        )
      )
    )
  ) AS "ROLLNAME",
  "D"."NUM_HIER",
  CONCAT(
    N'/B28/S_',
    RTRIM (
      RTRIM(
        SUBSTRING(
          "D"."TECH_NAME",
          7,
          12
        )
      )
    )
  ) AS "BW_FIELDNAME",
  CONCAT(
    RTRIM (
      RTRIM(
        SUBSTRING(
          "D"."TECH_NAME",
          1,
          6
        )
      )
    ),
    RTRIM (
      RTRIM(
        SUBSTRING(
          "D"."TECH_NAME",
          7,
          12
        )
      )
    )
  ) AS "BPC_FIELDNAME",
  CONCAT(
    RTRIM (
      REPLACE (
        RTRIM(
          "MD"."INFOCUBE"
        ),
        RTRIM(
          N'/CPMB/'
        ),
        RTRIM(
          N'/B28/A'
        )
      )
    ),
    N'7'
  ) AS "ADSO_VIEW",
  (
    CONCAT(
      N'ZVBPC_',
      RTRIM (
        "DA"."APPLICATION_ID"
      )
    )
  ) AS "CUSTOM_VIEW",
  (
    CONCAT(
      N'ZBPC_',
      RTRIM (
        "DA"."APPLICATION_ID"
      )
    )
  ) AS "CUSTOM_CDS_VIEW",
  (
    CONCAT(
      N'ZBPC_TF_',
      RTRIM (
        "DA"."APPLICATION_ID"
      )
    )
  ) AS "CUSTOM_TF",
  "MD"."INFOCUBE" AS "ADSO",
  "D"."DATA_TABLE",
  CONCAT(
    N'/B28/P',
    RTRIM (
      RTRIM(
        SUBSTRING(
          "D"."TECH_NAME",
          7,
          12
        )
      )
    )
  ) AS "MDATA_BW_TABLE",
  CONCAT(
    N'/B28/S',
    RTRIM (
      RTRIM(
        SUBSTRING(
          "D"."TECH_NAME",
          7,
          12
        )
      )
    )
  ) AS "MDATS_BW_TABLE",
  REPLACE (
    RTRIM(
      "D"."TECH_NAME"
    ),
    RTRIM(
      N'/CPMB/'
    ),
    RTRIM(
      N'/1CPMB/P'
    )
  ) AS "DESC_TABLE",
  "D"."DESC_TABLE" AS "TEXT_TABL",
  "D"."HIER_DATA_TABLE" AS "HIER_TABLE",
  CONCAT(
    RTRIM (
      CONCAT(
        N'SELECT DISTINCT "',
        RTRIM (
          REPLACE (
            RTRIM(
              "D"."TECH_NAME"
            ),
            RTRIM(
              N'/CPMB/'
            ),
            RTRIM(
              N'/B28/S_'
            )
          )
        )
      )
    ),
    N'" AS ID,'
  ) AS "STRING_ONE",
  CONCAT(
    RTRIM (
      CONCAT(
        N'''',
        N'IS_DIMENSION'
      )
    ),
    N''' AS ATTRIBUTE,'
  ) AS "STRING_TWO",
  CONCAT(
    RTRIM (
      CONCAT(
        RTRIM (
          CONCAT(
            N'''',
            RTRIM (
              "D"."DIMENSION"
            )
          )
        ),
        N''' AS DIM FROM "'
      )
    ),
    RTRIM (
      REPLACE (
        RTRIM(
          "D"."TECH_NAME"
        ),
        RTRIM(
          N'/CPMB/'
        ),
        RTRIM(
          N'/B28/S'
        )
      )
    )
  ) AS "STRING_THREE",
  CONCAT(
    RTRIM (
      CONCAT(
        RTRIM (
          CONCAT(
            N'" WHERE LOCATE_REGEXPR(',
            RTRIM (
              CONCAT(
                N'''(?=.*[a-z])',
                N''' in "'
              )
            )
          )
        ),
        RTRIM (
          REPLACE (
            RTRIM(
              "D"."TECH_NAME"
            ),
            RTRIM(
              N'/CPMB/'
            ),
            RTRIM(
              N'/B28/S_'
            )
          )
        )
      )
    ),
    N'") = 1;'
  ) AS "REGULAR_EXP"
FROM (
  (
    (
      (
        (
          "UJA_DIMENSION" "D" INNER JOIN "UJA_DIM_APPL" "DA" ON (
            "D"."MANDT" = "DA"."MANDT" AND
            "D"."APPSET_ID" = "DA"."APPSET_ID" AND
            "D"."DIMENSION" = "DA"."DIMENSION" AND
            "D"."MANDT" = "DA"."MANDT"
          )
        ) INNER JOIN "UJA_APPL" "AP" ON (
          "AP"."MANDT" = "DA"."MANDT" AND
          "AP"."APPSET_ID" = "DA"."APPSET_ID" AND
          "AP"."APPLICATION_ID" = "DA"."APPLICATION_ID" AND
          "D"."MANDT" = "AP"."MANDT"
        )
      ) INNER JOIN "UJA_APPSET_INFO" "DS" ON (
        "DS"."MANDT" = "DA"."MANDT" AND
        "DS"."APPSET_ID" = "DA"."APPSET_ID" AND
        "D"."MANDT" = "DS"."MANDT"
      )
    ) INNER JOIN "UJA_DIMENSIONT" "TX" ON (
      "D"."MANDT" = "TX"."MANDT" AND
      "D"."APPSET_ID" = "TX"."APPSET_ID" AND
      "D"."DIMENSION" = "TX"."DIMENSION" AND
      "TX"."LANGU" = N'E' AND
      "D"."MANDT" = "TX"."MANDT"
    )
  ) LEFT OUTER JOIN "DD07V" "VD" ON (
    "D"."DIM_TYPE" = "VD"."DOMVALUE_L" AND
    "VD"."DOMNAME" = N'UJ_DIM_TYPE' AND
    "VD"."DDLANGUAGE" = N'E'
  )
) INNER JOIN "UJA_APPL" "MD" ON (
  "MD"."MANDT" = "DA"."MANDT" AND
  "MD"."APPSET_ID" = "DA"."APPSET_ID" AND
  "DA"."APPLICATION_ID" = "MD"."APPLICATION_ID" AND
  "D"."MANDT" = "MD"."MANDT"
)
WHERE (
  "D"."APPSET_ID" = :p_appset AND
  "DA"."APPLICATION_ID" = :p_app AND

  "D"."MANDT" = SESSION_CONTEXT(
    'CDS_CLIENT'
  )
)
;

lt_max_pos=
SELECT
max(DD.POSITION) as MAX_POS
FROM :lt_metadata as M
INNER JOIN DD03L AS DD ON DD.TABNAME = M.ADSO_VIEW AND M.BW_FIELDNAME = DD.FIELDNAME AND DD.AS4LOCAL = 'A';

lt_meta_fields=
SELECT
META.APPLICATION_ID,
META.ADSO,
META.ADSO_VIEW,
META.CUSTOM_VIEW,
META.CUSTOM_CDS_VIEW,
META.CUSTOM_TF,
DD.POSITION,
META.DIMENSION,
META.BW_FIELDNAME,
META.MDATA_BW_TABLE,
DD2.ROLLNAME,
'"F"."'||META.BW_FIELDNAME||'",' AS FIELDS_GROUPBY,
'"F"."'||META.BW_FIELDNAME||'" '||'AS '||META.DIMENSION||',' AS FIELDS_SELECT,
'F.'||META.BW_FIELDNAME||',' AS FIELDS_GROUPBY_CDS,
'key F.'||META.BW_FIELDNAME||' AS '||META.DIMENSION||',' AS FIELDS_SELECT_CDS,
META.DIMENSION||' : '||DD2.ROLLNAME||' ;' AS FIELDS_TF
FROM :lt_metadata as META
INNER JOIN DD03L AS DD ON DD.TABNAME = META.ADSO_VIEW AND META.BW_FIELDNAME = DD.FIELDNAME AND DD.AS4LOCAL = 'A'
LEFT OUTER JOIN DD03L AS DD2 ON DD2.TABNAME = META."MDATA_BW_TABLE" AND META.BW_FIELDNAME = DD2.FIELDNAME AND DD2.AS4LOCAL = 'A'
/*
AND DD.TABCLASS = 'VIEW'
*/
UNION

SELECT
:p_app AS APPLICATION_ID,
( SELECT DISTINCT ADSO FROM :lt_metadata ) AS ADSO,
( SELECT DISTINCT ADSO_VIEW FROM :lt_metadata ) AS ADSO_VIEW,
( SELECT DISTINCT CUSTOM_VIEW FROM :lt_metadata ) AS CUSTOM_VIEW,
( SELECT DISTINCT CUSTOM_CDS_VIEW FROM :lt_metadata ) AS CUSTOM_CDS_VIEW,
( SELECT DISTINCT CUSTOM_TF FROM :lt_metadata ) AS CUSTOM_TF,
(SELECT LPAD(TO_VARCHAR(TO_INTEGER(MAX_POS)+1),4,'0') AS MAX_POS FROM :lt_max_pos)  AS POSITION,
'SIGNEDDATA' AS DIMENSION,
'/B28/S_SDATA' AS FIELDNAME,
'' AS MDATA_BW_TABLE,
'/B28/OISDATA' AS ROLLNAME,
'"F"."'||'/B28/S_SDATA"' AS FIELDS_GROUPBY,
'SUM("F"."/B28/S_SDATA")'||' AS SIGNEDDATA' AS FIELDS_SELECT,
'F.'||'/B28/S_SDATA' AS FIELDS_GROUPBY_CDS,
'SUM(F./B28/S_SDATA)'||' AS SIGNEDDATA' AS FIELDS_SELECT_CDS,
'SIGNEDDATA'||' : '||'/B28/OISDATA'||' ;' AS FIELDS_TF

FROM SYS.DUMMY

UNION

SELECT
:p_app AS APPLICATION_ID,
( SELECT DISTINCT ADSO FROM :lt_metadata ) AS ADSO,
( SELECT DISTINCT ADSO_VIEW FROM :lt_metadata ) AS ADSO_VIEW,
( SELECT DISTINCT CUSTOM_VIEW FROM :lt_metadata ) AS CUSTOM_VIEW,
( SELECT DISTINCT CUSTOM_CDS_VIEW FROM :lt_metadata ) AS CUSTOM_CDS_VIEW,
( SELECT DISTINCT CUSTOM_TF FROM :lt_metadata ) AS CUSTOM_TF,
'0001'  AS POSITION,
'' AS DIMENSION,
'REQTSN' AS FIELDNAME,
'' AS MDATA_BW_TABLE,
'RSPM_REQUEST_TSN' AS ROLLNAME,
'' AS FIELDS_GROUPBY,
'' AS FIELDS_SELECT,
'' AS FIELDS_GROUPBY_CDS,
'' AS FIELDS_SELECT_CDS,
'' AS FIELDS_TF

FROM SYS.DUMMY

UNION

SELECT
:p_app AS APPLICATION_ID,
( SELECT DISTINCT ADSO FROM :lt_metadata ) AS ADSO,
( SELECT DISTINCT ADSO_VIEW FROM :lt_metadata ) AS ADSO_VIEW,
( SELECT DISTINCT CUSTOM_VIEW FROM :lt_metadata ) AS CUSTOM_VIEW,
( SELECT DISTINCT CUSTOM_CDS_VIEW FROM :lt_metadata ) AS CUSTOM_CDS_VIEW,
( SELECT DISTINCT CUSTOM_TF FROM :lt_metadata ) AS CUSTOM_TF,
'0002'  AS POSITION,
'' AS DIMENSION,
'RECORDMODE' AS FIELDNAME,
'' AS MDATA_BW_TABLE,
'' AS ROLLNAME,
'' AS FIELDS_GROUPBY,
'' AS FIELDS_SELECT,
'' AS FIELDS_GROUPBY_CDS,
'' AS FIELDS_SELECT_CDS,
'' AS FIELDS_TF

FROM SYS.DUMMY

ORDER BY 4 ASC
;
cte_temp=
SELECT
  APPLICATION_ID
,  ADSO
,  ADSO_VIEW
,  CUSTOM_VIEW
,  CUSTOM_CDS_VIEW
,  CUSTOM_TF
,  CASE BW_FIELDNAME
    WHEN 'REQTSN' THEN '000'
    WHEN 'RECORDMODE' THEN '000'
   ELSE POSITION
   END AS POSITION
,  DIMENSION
,  BW_FIELDNAME
,  MDATA_BW_TABLE
,  ROLLNAME
,  FIELDS_GROUPBY
,  FIELDS_SELECT
,  FIELDS_GROUPBY_CDS
,  FIELDS_SELECT_CDS
,  FIELDS_TF

from :lt_meta_fields
ORDER BY APPLICATION_ID, POSITION, BW_FIELDNAME DESC
;
RETURN
SELECT
  APPLICATION_ID
,  ADSO
,  ADSO_VIEW
,  CUSTOM_VIEW
,  CUSTOM_CDS_VIEW
,  CUSTOM_TF
,  CASE BW_FIELDNAME WHEN 'REQTSN' THEN '0001' WHEN 'RECORDMODE' THEN '0002' ELSE POSITION
END AS POSITION
,  DIMENSION
,  BW_FIELDNAME
,  MDATA_BW_TABLE
,  ROLLNAME
,  FIELDS_GROUPBY
,  FIELDS_SELECT
,  FIELDS_GROUPBY_CDS
,  FIELDS_SELECT_CDS
,  FIELDS_TF

from :cte_temp
;

endmethod.
ENDCLASS. " ZCL_BPC_METADATA
