

PARAMETERS : p_kunnr TYPE kunnr,
p_matnr TYPE matnr,
p_spras TYPE spras.
DATA wa_screen TYPE screen.

"this event provides us to manipulate the screen field and its called on pbo event.
AT SELECTION-SCREEN OUTPUT.




LOOP AT SCREEN INTO wa_screen.
  IF wa_screen-name EQ 'P_MATNR'.
  wa_screen-input = abap_false.
  ENDIF.

  IF wa_screen-name EQ 'P_SPRAS'.
    wa_screen-input = abap_false.
  ENDIF.

  MODIFY SCREEN FROM wa_screen.

ENDLOOP.