drop program me_pricelist_update go
create program me_pricelist_update
 
 
/***************************************************************************************/
;~DB~**********************************************************************************
;    *                   GENERATED MODIFICATION CONTROL LOG                           *
;    **********************************************************************************
;    *                                                                                *
;    *Mod 	Date     	Engineer            Feature    Comment                        *
;    *--- 	-------- 	----------------	-------    -------------------------------*
;    *000 	                                            Initial Release
;    *001   09-MAY-23                                   Update custom schema          *
;~DE~**********************************************************************************
 
prompt
	"Output to File/Printer/MINE" = "MINE"   ;* Enter or select the printer or file name to send this report to.
 
with OUTDEV
 
;declare dInboundStatusCd = f8 with constant(uar_get_code_by("DISPLAY",4002420,trim($pStatusType))), protect
 ; Not yet sure if I need this
declare iPos = i4 with noconstant(0), protect
declare iIdx = i4 with noconstant(0), protect
 
 
record updpricelistReq
(
1 objarray[*]
 
 
	2 active_ind =  i2
	2 beg_effect_dt_tm = dq8
	2 client_id = f8
	2 code_type_cd = f8
	2 end_effect_dt_tm = dq8
	2 exclusion_flg = i4
	2 fin_class_cd = f8
	2 gross_price = i4
	2 health_plan_id = f8
	2 price_list_id = f8
	2 price_rule_id = f8
	2 receiver_id = vc
 
	2 service_code = vc
	2 updt_dt_tm = dq8
	2 updt_id =  f8
 
 
)
 
 
free record updpricelistRep
record updpricelistRep
(
%i me_status_block.inc
%i cclsource:status_block.inc
)
 
 
 
 call echoxml(CMREQUEST,"4as_price_list.xml")
 
; Load rows for update
select into "nl:"
from cust_price_list aa
 
   , (dummyt d1 with seq = value(size(CMREQUEST->pricelist, 5)))
plan d1
join aa
  where aa.price_list_id = cnvtreal(CMREQUEST->pricelist[d1.seq].PRICE_LIST_ID)
    and aa.active_ind = 1
    and aa.beg_effect_dt_tm<= cnvtdatetime(curdate,curtime3)
    and aa.end_effect_dt_tm >= cnvtdatetime(curdate,curtime3)
 
head report
  qCnt = 0
detail
  qCnt = qCnt+1
  stat = alterlist(updpricelistReq->objArray,qCnt)
  updpricelistReq->objArray[qCnt].price_list_id = aa.price_list_id
  updpricelistReq->objArray[qCnt].active_ind = aa.active_ind
  updpricelistReq->objArray[qCnt].beg_effect_dt_tm = aa.beg_effect_dt_tm
  updpricelistReq->objArray[qCnt].client_id = aa.client_id
  updpricelistReq->objArray[qCnt].code_type_cd = aa.code_type_cd
  updpricelistReq->objArray[qCnt].end_effect_dt_tm = aa.end_effect_dt_tm
  updpricelistReq->objArray[qCnt].exclusion_flg = aa.exclusion_flg
  updpricelistReq->objArray[qCnt].fin_class_cd = aa.fin_class_cd
  updpricelistReq->objArray[qCnt].gross_price = aa.gross_price
  updpricelistReq->objArray[qCnt].health_plan_id = aa.health_plan_id
  updpricelistReq->objArray[qCnt].price_rule_id = aa.price_rule_id
  updpricelistReq->objArray[qCnt].receiver_id = aa.receiver_id
  updpricelistReq->objArray[qCnt].service_code = aa.service_code
  updpricelistReq->objArray[qCnt].updt_id= aa.updt_id
  updpricelistReq->objArray[qCnt].updt_dt_tm = aa.updt_dt_tm
 
foot report
  null
with nocounter
 
call echoxml(updpricelistReq,"1as_authdata_record.xml")
 
 ; Update relevavant data for update
 
for(aCnt=1 to size(CMREQUEST->pricelist,5))
 
 
 
  ; Find the location of this orderID in the updpricelistReq->objArray record
  set iPos = locateval(iIdx,1,size(updpricelistReq->objArray,5)
   	   ,cnvtreal(CMREQUEST->pricelist[aCnt].PRICE_LIST_ID),updpricelistReq->objArray[iIdx].price_list_id)
 
  ; Populate the record for update
  if(iPos > 0)
 
 
        set updpricelistReq->objArray[iPos].beg_effect_dt_tm =
          cnvtdatetime(cnvtdate2(CMREQUEST->pricelist[1].BEG_EFF_DT_TM,"DD/MM/YYYY")
                            ,cnvttime2(substring(12,5,CMREQUEST->pricelist[1].BEG_EFF_DT_TM), "HH:MM"))
 
        set updpricelistReq->objArray[iPos].end_effect_dt_tm =
            cnvtdatetime(cnvtdate2(CMREQUEST->pricelist[1].END_EFF_DT_TM,"DD/MM/YYYY")
                            ,cnvttime2(substring(12,5,CMREQUEST->pricelist[1].END_EFF_DT_TM), "HH:MM"))
 
        set updpricelistReq->objArray[iPos].active_ind = cnvtint(CMREQUEST->pricelist[aCnt].active_ind)
        set updpricelistReq->objArray[iPos].client_id = cnvtint(CMREQUEST->pricelist[aCnt].CLIENT_ID)
        set updpricelistReq->objArray[iPos].code_type_cd = cnvtint(CMREQUEST->pricelist[aCnt].code_type)
        set updpricelistReq->objArray[iPos].exclusion_flg =cnvtint( CMREQUEST->pricelist[aCnt].EXCLUSION_FLAG)
        set updpricelistReq->objArray[iPos].fin_class_cd = cnvtint( CMREQUEST->pricelist[aCnt].FIN_CLS_CODE)
    	set updpricelistReq->objArray[iPos].gross_price = cnvtint( CMREQUEST->pricelist[aCnt].gross_price)
        set updpricelistReq->objArray[iPos].health_plan_id = cnvtint( CMREQUEST->pricelist[aCnt].health_plan_id)
        set updpricelistReq->objArray[iPos].price_rule_id = cnvtint( CMREQUEST->pricelist[aCnt].price_rule_id)
        set updpricelistReq->objArray[iPos].receiver_id =  CMREQUEST->pricelist[aCnt].receiver_id
    	set updpricelistReq->objArray[iPos].service_code =  CMREQUEST->pricelist[aCnt].service_code
 	    set updpricelistReq->objArray[iPos].updt_dt_tm = cnvtdatetime(curdate,curtime)
 
  endif
endfor
 
 
call echoxml(updpricelistReq,"2updpricelistReq_record.xml")
 
  call echo("-size")
 call echo(size(updpricelistReq->objArray,5))
 
execute me_upt_cust_price_list with replace("REQUEST",updpricelistReq)  , replace("REPLY",updpricelistRep)
 
;go to exit_script
 
 
if(updpricelistRep->status_data.status = "F")
  call echo("Update to auth pricelist failed")
  rollback
elseif(updpricelistRep->status_data.status = "S")
  commit
endif
 
#exit_script
 
end
go
