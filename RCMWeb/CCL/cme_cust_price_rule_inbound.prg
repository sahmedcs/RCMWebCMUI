/*************************************************************************
  *                                                                      *
  *  Copyright Notice:  (c) 1983 Laboratory Information Systems &        *
  *                              Technology, Inc.                        *
  *       Revision      (c) 1984-1997 Cerner Corporation                 *
  *                                                                      *
  *  Cerner (R) Proprietary Rights Notice:  All rights reserved.         *
  *  This material contains the valuable properties and trade secrets of *
  *  Cerner Corporation of Kansas City, Missouri, United States of       *
  *  America (Cerner), embodying substantial creative efforts and        *
  *  confidential information, ideas and expressions, no part of which   *
  *  may be reproduced or transmitted in any form ori  by any means, or  *
  *  retained in any storage or retrieval system without the express     *
  *  written permission of Cerner.                                       *
  *                                                                      *
  *  Cerner is a registered mark of Cerner Corporation.                  *
  *                                                                      *
  ~BE~*******************************************************************/
/*************************************************************************
 
        Source file name:       minh_ae_eauth_response_inbound.prg
        Object name:            minh_ae_eauth_response_inbound
 
       	Program purpose:		To receive the response JSON from RCM
 
        Executing from:			Powerchart
 
        Special Notes:
 
***************************************************************************************/
;~DB~**********************************************************************************
;    *                   GENERATED MODIFICATION CONTROL LOG                           *
;    **********************************************************************************
;    *                                                                                *
;    *Mod 	Date     	Engineer            Feature    Comment                        *
;    *--- 	-------- 	----------------	-------    -------------------------------*
;    *000 	26/12/22 	SJ080356         	000001     SR 446866581, Intial Release  *
;~DE~**********************************************************************************
;~END~ ************************  END OF ALL MODCONTROL BLOCKS  ************************/
drop program cme_cust_price_rule_inbound:dba go
create program cme_cust_price_rule_inbound:dba
 
prompt
	"sMyJSON" = ""
 
with sMyJSON
 
 
;call echoxml(request, "cer_temp:testreqxml.xml")
declare inputJson 		= vc with protect
declare jsonResponse 	= vc with protect
 
 
/**************************************************************
; Record Structures
**************************************************************/
free record rError
record rError
(
	1 response_code = i4
	1 response_description = vc
	1 response_status = vc
)
 
 
 
free record authdata
record authdata
(
 
1 price_rule[*]
 
 	2 CM_PRICE_RULE_ID = f8
	2 PRICE_RULE_ID = f8
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
;	2 updt_dt_tm = dq8
	2 updt_id =  f8
 
)
 
   FREE RECORD record_data
 RECORD record_data (
 	1 price_rule_out [*]
 		2 cust_price_rule_id = f8
 	)
;set inputJson = build2('{"CMREQUEST":',trim(replace(request->params,"'","")),'}')
;
;set stat = cnvtjsontorec(inputJson)
 
set stat = cnvtjsontorec( $sMyJSON)
call echoxml(CMREQUEST, "cust_pricerule.xml")
 
	if( CMREQUEST->price_rule[1].action = "INS" )
		execute me_insert_price_rule
 
	elseif( CMREQUEST->price_rule[1].action = "UPD" )
		execute me_pricerule_update
	endif
 
 if( CMREQUEST->price_rule[1].action = "INS" )
 
  set  cnt = 0
  for (x=1 to  size (CMREQUEST->price_rule ,5 ))
	 select into "nl:"
	 from cust_price_rule cpl
	 ;where cpl.price_rule_id in ( 141.00,301.00	)
	  where cpl.cm_price_rule_id in ( cnvtint(CMREQUEST->price_rule[x].CM_PRICE_RULE_ID))
	  HEAD REPORT
	   cnt = cnt
	 HEAD cpl.price_rule_id
	 		cnt +=1 ,
	   IF (cnt > size (record_data->price_rule_out ,5 ) )
	   		 stat = alterlist (record_data->price_rule_out ,cnt )
	   ENDIF
	  DETAIL
	   record_data->price_rule_out[cnt ].cust_price_rule_id = cpl.price_rule_id
	  FOOT REPORT
		stat = alterlist(RECORD_DATA->price_rule_out,cnt)
	with nocounter
   endfor
 endif
 
set rError->response_Code = 1
set rError->response_Description = cnvtrectojson( RECORD_DATA) ;CMREQUEST->price_rule[1].CM_PRICE_RULE_ID;
;cnvtstring( size(CMREQUEST->price_rule, 5));$sMyJSON;"Response updated successfully"
set rError->response_Status = "Success"
 
 
#exit_script
set jsonResponse = CNVTRECTOJSON(rError,9)
set _MEMORY_REPLY_STRING = jsonResponse
 
end
go
 
