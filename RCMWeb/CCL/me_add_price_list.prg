drop program me_add_price_list:dba go
create program me_add_price_list:dba
 
 
/***************************************************************************************/
;~DB~**********************************************************************************
;    *                   GENERATED MODIFICATION CONTROL LOG                           *
;    **********************************************************************************
;    *                                                                                *
;    *Mod 	Date     	Engineer            Feature    Comment                        *
;    *--- 	-------- 	----------------	-------    -------------------------------*
;    *000 	                                            Initial Release
;    *001   09-MAY-23    AS013684                       Update for rcm_auth_summary add *
;~DE~**********************************************************************************
 
 
%i me_header_ccl.inc
 
/******************  DEFINED CONSTANTS             *******************/
declare mdtDANone     = q8 with noconstant(0.0)
declare mdtDAEnd      = q8 with noconstant(0.0)
declare msDATableName = vc with noconstant("")
 
set mdtDANone     = cnvtdatetime("01-JAN-1800 00:00:00.00")
set mdtDAEnd      = cnvtdatetime("31-DEC-2100 23:59:59.00")
set msDATableName = "CUST_PRICE_LIST"
 
/******************  DEFINED VARIABLES             *******************/
declare mnDAModObj = i4 with noconstant(0)
declare mnDAModRec = i4 with noconstant(0)
declare mnDAModFld = i4 with noconstant(0)
declare mnDAStart  = i4 with noconstant(1)
declare mnDAStop   = i4 with noconstant(0)
 
/******************  DECLARED SUBROUTINES          *******************/
declare CheckError(nFailed = i4) = i2 with protect
declare LogFieldModified(sFieldName = vc, sFieldType = vc, sObjValue = vc, sDBValue = vc) = null
declare me_add_price_list(nStart = i4, nStop = i4) = null with protect
 
;create a transaction info structure if one doesn't already exist or is zero
if (trim(cnvtstring(validate(TransInfo->trans_dt_tm,0))) = "0")
  record TransInfo
  (
  1 trans_dt_tm = dq8
  )
  set TransInfo->trans_dt_tm = cnvtdatetime(curdate, curtime3)
endif
 
;create standard reply structure if it doesn't exist
if (validate(reply->mod_objs, "Z") = "Z")
record reply
(
%i me_status_block.inc
%i cclsource:status_block.inc
)
endif
 
set mnDAModObj = size(reply->mod_objs,5)
if (mnDAModObj = 0)
  set stat = alterlist(reply->mod_objs,1)
  set mnDAModObj = 1
  set reply->mod_objs[mnDAModObj].entity_type = msDATableName
endif
set mnDAModRec = size(reply->mod_objs[mnDAModObj]->mod_recs,5)
 
;record request
;(
;1 objarray[*]
;
;
;2 active_ind =  i2
;2 beg_effect_dt_tm = dq8
;2 client_id = f8
;2 code_type_cd = f8
;2 end_effect_dt_tm = dq8
;2 exclusion_flg = i4
;2 fin_class_cd = f8
;2 gross_price = i4
;2 health_plan_id = f8
;2 price_list_id = f8
;2 price_rule_id = f8
;2 receiver_id = vc
;
;2 service_code = vc
;2 updt_dt_tm = dq8
;2 updt_id =  f8
;
;
;)
 
 
 
set mnDAStop = size(request->objArray,5)
set stat   = alterlist(reply->mod_objs[mnDAModObj]->mod_recs, mnDAModRec + (mnDAStop - mnDAStart + 1))
set reply->status_data->status = 'F'
 
call me_add_price_list(mnDAStart, mnDAStop)
 
/*************************************************
          Subroutine to ADD PFT_VIEW
*************************************************/
subroutine me_add_price_list(nStart, nStop)
 
declare dActiveStatusCD = f8 with noconstant(0.0), protect
declare dID             = f8 with noconstant(0.0), protect
declare i               = i4 with noconstant(0),   protect
 
set dActiveStatusCD = reqdata->active_status_cd
 
; call echo("step3")
; CALL ECHORECORD(REQUEST)
 
set i = nStart
while (i <= nStop)
  set dID = 0.0
 
  ;create pk if necessary
;  if (validate(request->objArray[i].rcm_charge_id, -0.00001) <= 0.0)
    ;get unique number
    select into "nl:"
      sDAPK = seq(CUST_PRICE_LIST_SEQ, nextval)"##################;rp0"
    from dual
    detail
      dID = cnvtreal(sDAPK)
    with format, counter
 
 
 
 
