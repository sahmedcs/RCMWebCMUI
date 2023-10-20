drop program me_upt_cust_price_list:dba go
create program me_upt_cust_price_list:dba
 
/***************************************************************************************/
;~DB~**********************************************************************************
;    *                   GENERATED MODIFICATION CONTROL LOG                           *
;    **********************************************************************************
;    *                                                                                *
;    *Mod 	Date     	Engineer            Feature    Comment                        *
;    *--- 	-------- 	----------------	-------    -------------------------------*
;    *000 	                                            Initial Release
;    *001   09-MAY-23    AS013684                       Update for CUST_PRICE_LIST add *
;~DE~**********************************************************************************
 
%i me_header_ccl.inc
 
/******************  DEFINED CONSTANTS             *******************/
declare mdtDANone     = dq8 with noconstant(0.0)
declare mdtDAEnd      = dq8 with noconstant(0.0)
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
declare me_upt_cust_price_list(nStart = i4, nStop = i4) = null with protect
 
 
 call echo("Update step2")
 call echorecord(request)
 
 
;create a transaction info structure if one doesn't already exist or is zero
if (trim(cnvtstring(validate(TransInfo->trans_dt_tm,0))) = "0")
  record TransInfo
  (
  1 trans_dt_tm = dq8
  )
  set TransInfo->trans_dt_tm = cnvtdatetime(curdate, curtime3)
endif
 
;create standard reply structure if it doesn't exist
if (not(validate(reply->status_data)))
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
;
 
free record mrsStatus
record mrsStatus
(
 1 objArray[*]
   2 status = i4
   2 dAID   = f8
   2 modify_this_record = i2
)
 
 
 
set gnStat = alterlist(mrsStatus->objArray,size(request->objArray,5))
 
set mnDAStop = size(request->objArray,5)
set stat   = alterlist(reply->mod_objs[mnDAModObj]->mod_recs, mnDAModRec + (mnDAStop - mnDAStart + 1))
set reply->status_data->status = 'F'
 
 
call me_upt_cust_price_list(mnDAStart, mnDAStop)
 
/*************************************************
          Subroutine to UPT EXT_PAY_PLAN_PE_RELTN
*************************************************/
subroutine me_upt_cust_price_list(nStart, nStop)
 
declare i       = i4 with noconstant(0), protect
declare bLocked = i2 with noconstant(0), protect
 
set bLocked = FALSE
set i       = nStart
 
 
for (i = 1 to size(request->objArray,5))
  ;validate pk
  if (validate(request->objArray[i].price_list_id, -0.00001) <= 0.0)
    if (FALSE = CheckError(ATTRIBUTE_ERROR)) return endif
  endif
