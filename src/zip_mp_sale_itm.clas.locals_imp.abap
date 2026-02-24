CLASS lhc_SalesOrderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrderItm.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrderItm.

    METHODS read FOR READ
      IMPORTING keys FOR READ SalesOrderItm
      RESULT result.

    METHODS rba_Salesheader FOR READ
      IMPORTING keys_rba FOR READ SalesOrderItm\_Salesheader
      FULL result_requested
      RESULT result
      LINK association_links.
ENDCLASS.

CLASS lhc_SalesOrderItem IMPLEMENTATION.

  METHOD update.
    DATA: ls_sales_itm TYPE zcit_so_itm_083.
    DATA(lo_util) = zcit_so_util_083=>get_instance( ).

    LOOP AT entities INTO DATA(ls_entities).
      ls_sales_itm = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_itm-salesdocument IS NOT INITIAL.
        SELECT SINGLE FROM zcit_so_itm_083
          FIELDS * WHERE salesdocument   = @ls_sales_itm-salesdocument
                     AND salesitemnumber = @ls_sales_itm-salesitemnumber
          INTO @DATA(ls_existing_itm).

        IF sy-subrc EQ 0.
          lo_util->set_itm_value(
            EXPORTING im_sales_itm = ls_sales_itm
            IMPORTING ex_created   = DATA(lv_created)
          ).

          IF lv_created EQ abap_true.
            APPEND VALUE #( %tky = ls_entities-%tky
                            %msg = new_message( id       = 'ZMK_SALES_MSG'
                                                number   = 001
                                                v1       = 'Sales Item Updation Successful'
                                                severity = if_abap_behv_message=>severity-success )
                          ) TO reported-salesorderitm.
          ENDIF.

        ELSE.
          APPEND VALUE #( %tky = ls_entities-%tky ) TO failed-salesorderitm.
          APPEND VALUE #( %tky = ls_entities-%tky
                          %msg = new_message( id       = 'ZMK_SALES_MSG'
                                              number   = 001
                                              v1       = 'Sales Order Item Not Found'
                                              severity = if_abap_behv_message=>severity-error )
                        ) TO reported-salesorderitm.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_sales_item,
             salesdocument   TYPE zcit_so_itm_083-salesdocument,
             salesitemnumber TYPE zcit_so_itm_083-salesitemnumber,
           END OF ty_sales_item.

    DATA: ls_sales_itm TYPE ty_sales_item.
    DATA(lo_util) = zcit_so_util_083=>get_instance( ).

    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_sales_itm.
      ls_sales_itm-salesdocument   = ls_key-salesdocument.
      ls_sales_itm-salesitemnumber = ls_key-salesitemnumber.

      lo_util->set_itm_t_deletion( im_sales_itm_info = ls_sales_itm ).

      APPEND VALUE #( %tky = ls_key-%tky
                      %msg = new_message( id       = 'ZMK_SALES_MSG'
                                          number   = 001
                                          v1       = 'Sales Item Deletion Successful'
                                          severity = if_abap_behv_message=>severity-success )
                    ) TO reported-salesorderitm.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    " Implementation for read (optional for transactional flow if not explicitly called)
  ENDMETHOD.

  METHOD rba_Salesheader.
    " Implementation for Read by Association (optional)
  ENDMETHOD.

ENDCLASS.
