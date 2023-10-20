drop program me_insert_price_list go
create program me_insert_price_list
 
 
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
 
free record auth_activity_add_params
record price_list_add_params(
 
  1 objarray[*]
 
 	2 CM_PRICE_LIST_ID =  f8
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
 
 
free record price_list_add_req
record price_list_add_req(
 
  1 objarray[*]
 
 	2 CM_PRICE_LIST_ID =  f8
	2 active_ind =  i2
	2 beg_effect_dt_tm = vc
	2 client_id = f8
	2 code_type_cd = f8
	2 end_effect_dt_tm = vc
	2 exclusion_flg = i4
	2 fin_class_cd = f8
	2 gross_price = i4
	2 health_plan_id = f8
	;2 price_list_id = f8
	2 price_rule_id = f8
	2 receiver_id = vc
 
	2 service_code = vc
	2 updt_dt_tm = vc
	2 updt_id =  f8
 
)
 
 call echoxml(CMREQUEST, "cust_pricelist3.xml")
  set stat = alterlist(price_list_add_req->objarray,value(size(CMREQUEST->pricelist, 5)))
 
	for(rdCnt=1 to value(size(CMREQUEST->pricelist, 5)))
 
 		set price_list_add_req->objarray[rdCnt].CM_PRICE_LIST_ID = cnvtint(  CMREQUEST->pricelist[rdCnt].CM_PRICE_LIST_ID)
 		set price_list_add_req->objarray[rdCnt].active_ind = cnvtint(  CMREQUEST->pricelist[rdCnt].active_ind)
 	 	set price_list_add_req->objarray[rdCnt].beg_effect_dt_tm =  ( CMREQUEST->pricelist[rdCnt].BEG_EFF_DT_TM)
		set price_list_add_req->objarray[rdCnt].client_id =  cnvtint(CMREQUEST->pricelist[rdCnt].client_id);;todo: num
		set price_list_add_req->objarray[rdCnt].code_type_cd =  cnvtint(CMREQUEST->pricelist[rdCnt].CODE_TYPE);;todo: num
		set price_list_add_req->objarray[rdCnt].end_effect_dt_tm =  CMREQUEST->pricelist[rdCnt].END_EFF_DT_TM
		set price_list_add_req->objarray[rdCnt].exclusion_flg = cnvtint( CMREQUEST->pricelist[rdCnt].EXCLUSION_FLAG)
		set price_list_add_req->objarray[rdCnt].fin_class_cd = cnvtint( CMREQUEST->pricelist[rdCnt].FIN_CLS_CODE)
		set price_list_add_req->objarray[rdCnt].gross_price = cnvtint( CMREQUEST->pricelist[rdCnt].gross_price)
		set price_list_add_req->objarray[rdCnt].health_plan_id = cnvtint( CMREQUEST->pricelist[rdCnt].health_plan_id)
		set price_list_add_req->objarray[rdCnt].price_rule_id =  cnvtint(CMREQUEST->pricelist[rdCnt].price_rule_id)
 		set price_list_add_req->objarray[rdCnt].receiver_id =  CMREQUEST->pricelist[rdCnt].receiver_id
 		set price_list_add_req->objarray[rdCnt].service_code =  CMREQUEST->pricelist[rdCnt].service_code
		set price_list_add_req->objarray[rdCnt].updt_dt_tm =  CMREQUEST->pricelist[rdCnt].UPD_DT_TM
 
;		set price_list_add_req->objarray[rdCnt].updt_id =  cnvtint(CMREQUEST->pricelist[rdCnt].updt_id)todo: send
 
	 endfor
 
 call echoxml(price_list_add_req, "price_list_add_req.xml")
 
   execute me_add_price_list with replace("REQUEST","PRICE_LIST_ADD_REQ")
 
 
end
go
 
