 IF ((validate (false ,0 ) = 0 )
 AND (validate (false ,1 ) = 1 ) )
  DECLARE false = i2 WITH public ,constant (0 )
 ENDIF
 IF ((validate (true ,0 ) = 0 )
 AND (validate (true ,1 ) = 1 ) )
  DECLARE true = i2 WITH public ,constant (1 )
 ENDIF
 IF ((validate (gen_nbr_error ,0 ) = 0 )
 AND (validate (gen_nbr_error ,1 ) = 1 ) )
  DECLARE gen_nbr_error = i2 WITH public ,constant (3 )
 ENDIF
 IF ((validate (insert_error ,0 ) = 0 )
 AND (validate (insert_error ,1 ) = 1 ) )
  DECLARE insert_error = i2 WITH public ,constant (4 )
 ENDIF
 IF ((validate (update_error ,0 ) = 0 )
 AND (validate (update_error ,1 ) = 1 ) )
  DECLARE update_error = i2 WITH public ,constant (5 )
 ENDIF
 IF ((validate (replace_error ,0 ) = 0 )
 AND (validate (replace_error ,1 ) = 1 ) )
  DECLARE replace_error = i2 WITH public ,constant (6 )
 ENDIF
 IF ((validate (delete_error ,0 ) = 0 )
 AND (validate (delete_error ,1 ) = 1 ) )
  DECLARE delete_error = i2 WITH public ,constant (7 )
 ENDIF
 IF ((validate (undelete_error ,0 ) = 0 )
 AND (validate (undelete_error ,1 ) = 1 ) )
  DECLARE undelete_error = i2 WITH public ,constant (8 )
 ENDIF
 IF ((validate (remove_error ,0 ) = 0 )
 AND (validate (remove_error ,1 ) = 1 ) )
  DECLARE remove_error = i2 WITH public ,constant (9 )
 ENDIF
 IF ((validate (attribute_error ,0 ) = 0 )
 AND (validate (attribute_error ,1 ) = 1 ) )
  DECLARE attribute_error = i2 WITH public ,constant (10 )
 ENDIF
 IF ((validate (lock_error ,0 ) = 0 )
 AND (validate (lock_error ,1 ) = 1 ) )
  DECLARE lock_error = i2 WITH public ,constant (11 )
 ENDIF
 IF ((validate (none_found ,0 ) = 0 )
 AND (validate (none_found ,1 ) = 1 ) )
  DECLARE none_found = i2 WITH public ,constant (12 )
 ENDIF
 IF ((validate (select_error ,0 ) = 0 )
 AND (validate (select_error ,1 ) = 1 ) )
  DECLARE select_error = i2 WITH public ,constant (13 )
 ENDIF
 IF ((validate (update_cnt_error ,0 ) = 0 )
 AND (validate (update_cnt_error ,1 ) = 1 ) )
  DECLARE update_cnt_error = i2 WITH public ,constant (14 )
 ENDIF
 IF ((validate (not_found ,0 ) = 0 )
 AND (validate (not_found ,1 ) = 1 ) )
  DECLARE not_found = i2 WITH public ,constant (15 )
 ENDIF
 IF ((validate (inactivate_error ,0 ) = 0 )
 AND (validate (inactivate_error ,1 ) = 1 ) )
  DECLARE inactivate_error = i2 WITH public ,constant (17 )
 ENDIF
 IF ((validate (activate_error ,0 ) = 0 )
 AND (validate (activate_error ,1 ) = 1 ) )
  DECLARE activate_error = i2 WITH public ,constant (18 )
 ENDIF
 IF ((validate (uar_error ,0 ) = 0 )
 AND (validate (uar_error ,1 ) = 1 ) )
  DECLARE uar_error = i2 WITH public ,constant (20 )
 ENDIF
 IF ((validate (pft_failed ,0 ) = 0 )
 AND (validate (pft_failed ,1 ) = 1 ) )
  DECLARE pft_failed = i2 WITH public ,noconstant (false )
 ENDIF
 IF ((validate (table_name ,"X" ) = "X" )
 AND (validate (table_name ,"Z" ) = "Z" ) )
  DECLARE table_name = vc WITH public ,noconstant (" " )
 ENDIF
 IF ((validate (call_echo_ind ,0 ) = 0 )
 AND (validate (call_echo_ind ,1 ) = 1 ) )
  DECLARE call_echo_ind = i2 WITH public ,noconstant (false )
 ENDIF
 IF ((validate (failed ,0 ) = 0 )
 AND (validate (failed ,1 ) = 1 ) )
  DECLARE failed = i2 WITH public ,noconstant (false )
 ENDIF
 

