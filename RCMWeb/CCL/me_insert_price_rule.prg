drop program me_insert_price_rule go
create program me_insert_price_rule
 
 
/**************************************************************
; DVDev DECLARED SUBROUTINES
**************************************************************/
 
/**************************************************************
; DVDev DECLARED VARIABLES
**************************************************************/
 
/**************************************************************
; DVDev Start Coding
**************************************************************/
 
 
;    Your Code Goes Here
 
 
/**************************************************************
; DVDev DEFINED SUBROUTINES
**************************************************************/
free record price_rule_add_req
record price_rule_add_req(
 
  1 objarray[*]
 
 	2 CM_PRICE_RULE_ID = f8
	2 active_ind =  i2
	2 beg_effect_dt_tm = vc
	2 client_id = f8
	2 code_type_cd = f8
	2 end_effect_dt_tm = vc
	2 discount_value = f8
	;2 health_plan_id = f8
	2 operand_type_cd = f8
	2 operator_type_cd= f8
	2 rule_name = vc
;	2 updt_dt_tm = vc
	2 updt_id =  f8
 
)
 
 
 call echoxml(CMREQUEST, "cust_price_rule2.xml")
 
   set stat = alterlist(price_rule_add_req->objarray,value(size(CMREQUEST->price_rule, 5)))
	for(rdCnt=1 to  value( size(CMREQUEST->price_rule, 5)))
 
 
 		set price_rule_add_req->objarray[rdCnt].CM_PRICE_RULE_ID = cnvtint( CMREQUEST->price_rule[rdCnt].CM_PRICE_RULE_ID)
		set price_rule_add_req->objarray[rdCnt].active_ind =  CMREQUEST->price_rule[rdCnt].active_ind
		set price_rule_add_req->objarray[rdCnt].beg_effect_dt_tm =  CMREQUEST->price_rule[rdCnt].BEG_EFF_DT_TM
		set price_rule_add_req->objarray[rdCnt].client_id = cnvtint( CMREQUEST->price_rule[rdCnt].client_id)
		set price_rule_add_req->objarray[rdCnt].end_effect_dt_tm =  CMREQUEST->price_rule[rdCnt].END_EFF_DT_TM
		set price_rule_add_req->objarray[rdCnt].code_type_cd = cnvtint( CMREQUEST->price_rule[rdCnt].code_type_cd)
		set price_rule_add_req->objarray[rdCnt].discount_value = cnvtint( CMREQUEST->price_rule[rdCnt].discount_value)
		set price_rule_add_req->objarray[rdCnt].operand_type_cd = cnvtint(CMREQUEST->price_rule[rdCnt].OPERAND_TYPE_CD)
 		set price_rule_add_req->objarray[rdCnt].operator_type_cd=cnvtint(CMREQUEST->price_rule[rdCnt].OPERATOR_TYPE_CD)
 		set price_rule_add_req->objarray[rdCnt].rule_name =  CMREQUEST->price_rule[rdCnt].rule_name
;		set price_rule_add_req->objarray[rdCnt].updt_dt_tm =  CMREQUEST->price_rule[rdCnt].updt_dt_tm
		set price_rule_add_req->objarray[rdCnt].updt_id = cnvtint(CMREQUEST->price_rule[rdCnt].UPD_ID)
 
	 endfor
 
call echoxml(price_rule_add_req, "price_rule_add_req.xml")
 
  execute  me_add_price_rule with replace("REQUEST","PRICE_RULE_ADD_REQ")
 
 
end
go
 
