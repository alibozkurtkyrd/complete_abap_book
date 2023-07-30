*&---------------------------------------------------------------------*
*& Report ZAB_BLOCK_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_BLOCK_DISPLAY.


DATA :  it_sflight TYPE STANDARD TABLE OF sflight,
        it_spfli TYPE STANDARD TABLE OF spfli,
        it_fcat_sflight TYPE SLIS_T_FIELDCAT_ALV,
        it_fcat_spfli TYPE slis_t_fieldcat_alv,
        it_events TYPE SLIS_T_EVENT.



PARAMETERS p_carrid TYPE s_carr_id.

START-OF-SELECTION.
  PERFORM get_data.
END-OF-SELECTION.

PERFORM field_catalog.
PERFORM show_output.



*&--------------------------------------------------------------*
*& Form GET_DATA
*&--------------------------------------------------------------*
FORM get_data .
  SELECT * FROM sflight INTO TABLE it_sflight WHERE carrid EQ p_carrid.
  SELECT * FROM spfli INTO TABLE it_spfli WHERE carrid EQ p_carrid.
ENDFORM.
*&--------------------------------------------------------------*
*& Form FIELD_CATALOG
*&--------------------------------------------------------------*
FORM field_catalog .

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        I_STRUCTURE_NAME = 'SPFLI'
      CHANGING
        ct_fieldcat = it_fcat_spfli
      EXCEPTIONS
        INCONSISTENT_INTERFACE = 1
        PROGRAM_ERROR = 2
        OTHERS = 3
    .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
         I_STRUCTURE_NAME = 'SFLIGHT'
         CHANGING
           ct_fieldcat = it_fcat_sflight
         EXCEPTIONS
           INCONSISTENT_INTERFACE = 1
           PROGRAM_ERROR = 2
           OTHERS = 3
    .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
ENDFORM.
*&--------------------------------------------------------------*
*& Form SHOW_OUTPUT
*&--------------------------------------------------------------*
FORM show_output .
    DATA layout TYPE SLIS_LAYOUT_ALV.
    layout-zebra = 'X'.

    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
      EXPORTING
         i_callback_program = 'ZDEMO_BLOCK_REPORT'
    .
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout = layout
        it_fieldcat = it_fcat_spfli
        i_tabname = 'IT_SPFLI'
        it_events = it_events
      TABLES
        t_outtab = it_spfli
      EXCEPTIONS
        PROGRAM_ERROR = 1
        MAXIMUM_OF_APPENDS_REACHED = 2
        OTHERS = 3
      .
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
      EXPORTING
        is_layout = layout
        it_fieldcat = it_fcat_sflight
        i_tabname = 'IT_SFLIGHT'
        it_events = it_events
      TABLES
        t_outtab = it_sflight
      EXCEPTIONS
        PROGRAM_ERROR = 1
        MAXIMUM_OF_APPENDS_REACHED = 2
        OTHERS = 3
    .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'
      EXCEPTIONS
        PROGRAM_ERROR = 1
        OTHERS = 2
      .
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.
ENDFORM.