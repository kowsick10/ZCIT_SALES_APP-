CLASS lhc_SalesOrderHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrderHdr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR SalesOrderHdr RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE SalesOrderHdr.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrderHdr.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrderHdr.

    METHODS read FOR READ
      IMPORTING keys FOR READ SalesOrderHdr RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK SalesOrderHdr.

    METHODS rba_Salesitem FOR READ
      IMPORTING keys_rba FOR READ SalesOrderHdr\_Salesitem FULL result_requested RESULT result LINK association_links.

    METHODS cba_Salesitem FOR MODIFY
      IMPORTING entities_cba FOR CREATE SalesOrderHdr\_Salesitem.

ENDCLASS.

CLASS lhc_SalesOrderHdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD create.
    DATA: ls_sales_hdr TYPE zcit_so_hdr_083.
    DATA: ls_util_hdr  TYPE zmk_vbak_t.
    DATA lo_util TYPE REF TO zcit_so_util_083.

    LOOP AT entities INTO DATA(ls_entities).
      ls_sales_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_hdr-salesdocument IS NOT INITIAL.
        SELECT SINGLE FROM zcit_so_hdr_083 FIELDS * WHERE salesdocument = @ls_sales_hdr-salesdocument
          INTO @DATA(ls_existing_hdr).

        IF sy-subrc NE 0.
          lo_util = zcit_so_util_083=>get_instance( ).
          ls_util_hdr = CORRESPONDING #( ls_sales_hdr ).

          lo_util->set_hdr_value(
            EXPORTING im_sales_hdr = ls_util_hdr
            IMPORTING ex_created   = DATA(lv_created)
          ).

          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid = ls_entities-%cid
                            salesdocument = ls_sales_hdr-salesdocument ) TO mapped-salesorderhdr.

            APPEND VALUE #( %cid = ls_entities-%cid
                            salesdocument = ls_sales_hdr-salesdocument
                            %msg = new_message_with_text( text     = 'Sales Order Creation Successful'
                                                          severity = if_abap_behv_message=>severity-success )
                          ) TO reported-salesorderhdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entities-%cid
                          salesdocument = ls_sales_hdr-salesdocument ) TO failed-salesorderhdr.

          APPEND VALUE #( %cid = ls_entities-%cid
                          salesdocument = ls_sales_hdr-salesdocument
                          %msg = new_message_with_text( text     = 'Duplicate Sales Order'
                                                        severity = if_abap_behv_message=>severity-error )
                        ) TO reported-salesorderhdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_sales_hdr TYPE zcit_so_hdr_083.
    DATA: ls_util_hdr  TYPE zmk_vbak_t.
    DATA lo_util TYPE REF TO zcit_so_util_083.

    LOOP AT entities INTO DATA(ls_entities).
      ls_sales_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_hdr-salesdocument IS NOT INITIAL.
        SELECT SINGLE FROM zcit_so_hdr_083 FIELDS * WHERE salesdocument = @ls_sales_hdr-salesdocument
          INTO @DATA(ls_existing_hdr).

        IF sy-subrc EQ 0.
          lo_util = zcit_so_util_083=>get_instance( ).
          ls_util_hdr = CORRESPONDING #( ls_sales_hdr ).

          lo_util->set_hdr_value(
            EXPORTING im_sales_hdr = ls_util_hdr
            IMPORTING ex_created   = DATA(lv_created)
          ).

          IF lv_created EQ abap_true.
            APPEND VALUE #( %tky = ls_entities-%tky
                            %msg = new_message_with_text( text     = 'Sales Order Updation Successful'
                                                          severity = if_abap_behv_message=>severity-success )
                          ) TO reported-salesorderhdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %tky = ls_entities-%tky ) TO failed-salesorderhdr.
          APPEND VALUE #( %tky = ls_entities-%tky
                          %msg = new_message_with_text( text     = 'Sales Order Not Found!'
                                                        severity = if_abap_behv_message=>severity-error )
                        ) TO reported-salesorderhdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_sales_hdr,
             salesdocument TYPE zcit_so_hdr_083-salesdocument,
           END OF ty_sales_hdr.

    DATA ls_sales_hdr TYPE ty_sales_hdr.
    DATA lo_util TYPE REF TO zcit_so_util_083.
    lo_util = zcit_so_util_083=>get_instance( ).

    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_sales_hdr.
      ls_sales_hdr-salesdocument = ls_key-salesdocument.

      lo_util->set_hdr_t_deletion( EXPORTING im_sales_doc = ls_sales_hdr ).
      lo_util->set_hdr_deletion_flag( EXPORTING im_so_delete = abap_true ).

      APPEND VALUE #( %tky = ls_key-%tky
                      %msg = new_message_with_text( text     = 'Order Deletion Successful'
                                                    severity = if_abap_behv_message=>severity-success )
                    ) TO reported-salesorderhdr.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zcit_so_hdr_083 FIELDS * WHERE salesdocument = @ls_key-salesdocument
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Salesitem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zcit_so_itm_083 FIELDS * WHERE salesdocument = @ls_key-salesdocument
        INTO TABLE @DATA(lt_items).

      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.
        APPEND VALUE #( source-salesdocument   = ls_key-salesdocument
                        target-salesdocument   = ls_item-salesdocument
                        target-salesitemnumber = ls_item-salesitemnumber ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Salesitem.
    DATA: ls_sales_itm TYPE zcit_so_itm_083.
    DATA lo_util TYPE REF TO zcit_so_util_083.

    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      LOOP AT ls_entities_cba-%target INTO DATA(ls_target).
        ls_sales_itm = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).

        IF ls_sales_itm-salesdocument IS NOT INITIAL AND ls_sales_itm-salesitemnumber IS NOT INITIAL.
          SELECT SINGLE FROM zcit_so_itm_083 FIELDS * WHERE salesdocument   = @ls_sales_itm-salesdocument
              AND salesitemnumber = @ls_sales_itm-salesitemnumber
            INTO @DATA(ls_existing_itm).

          IF sy-subrc NE 0.
            lo_util = zcit_so_util_083=>get_instance( ).
            lo_util->set_itm_value(
              EXPORTING im_sales_itm = ls_sales_itm
              IMPORTING ex_created   = DATA(lv_created)
            ).

            IF lv_created EQ abap_true.
              APPEND VALUE #( %cid            = ls_target-%cid
                              salesdocument   = ls_sales_itm-salesdocument
                              salesitemnumber = ls_sales_itm-salesitemnumber ) TO mapped-salesorderitm.

              APPEND VALUE #( %cid            = ls_target-%cid
                              salesdocument   = ls_sales_itm-salesdocument
                              %msg = new_message_with_text( text     = 'Sales Item Creation Successful'
                                                            severity = if_abap_behv_message=>severity-success )
                            ) TO reported-salesorderitm.
            ENDIF.
          ELSE.
            APPEND VALUE #( %cid            = ls_target-%cid
                            salesdocument   = ls_sales_itm-salesdocument
                            salesitemnumber = ls_sales_itm-salesitemnumber ) TO failed-salesorderitm.

            APPEND VALUE #( %cid            = ls_target-%cid
                            salesdocument   = ls_sales_itm-salesdocument
                            %msg = new_message_with_text( text     = 'Duplicate Sales Item'
                                                          severity = if_abap_behv_message=>severity-error )
                          ) TO reported-salesorderitm.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
