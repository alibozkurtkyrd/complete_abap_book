*&---------------------------------------------------------------------*
*& Report  ZAB_DETAIL_LIST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZAB_DETAIL_LIST NO STANDARD PAGE HEADING.


tables: makt, mseg.

TYPES: BEGIN OF ty_product,
          matnr TYPE MAKT-MATNR,
          spras TYPE MAKT-SPRAS,
          MAKTX TYPE MAKT-MAKTX,
       END OF ty_product.


DATA : it_product type STANDARD TABLE OF ty_product,
       wa_product type ty_product.


PARAMETERS p_spras TYPE  makt-spras.

START-OF-SELECTION.
  PERFORM get_data.


END-OF-SELECTION.
  PERFORM output.


AT LINE-SELECTION. " (ONEMLI) this event triggered when the user double-clicks any record of the displayed
  PERFORM detail_list.

*select MAKT~matnr, MAKT~maktx from
*    MAKT
*  inner join  MSEG ON MAKT~MATNR EQ mseg~matnr
*  INTO CORRESPONDING FIELDS OF TABLE @IT_PRODUCT.

*  BREAK ANALIS03.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
  SELECT MATNR, SPRAS, MAKTX  FROM MAKT INTO TABLE @it_product
     UP TO 10000 ROWS  "I limit the returned numbers of rows as 1000
    WHERE spras EQ @p_spras
*    AND MATNR EQ ('0010100018', '12LRN2300P01FDCR', '12LRN2232P01FDCJ').
    AND  ( MATNR EQ '0010100018' OR  MATNR EQ '12LRN2300P01FDCR' OR  MATNR EQ '12LRN2232P01FDCJ').
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM OUTPUT .
  LOOP AT IT_PRODUCT INTO WA_PRODUCT.
    WRITE : / WA_PRODUCT-MATNR,
              WA_PRODUCT-MAKTX,
              WA_PRODUCT-MATNR.

    HIDE : WA_PRODUCT-matnr. " (ONEMLI) It is use when u want a specific field of the record clicked

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DETAIL_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DETAIL_LIST .
  TYPES : BEGIN OF ty_certificate,
            matnr type mseg-matnr,
            MBLNR type mseg-mblnr,
          END OF ty_certificate.

  DATA : lt_certificate TYPE STANDARD TABLE OF TY_CERTIFICATE,
         lw_certificate type TY_CERTIFICATE.


  SELECT MATNR, MBLNR
    FROM MSEG
    INTO TABLE @LT_CERTIFICATE
    WHERE MATNR EQ @WA_PRODUCT-MATNR.

  LOOP AT LT_CERTIFICATE INTO LW_CERTIFICATE.
    WRITE : / LW_CERTIFICATE-MATNR,
              LW_CERTIFICATE-MBLNR.
    ENDLOOP.

ENDFORM.