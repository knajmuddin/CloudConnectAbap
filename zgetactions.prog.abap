*&---------------------------------------------------------------------*
*& Report  ZGETACTIONS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZGETACTIONS.

CONSTANTS: BEGIN OF gc_mode,
             create     TYPE   crmt_mode   VALUE   'A',
             change     TYPE   crmt_mode   VALUE   'B',
             display    TYPE   crmt_mode   VALUE   'C',
             delete     TYPE   crmt_mode   VALUE   'D',
           END OF gc_mode.


    DATA: lv_guid           TYPE crmt_object_guid,
          lr_crm_order      TYPE REF TO cl_ags_crm_1o_api,
          lt_action_list_mo TYPE /tmwflow/mo_tt_sgos_msrv,
          lwa_action_list_mo TYPE /TMWFLOW/MO_S_SGOS_MSRV,
          lv_user_status    TYPE j_estat,
          lv_bersl          TYPE tj30-bersl.
*          ls_button_info    LIKE LINE OF et_entityset.


parameters:  p_no type crmd_orderadm_h-object_id.


  select single guid into @DATA(gv_guid) from crmd_orderadm_h where object_id = @p_no.

      CALL METHOD cl_ags_crm_1o_api=>get_instance
        EXPORTING
          iv_header_guid                = gv_guid
          iv_process_mode               = gc_mode-display
        IMPORTING
*         et_msg                        =
          eo_instance                   = lr_crm_order
        EXCEPTIONS
          invalid_parameter_combination = 1
          error_occurred                = 2
          OTHERS                        = 3.
      IF sy-subrc <> 0.
* later fill response context
*    CLEAR es_return.
*    es_return-type       = sy-msgty.
*    es_return-id         = sy-msgid.
*    es_return-number     = sy-msgno.
*    es_return-message_v1 = sy-msgv1.
*    es_return-message_v2 = sy-msgv2.
*    es_return-message_v3 = sy-msgv3.
*    es_return-message_v4 = sy-msgv4.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno INTO es_return-message WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    APPEND es_return TO et_return.
        EXIT.
      ENDIF.

*** get list of possible PPF actions
      CALL METHOD lr_crm_order->get_action_list
        IMPORTING
          et_action_list_mo = lt_action_list_mo.

      LOOP at lt_action_list_mo INTO lwa_action_list_mo.
          WRITE : /  lwa_action_list_mo-name, lwa_action_list_mo-text.
      endloop.
