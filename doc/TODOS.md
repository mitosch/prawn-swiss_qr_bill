# Todos for Prawn::SwissQRBill

## Open

* [ ] Detect page break automatically, if possible
* [ ] Draw Further information section
* [ ] Add alternative_parameters to QR-code data
* [ ] Implement reference check. Raise exception?
* [ ] Further validation, like: code set to 'QRR' but IBAN is not a QR-IBAN, reference missing, etc.
* [ ] Create a nicer example bill

## Done

* [x] Add bill_information, unstructured_message to QR-code data
  * done by @noefroidevaux
* [x] Add fonts, do not use Prawn default
* [x] Draw cutting lines
* [x] Implement IBAN check. Raise exception
