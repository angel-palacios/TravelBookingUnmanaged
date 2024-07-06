CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Booking.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Booking.

    METHODS read FOR READ
      IMPORTING keys FOR READ Booking RESULT result.

    METHODS rba_Travel FOR READ
      IMPORTING keys_rba FOR READ Booking\_Travel FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD update.

    DATA lt_msg     TYPE /dmo/t_message.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_booking>).
      DATA(ls_booking) = CORRESPONDING /dmo/booking( <lfs_booking> MAPPING FROM ENTITY ).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = VALUE /dmo/s_travel_in( travel_id = <lfs_booking>-TravelID )
          is_travelx  = VALUE /dmo/s_travel_inx( travel_id = <lfs_booking>-TravelID )
          it_booking  = VALUE /dmo/t_booking_in( ( CORRESPONDING #( ls_booking ) ) )
          it_bookingx = VALUE /dmo/t_booking_inx( ( booking_id = <lfs_booking>-BookingID
                                                    _intx      = CORRESPONDING #( <lfs_booking> MAPPING FROM ENTITY )
                                                    action_code = /dmo/if_flight_legacy=>action_code-update ) )
        IMPORTING
          et_messages = lt_msg.

      "Pass data back to UI
      INSERT VALUE #( %cid = <lfs_booking>-%cid_ref
                      travelid = <lfs_booking>-TravelID
                      bookingid = <lfs_booking>-BookingID
                    ) INTO  TABLE mapped-booking.

      LOOP AT lt_msg INTO DATA(ls_msg) WHERE msgty CA 'EA'.
        APPEND VALUE #( %cid      =  <lfs_booking>-%cid_ref
                        travelid  = <lfs_booking>-TravelID
                        bookingid = <lfs_booking>-BookingID
                      ) TO failed-booking.

        APPEND VALUE #( %msg = new_message( id       = ls_msg-msgid
                                            number   = ls_msg-msgno
                                            v1       = ls_msg-msgv1
                                            v2       = ls_msg-msgv2
                                            v3       = ls_msg-msgv3
                                            v4       = ls_msg-msgv4
                                            severity = if_abap_behv_message=>severity-error )
                        %key-TravelID  = <lfs_booking>-TravelID
                        %key-bookingid = ls_booking-booking_id
                        %cid           = <lfs_booking>-%cid_ref
                        %update        = abap_on
                        TravelID       = <lfs_booking>-TravelID
                        bookingid      = <lfs_booking>-BookingID
                       ) TO reported-booking.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    DATA lt_msg     TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_booking>).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = VALUE /dmo/s_travel_in( travel_id = <lfs_booking>-TravelID )
          is_travelx  = VALUE /dmo/s_travel_inx( travel_id = <lfs_booking>-TravelID )
          it_booking  = VALUE /dmo/t_booking_in( ( booking_id = <lfs_booking>-BookingID ) )
          it_bookingx = VALUE /dmo/t_booking_inx( ( booking_id = <lfs_booking>-BookingID
                                                    action_code = /dmo/if_flight_legacy=>action_code-delete ) )
        IMPORTING
          et_messages = lt_msg.
      IF lt_msg IS NOT INITIAL.
        LOOP AT lt_msg INTO DATA(ls_msg) WHERE msgty CA 'EA'.
          APPEND VALUE #( %cid     = <lfs_booking>-%cid_ref
                          travelid = <lfs_booking>-TravelID
                          bookingid = <lfs_booking>-BookingID
                        ) TO failed-booking.

          APPEND VALUE #( %msg = new_message( id       = ls_msg-msgid
                                              number   = ls_msg-msgno
                                              v1       = ls_msg-msgv1
                                              v2       = ls_msg-msgv2
                                              v3       = ls_msg-msgv3
                                              v4       = ls_msg-msgv4
                                              severity = if_abap_behv_message=>severity-error )
                          %key-TravelID = <lfs_booking>-TravelID
                          %key-bookingid = <lfs_booking>-BookingID
                          %cid          =  <lfs_booking>-%cid_ref
                          %delete       = 'X'
                          TravelID      = <lfs_booking>-TravelID
                          bookingid = <lfs_booking>-BookingID
                        ) TO reported-booking.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Travel.
  ENDMETHOD.

ENDCLASS.
