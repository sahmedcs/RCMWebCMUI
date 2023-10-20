drop program me_add_price_rule:dba go
create program me_add_price_rule:dba
 
 
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
set msDATableName = "CUST_PRICE_RULE"
 
/******************  DEFINED VARIABLES             *******************/
declare mnDAModObj = i4 with noconstant(0)
declare mnDAModRec = i4 with noconstant(0)
declare mnDAModFld = i4 with noconstant(0)
declare mnDAStart  = i4 with noconstant(1)
declare mnDAStop   = i4 with noconstant(0)
 
/******************  DECLARED SUBROUTINES          *******************/
declare CheckError(nFailed = i4) = i2 with protect
declare LogFieldModified(sFieldName = vc, sFieldType = vc, sObjValue = vc, sDBValue = vc) = null
declare me_add_price_rule(nStart = i4, nStop = i4) = null with protect
 
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
 
record request
(
1 objarray[*]
 
 
2 active_ind =  i2
2 beg_effect_dt_tm = dq8
2 client_id = f8
2 code_type_cd = f8
2 end_effect_dt_tm = dq8
2 discount_value = f8
2 health_plan_id = f8
2 operand_type_cd = f8
2 operator_type_cd= f8
2 rule_name = vc
2 updt_dt_tm = dq8
2 updt_id =  f8
 
 
)
 call echo("-ADD")
 
set mnDAStop = size(request->objArray,5)
set stat   = alterlist(reply->mod_objs[mnDAModObj]->mod_recs, mnDAModRec + (mnDAStop - mnDAStart + 1))
set reply->status_data->status = 'F'
 
call me_add_price_rule(mnDAStart, mnDAStop)
 
/*************************************************
          Subroutine to ADD PFT_VIEW
*************************************************/
subroutine me_add_price_rule(nStart, nStop)
 
declare dActiveStatusCD = f8 with noconstant(0.0), protect
declare dID             = f8 with noconstant(0.0), protect
declare i               = i4 with noconstant(0),   protect
 
set dActiveStatusCD = reqdata->active_status_cd
 
 call echo("step3")
 CALL ECHORECORD(REQUEST)
 
 
set i = nStart
while (i <= nStop)
  set dID = 0.0
 
  ;create pk if necessary
;  if (validate(request->objArray[i].rcm_charge_id, -0.00001) <= 0.0)
    ;get unique number
    select into "nl:"
      sDAPK = seq(CUST_PRICE_RULE_SEQ, nextval)"##################;rp0"
    from dual
    detail
      dID = cnvtreal(sDAPK)
    with format, counter
 call echo("dID")
 call echo(dID)
;    if (curqual = 0)
;      if (FALSE = CheckError(GEN_NBR_ERROR)) return endif
;    endif
;;  else
;    set dID = request->objArray[i].rcm_charge_id
;  endif
  ; go to END_PROGRAM
  INSERT FROM cust_price_rule C SET
   C.price_rule_id                    = dID,
   C.beg_effect_dt_tm               =  cnvtdatetime(request->objArray[i].BEG_EFFECT_DT_TM),
   C.end_effect_dt_tm               =  cnvtdatetime(request->objArray[i].END_EFFECT_DT_TM),
 
   C.active_ind			               =  1,
   C.client_id              		   = if (validate(request->objArray[i].client_id, -0.00001) != -0.00001)
                                        validate(request->objArray[i].client_id, -0.00001)
                                     else
                                        0.0
                                     endif,
 
  C.cm_price_rule_id              		   = if (validate(request->objArray[i].CM_PRICE_RULE_ID, -0.00001) != -0.00001)
                                        validate(request->objArray[i].CM_PRICE_RULE_ID, -0.00001)
                                     else
                                        0.0
                                     endif,
 
   C.code_type_cd                  = if (validate(request->objArray[i].code_type_cd, -0.00001) != -0.00001)
                                        validate(request->objArray[i].code_type_cd, -0.00001)
                                      else
                                        NULL
                                      endif,
 
   C.discount_value                  = if (validate(request->objArray[i].discount_value, -0.00001) != -0.00001)
                                        validate(request->objArray[i].discount_value, -0.00001)
                                      else
                                        NULL
                                      endif,
 
   C.operand_type_cd          		 = if (validate(request->objArray[i].OPERAND_TYPE_CD, -0.00001) != -0.00001)
                                        validate(request->objArray[i].OPERAND_TYPE_CD, -0.00001)
                                      else
                                        0.0
                                      endif,
   C.operator_type_cd        		 = if (validate(request->objArray[i].OPERATOR_TYPE_CD, -0.00001) != -0.00001)
                                        validate(request->objArray[i].OPERATOR_TYPE_CD, -0.00001)
                                      else
                                        0.0
                                      endif,
 
   C.rule_name                    = if (validate(request->objArray[i].RULE_NAME, CHAR(128)) != CHAR(128))
                                        validate(request->objArray[i].RULE_NAME, CHAR(128))
                                      else
                                        NULL
                                      endif,
 
   C.updt_dt_tm 					 =  cnvtdatetime(curdate,curtime),
   C.updt_id                         = if (validate(request->objArray[i].updt_id, -0.00001) != -0.00001)
                                        validate(request->objArray[i].updt_id, -0.00001)
                                      else
                                        NULL
                                      endif
 
 
  WITH nocounter
 
   call echoxml(request, "cust_pricerule_ins.xml")
 
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
 