; call echo("dID")
; call echo(dID)
;    if (curqual = 0)
;      if (FALSE = CheckError(GEN_NBR_ERROR)) return endif
;    endif
;;  else
;    set dID = request->objArray[i].rcm_charge_id
;  endif
  ; go to END_PROGRAM
  INSERT FROM cust_price_list C SET
   C.price_list_id                  = dID,
   C.beg_effect_dt_tm               =   cnvtdatetime(request->objarray[i].beg_effect_dt_tm),
   C.end_effect_dt_tm               =   cnvtdatetime(request->objarray[i].end_effect_dt_tm),
 
   C.active_ind			               =  1,
   C.cm_price_list_id              	       = if (validate(request->objarray[i].CM_PRICE_LIST_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[i].CM_PRICE_LIST_ID, -0.00001)
                                     else
                                        0.0
                                     endif,
   C.client_id              	       = if (validate(request->objarray[i].CLIENT_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[i].CLIENT_ID, -0.00001)
                                     else
                                        0.0
                                     endif,
   C.code_type_cd                      = if (validate(request->objarray[i].CODE_TYPE_CD, -0.00001) != -0.00001)
                                        validate(request->objarray[i].CODE_TYPE_CD, -0.00001)
                                      else
                                        NULL
                                      endif,
  C.exclusion_flg                 		 = if (validate(request->objarray[i].EXCLUSION_FLG, -0.00001) != -0.00001)
                                        validate(request->objarray[i].EXCLUSION_FLG, -0.00001)
                                      else
                                        NULL
                                      endif,
  C.price_rule_id              		 = if (validate(request->objarray[i].PRICE_RULE_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[i].PRICE_RULE_ID, -0.00001)
                                      else
                                        NULL
                                      endif,
   C.fin_class_cd                   	= if (validate(request->objarray[i].FIN_CLASS_CD, -0.00001) != -0.00001)
                                        validate(request->objarray[i].FIN_CLASS_CD, -0.00001)
                                      else
                                        0.0
                                      endif,
 
   C.gross_price            		 = if (validate(request->objarray[i].GROSS_PRICE, -0.00001) != -0.00001)
                                        validate(request->objarray[i].GROSS_PRICE, -0.00001)
                                      else
                                        0.0
                                      endif,
 
   C.health_plan_id                 = if (validate(request->objarray[i].HEALTH_PLAN_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[i].HEALTH_PLAN_ID, -0.00001)
                                     else
                                       NULL
                                     endif,
   C.updt_id               			 = if (validate(request->objarray[i].UPDT_ID,-0.00001) != -0.00001)
                                        validate(request->objarray[i].UPDT_ID, -0.00001)
                                     else
                                       0.0
                                     endif,
 
   C.receiver_id                    = if (validate(request->objarray[i].RECEIVER_ID, CHAR(128)) != CHAR(128))
                                        validate(request->objarray[i].RECEIVER_ID, CHAR(128))
                                      else
                                        NULL
                                      endif,
   C.service_code                    = if (validate(request->objarray[i].SERVICE_CODE, CHAR(128)) != CHAR(128))
                                        validate(request->objarray[i].SERVICE_CODE, CHAR(128))
                                      else
                                        NULL
                                      endif,
   C.updt_dt_tm  					 =  cnvtdatetime(curdate,curtime)
 
  WITH nocounter
 
 
 call echoxml(request->objarray, "cust_pricelist_ins.xml")
  if (curqual = 0)
    if (FALSE = CheckError(INSERT_ERROR)) return endif
  else
    if (mnDAModRec = size(reply->mod_objs[mnDAModObj]->mod_recs,5))
      set stat = alterlist(reply->mod_objs[mnDAModObj]->mod_recs, 1)
    endif
 
    set mnDAModRec = mnDAModRec + 1
    set reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec].table_name = msDATableName
    set reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec].pk_values  =
          cnvtstring(dID)
 call echoxml(request->objarray, "cust_pricelist_ins.xml")
    call CheckError(TRUE)
  endif
 
set i = i + 1
 
endwhile
 
end ;me_add_summary_auth
 
subroutine CheckError(nFailed)
  if (nFailed = TRUE)
    set reply->status_data->status = 'S'
    set reqinfo->commit_ind = TRUE
    return (TRUE)
  else
    case(nFailed)
    of GEN_NBR_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'GEN_NBR'
    of INSERT_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'INSERT'
    of UPDATE_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'UPDATE'
    of REPLACE_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'REPLACE'
    of DELETE_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'DELETE'
    of UNDELETE_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'UNDELETE'
    of REMOVE_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'REMOVE'
    of ATTRIBUTE_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'ATTRIBUTE'
    of LOCK_ERROR:
      set reply->status_data->subeventstatus[1]->operationname = 'LOCK'
    else
      set reply->status_data->subeventstatus[1]->operationname = 'UNKNOWN'
    endcase
 
    set reply->status_data->subeventstatus[1]->operationstatus   = 'F'
    set reply->status_data->subeventstatus[1]->targetobjectname  = 'TABLE'
    set reply->status_data->subeventstatus[1]->targetobjectvalue = msDATableName
    set reqinfo->commit_ind = FALSE
 
    return (FALSE)
  endif
end ;CheckError
 
subroutine LogFieldModified(sFieldName, sFieldType, sObjValue, sDBValue)
  if (mnDAModFld = size(reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec]->mod_flds,5))
    set stat = alterlist(reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec]->mod_flds, mnDAModFld + 1)
  endif
 
  set mnDAModFld = mnDAModFld + 1
  set reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec]->mod_flds[mnDAModFld].field_name      = sFieldName
  set reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec]->mod_flds[mnDAModFld].field_type      = sFieldType
  set reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec]->mod_flds[mnDAModFld].field_value_obj = trim(sObjValue,3)
  set reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec]->mod_flds[mnDAModFld].field_value_db  = trim(sDBValue,3)
end ;LogFieldModified
 
#END_PROGRAM
 
set stat = alterlist(reply->mod_objs[mnDAModObj]->mod_recs, mnDAModRec)
 
end
go
 