endfor
 
 
  ;perform SELECT FOR UPDATE and determine locking
  set bLocked = FALSE
  SELECT INTO "nl:"
    A.*
  FROM  CUST_PRICE_LIST A
      ,(dummyt dt with seq = value(size(request->objArray,5)))
  plan dt
  join A  WHERE
        A.price_list_id   = request->objArray[dt.seq].PRICE_LIST_ID
  DETAIL
    mnDAModRec = mnDAModRec + 1
    mnDAModFld = 0
    reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec].table_name = msDATableName
    reply->mod_objs[mnDAModObj]->mod_recs[mnDAModRec].pk_values  = build(A.PRICE_LIST_ID)
    call echo("-PRICElist")
    call echo(A.PRICE_LIST_ID)
    ;loop thru columns and determine what has/will change
    if (validate(request->objArray[dt.seq].PRICE_LIST_ID, A.PRICE_LIST_ID) != -0.00001
        and validate(request->objArray[dt.seq].PRICE_LIST_ID, a.PRICE_LIST_ID) !=
        A.PRICE_LIST_ID)
      call LogFieldModified("CUST_PRICE_LIST", "F8",
        build(validate(request->objArray[dt.seq].PRICE_LIST_ID, A.PRICE_LIST_ID)),
        build(A.PRICE_LIST_ID))
    endif
 
    if (validate(request->objArray[dt.seq].RECEIVER_ID, A.RECEIVER_ID) != CHAR(128)
        and validate(request->objArray[dt.seq].RECEIVER_ID, a.RECEIVER_ID) !=
        A.RECEIVER_ID)
      call LogFieldModified("receiver_id", "VC50",
        build(validate(request->objArray[dt.seq].RECEIVER_ID, A.RECEIVER_ID)),
        build(A.RECEIVER_ID))
    endif
 
  	if (validate(request->objArray[dt.seq].beg_effect_dt_tm, A.beg_effect_dt_tm) !=  0.0
        and validate(request->objArray[dt.seq].beg_effect_dt_tm, a.beg_effect_dt_tm) !=
        A.beg_effect_dt_tm)
      call LogFieldModified("beg_effect_dt_tm", "Q8",
        build(validate(request->objArray[dt.seq].beg_effect_dt_tm, A.beg_effect_dt_tm)),
        build(A.beg_effect_dt_tm))
    endif
 
   	if (validate(request->objArray[dt.seq].end_effect_dt_tm, A.end_effect_dt_tm) !=  0.0
        and validate(request->objArray[dt.seq].end_effect_dt_tm, a.end_effect_dt_tm) !=
        A.end_effect_dt_tm)
      call LogFieldModified("end_effect_dt_tm", "Q8",
        build(validate(request->objArray[dt.seq].end_effect_dt_tm, A.end_effect_dt_tm)),
        build(A.end_effect_dt_tm))
    endif
 
  	 if (validate(request->objArray[dt.seq].client_id, A.client_id) != -0.00001
        and validate(request->objArray[dt.seq].client_id, a.client_id) !=
        A.client_id)
      call LogFieldModified("CUST_PRICE_LIST", "F8",
        build(validate(request->objArray[dt.seq].client_id, A.client_id)),
        build(A.client_id))
    endif
 
  	 if (validate(request->objArray[dt.seq].code_type_cd, A.code_type_cd) != -0.00001
        and validate(request->objArray[dt.seq].code_type_cd, a.code_type_cd) !=
        A.code_type_cd)
      call LogFieldModified("CUST_PRICE_LIST", "F8",
        build(validate(request->objArray[dt.seq].code_type_cd, A.code_type_cd)),
        build(A.code_type_cd))
    endif
 
  	 if (validate(request->objArray[dt.seq].exclusion_flg , A.exclusion_flg) != -0.00001
        and validate(request->objArray[dt.seq].exclusion_flg, a.exclusion_flg) !=
        A.exclusion_flg)
      call LogFieldModified("CUST_PRICE_LIST", "F8",
        build(validate(request->objArray[dt.seq].exclusion_flg, A.exclusion_flg)),
        build(A.exclusion_flg))
    endif
 
  	 if (validate(request->objArray[dt.seq].fin_class_cd  , A.fin_class_cd) != -0.00001
        and validate(request->objArray[dt.seq].fin_class_cd, a.fin_class_cd) !=
        A.fin_class_cd)
      call LogFieldModified("CUST_PRICE_LIST", "F8",
        build(validate(request->objArray[dt.seq].fin_class_cd, A.fin_class_cd)),
        build(A.fin_class_cd))
    endif
 
    if (validate(request->objArray[dt.seq].GROSS_PRICE, A.GROSS_PRICE) != -0.00001
        and validate(request->objArray[dt.seq].GROSS_PRICE, a.GROSS_PRICE) !=
        A.GROSS_PRICE)
      call LogFieldModified("CUST_PRICE_LIST", "I4",
        build(validate(request->objArray[dt.seq].GROSS_PRICE, A.GROSS_PRICE)),
        build(A.GROSS_PRICE))
    endif
 
  	if (validate(request->objArray[dt.seq].health_plan_id , A.health_plan_id) != -0.00001
        and validate(request->objArray[dt.seq].health_plan_id, a.health_plan_id) !=
        A.health_plan_id)
      call LogFieldModified("CUST_PRICE_LIST", "I4",
        build(validate(request->objArray[dt.seq].health_plan_id, A.health_plan_id)),
        build(A.health_plan_id))
    endif
 
 
     if (validate(request->objArray[dt.seq].service_code, A.service_code) != CHAR(128)
        and validate(request->objArray[dt.seq].service_code, a.service_code) !=
        A.service_code)
      call LogFieldModified("receiver_id", "VC50",
        build(validate(request->objArray[dt.seq].service_code, A.service_code)),
        build(A.service_code))
    endif
 
 
   	if (validate(request->objArray[dt.seq].updt_dt_tm, A.updt_dt_tm) !=  0.0
        and validate(request->objArray[dt.seq].updt_dt_tm, a.updt_dt_tm) !=
        A.updt_dt_tm)
      call LogFieldModified("end_effect_dt_tm", "Q8",
        build(validate(request->objArray[dt.seq].updt_dt_tm, A.updt_dt_tm)),
        build(A.updt_dt_tm))
    endif
 
bLocked = TRUE
mrsStatus->objArray[dt.seq].modify_this_record = true
;     if (request->objArray[dt.seq].updt_id != A.updt_id and request->objArray[dt.seq].updt_id != -99999)
;    	 call echo("-block")
; 	 	 bLocked = TRUE
;     else
;     	call echo("-block2")
;	      mrsStatus->objArray[dt.seq].status = 1
;	      if(mnDAModFld > 0)
;	          mrsStatus->objArray[dt.seq].modify_this_record = true
;	      endif
;      endif
 
  WITH forupdate(A)
 
