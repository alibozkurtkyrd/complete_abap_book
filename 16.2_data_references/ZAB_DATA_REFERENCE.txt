*&---------------------------------------------------------------------*
*& Report ZAB_DATA_REFERENCE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_DATA_REFERENCE.

"Getting data references

DATA v_matnr type matnr VALUE '100'.
DATA dref    TYPE REF TO matnr.
DATA dref1   TYPE REF TO matnr.
FIELD-SYMBOLS <fs> TYPE matnr.

ASSIGN v_matnr TO <fs>.


*Getting reference from data object
GET REFERENCE OF v_matnr into dref.
*Getting reference from dereferenced reference variable
GET REFERENCE OF dref->* INTO dref1.
*Getting reference from field symbol
GET REFERENCE OF <fs> INTO dref1.
WRITE dref->*.


"Try with the generic reference variables

DATA v_matnr2 type matnr VALUE '200'.
DATA dref2 TYPE REF TO data.
FIELD-SYMBOLS <fs2> TYPE any.

GET REFERENCE OF v_matnr2 into dref2.
"To dereference the generic type, assign it to a field symbol
ASSIGN dref2->* TO <fs2>.
*WRITE dref2->*. " Results in syntax error
WRITE <fs2>.