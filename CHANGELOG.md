### master

* no changes

### 0.5.4 - 2024-09-11

* Fix bug where streed and building number of structured address was not displayed on one line. Thanks to @franco.
* Fix wrong rendering of Inter font. Thanks to @dianedelallee.

### 0.5.3 - 2024-05-07

* Fix bug where currency could not be set to EUR. Thanks to @franco.

### 0.5.2 - 2022-08-25

* Add additional information (unstructured_message, bill_information). Thanks to @noefroidevaux.

### 0.5.1 - 2022-04-14

* For QRR reference: make modulo10 recursive method accessible as instance method to generate check digit

### 0.5.0 - 2022-02-27

#### bug fixes

* fix bug where creditor address city was missing when using combined address type

#### features

* reference (QRR, SCOR) can be validated (it raises `InvalidReferenceError`)
* iban can be validated (it raises `MissingIBANError` or `InvalidIBANError`)

#### misc

* cleaning up specs, splitted to feature specs (slower ones). fast run: `$ bundle exec rspec --exclude-pattern "spec/features/*_spec.rb"`

### 0.4.2 - 2022-02-21

#### features

* fonts: embed and use Inter font as a Helvetica alternative

#### bug fixes

* stroke color of cutting lines is not set to black, when setting stroke color before to another color

### 0.4.1 - 2022-02-18

#### features

* draw cutting lines with scissor symbol

#### bug fixes

* fix empty line after addresses when using combined address

### 0.4.0 - 2022-02-18

* initial release
