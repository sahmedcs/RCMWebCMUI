drop program me_pricerule_update go
create program me_pricerule_update
 
 
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
declare pricelist_status = vc
declare approval_number  = vc
 
;free record updpriceruleReq
;record updpriceruleReq(
;1 objArray[*]
; 2 auth_pricelist_id = f8
; ;2 active_ind = i2
; 2 pricelist_comments = vc
; 2 pricelist_response = vc
; 2 approval_end_dt_tm = dq8
; 2 approval_start_dt_tm = dq8
; 2 auth_attachment = vc
; ;2 beg_effective_dt_tm = dq8
; 2 denial_code = vc
; ;2 end_effective_dt_tm = dq8
; 2 order_id = f8
; 2 pat_share = f8
; 2 payment_amount = f8
; 2 quantity = i4
; ;2 transaction_id = vc
; 2 updt_cnt = i4
;
;  2 approval_number = vc
;  2 summary_comment = vc
;  2 auth_summary_id = f8
;)
 
record updpriceruleReq
(
1 objarray[*]
 
	2 price_rule_id = f8
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
 
 
free record updpricelistRep
record updpricelistRep
(
%i me_status_block.inc
%i cclsource:status_block.inc
)
 
 
 
 call echoxml(CMREQUEST,"4as_price_list.xml")
 
; Load rows for update
select into "nl:"
from cust_price_rule aa
 
   , (dummyt d1 with seq = value(size(CMREQUEST->price_rule, 5)))
plan d1
join aa
  where aa.price_rule_id = cnvtreal(CMREQUEST->price_rule[d1.seq].price_rule_id)
    and aa.active_ind = 1
    and aa.beg_effect_dt_tm <= cnvtdatetime(curdate,curtime3)
    and aa.end_effect_dt_tm >= cnvtdatetime(curdate,curtime3)
 
head report
  qCnt = 0
detail
  qCnt = qCnt+1
  stat = alterlist(updpriceruleReq->objArray,qCnt)
  updpriceruleReq->objArray[qCnt].price_rule_id = aa.price_rule_id
  updpriceruleReq->objArray[qCnt].active_ind = aa.active_ind
  updpriceruleReq->objArray[qCnt].beg_effect_dt_tm = aa.beg_effect_dt_tm
  updpriceruleReq->objArray[qCnt].client_id = aa.client_id
  updpriceruleReq->objArray[qCnt].code_type_cd = aa.code_type_cd
  updpriceruleReq->objArray[qCnt].end_effect_dt_tm = aa.end_effect_dt_tm
  updpriceruleReq->objArray[qCnt].discount_value = aa.discount_value;cnvtdatetime(aa.approval_start_dt_tm)
 
  updpriceruleReq->objArray[qCnt].health_plan_id = aa.health_plan_id
  updpriceruleReq->objArray[qCnt].operand_type_cd = aa.operand_type_cd
  updpriceruleReq->objArray[qCnt].operator_type_cd = aa.operator_type_cd
  updpriceruleReq->objArray[qCnt].rule_name = aa.rule_name
  updpriceruleReq->objArray[qCnt].updt_id= aa.updt_id
  updpriceruleReq->objArray[qCnt].updt_dt_tm = aa.updt_dt_tm
 
foot report
  null
with nocounter
 
call echoxml(updpriceruleReq,"1as_authdata_record.xml")
 
 ; Update relevavant data for update
for(aCnt=1 to size(CMREQUEST->price_rule,5))
 
 
 
  ; Find the location of this orderID in the updpriceruleReq->objArray record
  set iPos = locateval(iIdx,1,size(updpriceruleReq->objArray,5)
   	   ,cnvtreal(CMREQUEST->price_rule[aCnt].price_rule_id),updpriceruleReq->objArray[iIdx].price_rule_id)
 
 
  ; Populate the record for update
  if(iPos > 0)
 
 
        set updpriceruleReq->objArray[iPos].beg_effect_dt_tm =
          cnvtdatetime(cnvtdate2(CMREQUEST->price_rule[1].BEG_EFF_DT_TM,"DD/MM/YYYY")
                            ,cnvttime2(substring(12,5,CMREQUEST->price_rule[1].BEG_EFF_DT_TM), "HH:MM"))
 
        set updpriceruleReq->objArray[iPos].end_effect_dt_tm =
            cnvtdatetime(cnvtdate2(CMREQUEST->price_rule[1].END_EFF_DT_TM,"DD/MM/YYYY")
                            ,cnvttime2(substring(12,5,CMREQUEST->price_rule[1].END_EFF_DT_TM), "HH:MM"))
 
        set updpriceruleReq->objArray[iPos].active_ind = cnvtint(CMREQUEST->price_rule[aCnt].ACTIVE_IND)
        set updpriceruleReq->objArray[iPos].client_id = cnvtint(CMREQUEST->price_rule[aCnt].client_id)
        set updpriceruleReq->objArray[iPos].code_type_cd  = cnvtint(CMREQUEST->price_rule[aCnt].code_type_cd)
        set updpriceruleReq->objArray[iPos].discount_value  = cnvtint(CMREQUEST->price_rule[aCnt].discount_value)
        set updpriceruleReq->objArray[iPos].operand_type_cd  =cnvtint( CMREQUEST->price_rule[aCnt].operand_type_cd)
        set updpriceruleReq->objArray[iPos].operator_type_cd  =  cnvtint(CMREQUEST->price_rule[aCnt].operator_type_cd)
    	set updpriceruleReq->objArray[iPos].rule_name  =  CMREQUEST->price_rule[aCnt].rule_name
        set updpriceruleReq->objArray[iPos].health_plan_id = cnvtint( CMREQUEST->price_rule[aCnt].health_plan_id)
 
 	    set updpriceruleReq->objArray[iPos].updt_dt_tm = cnvtdatetime(curdate,curtime)
 	    set updpriceruleReq->objArray[iPos].updt_id = cnvtint(CMREQUEST->price_rule[aCnt].UPD_ID)
  endif
endfor
 
 
call echoxml(updpriceruleReq,"2updpriceruleReq_record.xml")
 
 
 
execute me_upt_cust_price_rule with replace("REQUEST",updpriceruleReq)  , replace("REPLY",updpricelistRep)
 
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
