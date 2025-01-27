CLASS lsc_yrap_i_cds_demo DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_yrap_i_cds_demo IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_log TYPE STANDARD TABLE OF ydb_log.

    IF create-demo_booking IS NOT INITIAL.

    ELSEIF update-demo_booking IS NOT INITIAL.

      LOOP AT update-demo_booking INTO DATA(ls_update).
        TRY.
            APPEND VALUE #( book_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( )
                            operation = 'UPDATE'
                            changed_by = sy-uname
                            changed_at = sy-datum ) TO lt_log.
          CATCH cx_uuid_error.  "handle exception
        ENDTRY.
      ENDLOOP.
      INSERT ydb_log FROM TABLE @lt_log.

    ELSEIF delete-demo_booking IS NOT INITIAL.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_YRAP_I_CDS_DEMO DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR demo_booking RESULT result.
    METHODS validate_data FOR VALIDATE ON SAVE
      IMPORTING keys FOR demo_booking~validate_data.
    METHODS determine_data FOR DETERMINE ON SAVE
      IMPORTING keys FOR demo_booking~determine_data.
    METHODS actionstatus FOR MODIFY
      IMPORTING keys FOR ACTION demo_booking~actionstatus.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR demo_booking RESULT result.

    METHODS actioninactive FOR MODIFY
      IMPORTING keys FOR ACTION demo_booking~actioninactive.
*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE demo_booking.

ENDCLASS.

CLASS lhc_YRAP_I_CDS_DEMO IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD earlynumbering_create.
*
*    SELECT MAX( book_id )
*    FROM yrap_demo1
*    INTO @DATA(lv_book_id).
*    lv_book_id = lv_book_id + 1.
*    CONDENSE lv_book_id.
*
*    LOOP AT entities INTO DATA(ls_entities).
*      mapped-demo_booking = VALUE #( ( %cid = ls_entities-%cid
*                                       bookid = lv_book_id
*                              ) ).
*    ENDLOOP.

*    LOOP AT entities INTO DATA(ls_entities).
*      TRY.
*          mapped-demo_booking = VALUE #( ( %cid = ls_entities-%cid
*                                      bookid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ) ).
*        CATCH cx_uuid_error.
*      ENDTRY.
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD validate_data.

    READ ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
         ENTITY demo_booking
     ALL FIELDS WITH VALUE #( ( %key-bookid = keys[ 1 ]-%key-bookid )  )
     RESULT   DATA(lt_result)
     FAILED   DATA(lt_failed)
     REPORTED DATA(lt_reported).

* Validate and Populate Error
    LOOP AT lt_Result INTO DATA(ls_result).
      IF ls_result-bookdate < sy-datum.

        failed-demo_booking = VALUE #( ( %key-bookid = ls_result-%key-bookid ) ).

        reported-demo_booking = VALUE #(
        ( %key-bookid = ls_result-%key-bookid
                 %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                   text = 'Enter Future Date' ) )
*        ( %key-bookid = ls_result-%key-bookid
*                 %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                   text = 'Error1' ) )
*
*        ( %key-bookid = ls_result-%key-bookid
*                 %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                   text = 'Error2' ) )
            ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD determine_data.

* determination det_data on save { create; }
* Determine the values and modify the entity
* Read Entity
    READ ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
         ENTITY demo_booking
    ALL FIELDS WITH VALUE #( ( %key-bookid = keys[ 1 ]-%key-bookid )  )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    LOOP AT lt_result INTO DATA(ls_result).
      IF ls_result-amount IS NOT INITIAL.
        DATA(lv_currCode)  = ls_result-amount.
      ELSE.
        lv_currCode = 'INR'.
      ENDIF.
    ENDLOOP.

* Update Entity
    MODIFY ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
           ENTITY demo_booking
    UPDATE FROM VALUE #( ( %key-bookid = lt_result[ 1 ]-bookid
                           amount = lv_currCode
                           %control-amount = if_abap_behv=>mk-on
                           source = 'DELHI'
                           %control-source = if_abap_behv=>mk-on
                           destination = 'HYD'
                           %control-destination = if_abap_behv=>mk-off ) )
    FAILED   DATA(lt_failed_u)
    REPORTED DATA(lt_reported_u).


  ENDMETHOD.

  METHOD actionStatus.

* action actionStatus
* Modify the entity with the default value
* Read Entity
    READ ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
         ENTITY demo_booking
*    ALL FIELDS WITH VALUE #( ( %key-book_id = keys[ 1 ]-%key-book_id )  )
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

* Update Entity
    MODIFY ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
           ENTITY demo_booking
    UPDATE FROM VALUE #( ( %key-bookid = lt_result[ 1 ]-bookid
                           status = '3'
                           %control-status = if_abap_behv=>mk-on
                       ) )
    FAILED DATA(lt_failed_u)
    REPORTED DATA(lt_reported_u).

  ENDMETHOD.




  METHOD get_instance_features.

* Read all entities
    READ ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
             ENTITY demo_booking
    ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

* Move the records to changing parameter (result)
    MOVE-CORRESPONDING keys TO result.

* Based on condition - enable/disable the action button
    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs_result>).
      READ TABLE lt_Result INTO DATA(ls_result) WITH KEY bookId = <fs_result>-%key-bookId.
      IF sy-subrc EQ 0.
        IF ls_result-inactive = 'Y'.
          <fs_result>-%action-actionInactive = if_abap_behv=>fc-o-disabled.
        ELSE.
          <fs_result>-%action-actionInactive = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD actionInactive.

* Update the field with action button
    MODIFY ENTITIES OF yrap_i_cds_demo IN LOCAL MODE
           ENTITY demo_booking
    UPDATE FROM VALUE #( ( %key-bookId = keys[ 1 ]-%key-bookid
                            inactive = 'Y'
                            %control-inactive = if_abap_behv=>mk-on ) )
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.