;  for (i = 1 to size(mrsStatus->objArray,5))
;    if (mrsStatus->objArray[i].status != 1)
;      call CheckError(LOCK_ERROR)
;      return
;    endif
;  endfor
 call echo("-here")
 call echo(  mrsStatus->objArray[1].modify_this_record )
call echoxml(request,"3custlist_record.xml")
 
 
  UPDATE FROM CUST_PRICE_LIST A
    ,(dummyt dt with seq = value(size(request->objArray,5)))
    SET
   A.price_list_id 					= if (validate(request->objArray[dt.seq].price_list_id, -0.00001) != -0.00001)
                                        validate(request->objArray[dt.seq].price_list_id, -0.00001)
                                      else
                                        A.price_list_id
                                        endif,
 
   A.beg_effect_dt_tm            = if (validate(request->objArray[dt.seq].beg_effect_dt_tm, 0.0) > 0.0)
                                        cnvtdatetime(validate(request->objArray[dt.seq].beg_effect_dt_tm, 0.0))
                                      else
                                        A.beg_effect_dt_tm
                                      endif,
 
   A.end_effect_dt_tm            = if (validate(request->objArray[dt.seq].end_effect_dt_tm, 0.0) > 0.0)
                                        cnvtdatetime(validate(request->objArray[dt.seq].end_effect_dt_tm, 0.0))
                                      else
                                        A.end_effect_dt_tm
                                      endif,
 
   A.active_ind			               =  1,
   A.client_id              	       = if (validate(request->objarray[dt.seq].CLIENT_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].CLIENT_ID, -0.00001)
                                     else
                                        0.0
                                     endif,
   A.code_type_cd                      = if (validate(request->objarray[dt.seq].CODE_TYPE_CD, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].CODE_TYPE_CD, -0.00001)
                                      else
                                        NULL
                                      endif,
  A.exclusion_flg                 		 = if (validate(request->objarray[dt.seq].EXCLUSION_FLG, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].EXCLUSION_FLG, -0.00001)
                                      else
                                        NULL
                                      endif,
  A.price_rule_id              		 = if (validate(request->objarray[dt.seq].PRICE_RULE_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].PRICE_RULE_ID, -0.00001)
                                      else
                                        NULL
                                      endif,
   A.fin_class_cd                   	= if (validate(request->objarray[dt.seq].FIN_CLASS_CD, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].FIN_CLASS_CD, -0.00001)
                                      else
                                        0.0
                                       endif,
 
   A.gross_price            		 = if (validate(request->objarray[dt.seq].GROSS_PRICE, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].GROSS_PRICE, -0.00001)
                                      else
                                        0.0
                                      endif ,
 
   A.health_plan_id                 = if (validate(request->objarray[dt.seq].HEALTH_PLAN_ID, -0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].HEALTH_PLAN_ID, -0.00001)
                                     else
                                       NULL
                                     endif,
   A.updt_id               			 = if (validate(request->objarray[dt.seq].UPDT_ID,-0.00001) != -0.00001)
                                        validate(request->objarray[dt.seq].UPDT_ID, -0.00001)
                                     else
                                       0.0
                                     endif,
 
   A.receiver_id                    = if (validate(request->objarray[dt.seq].RECEIVER_ID, CHAR(128)) != CHAR(128))
                                        validate(request->objarray[dt.seq].RECEIVER_ID, CHAR(128))
                                      else
                                        NULL
                                      endif,
   A.service_code                    = if (validate(request->objarray[dt.seq].SERVICE_CODE, CHAR(128)) != CHAR(128))
                                        validate(request->objarray[dt.seq].SERVICE_CODE, CHAR(128))
                                      else
                                        NULL
                                      endif,
   A.updt_dt_tm  					 =  cnvtdatetime(curdate,curtime)
 
 
    plan dt where mrsStatus->objArray[dt.seq].modify_this_record = true
    JOIN A WHERE
          A.PRICE_LIST_ID         = cnvtint( request->objArray[dt.seq].PRICE_LIST_ID)
    WITH nocounter, status(mrsStatus->objArray[dt.seq].status)
 
    for (i = 1 to size(mrsStatus->objArray,5))
      if (mrsStatus->objArray[i].status != 1)
        call echo("-err")
        call CheckError(UPDATE_ERROR)
        return
      endif
    endfor
 
    ;If we reached this point, then the routine was successful
    call echo("-succ")
    call CheckError(TRUE)
 
end ;UPT_me_upt_cust_price_list
 
 
 
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
free record mrsStatus
 
end go
