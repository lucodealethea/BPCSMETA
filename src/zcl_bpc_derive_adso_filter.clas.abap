CLASS zcl_bpc_derive_adso_filter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

public section.
INTERFACES if_amdp_marker_hdb .
TYPES:
BEGIN OF g_t_filter,
  FILTER TYPE UJ_MAX_TXT,
END OF g_t_filter.

CLASS-METHODS:
read_req_tsn
FOR TABLE FUNCTION ZTF_ADSO_REQFILT.

ENDCLASS.

CLASS ZCL_BPC_DERIVE_ADSO_FILTER IMPLEMENTATION.

METHOD read_req_tsn BY database function for hdb language sqlscript using RSPMREQUEST.

DECLARE v_requestid NVARCHAR(1333);
DECLARE v_filter NVARCHAR( 1333 );
  DECLARE CURSOR c_cursor1 FOR SELECT MIN("REQUEST_TSN") FROM "RSPMREQUEST" WHERE "TLOGO" = 'ADSO' AND "DATATARGET" = :p_objectname AND "STORAGE" = 'AQ' AND "REQUEST_STATUS" NOT IN ('GG', 'GR', 'D', 'M');
  DECLARE CURSOR c_cursor2 FOR
  SELECT MAX("REQUEST_TSN") FROM "RSPMREQUEST"
  WHERE "TLOGO" = 'ADSO' AND "DATATARGET" = :p_objectname
  AND "STORAGE" = 'AQ' AND "REQUEST_STATUS" IN ('GG', 'GR')
  AND "REQUEST_TSN" < ( SELECT MIN("REQUEST_TSN") FROM "RSPMREQUEST" WHERE "TLOGO" = 'ADSO' AND "DATATARGET" = :p_objectname AND "STORAGE" = 'AQ' AND "REQUEST_STATUS" NOT IN ('GG', 'GR', 'D') );
  DECLARE CURSOR c_cursor3 FOR SELECT MAX("REQUEST_TSN") FROM "RSPMREQUEST" WHERE "TLOGO" = 'ADSO' AND "DATATARGET" = :p_objectname AND "STORAGE" = 'AQ' AND "REQUEST_STATUS" IN ('GG', 'GR');
      OPEN c_cursor1;
      FETCH c_cursor1 INTO v_requestid;
      CLOSE c_cursor1;
  IF :v_requestid IS NOT NULL THEN
   OPEN c_cursor2; FETCH c_cursor2 INTO v_requestid; CLOSE c_cursor2; ELSE OPEN c_cursor3;
    FETCH c_cursor3 INTO v_requestid; CLOSE c_cursor3; END IF;
    IF :v_requestid IS NOT NULL THEN v_filter := '"REQTSN" <= '|| v_requestid ||'';
    ELSE v_filter := '"REQTSN" <= 00000000000000000000000';
  END IF;
lt_result= SELECT DISTINCT v_filter as FILTER FROM SYS.DUMMY;

RETURN :lt_result;

ENDMETHOD.
ENDCLASS.
