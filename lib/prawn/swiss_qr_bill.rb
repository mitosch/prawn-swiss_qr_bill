# frozen_string_literal: true

require 'i18n'
I18n.load_path << Dir[File.join(File.expand_path("#{File.dirname(__FILE__)}/../../config/locales"), '*.yml')]
I18n.load_path.flatten!

require 'yaml'
require 'rqrcode'

require 'prawn'
require 'prawn/measurement_extensions'

require 'prawn/swiss_qr_bill/version'

require 'prawn/swiss_qr_bill/helpers/number_helper'
require 'prawn/swiss_qr_bill/helpers/box_helper'

require 'prawn/swiss_qr_bill/qr/data'
require 'prawn/swiss_qr_bill/iban'
require 'prawn/swiss_qr_bill/reference'
require 'prawn/swiss_qr_bill/padded_box'
require 'prawn/swiss_qr_bill/corner_box'
require 'prawn/swiss_qr_bill/cutting_lines'
require 'prawn/swiss_qr_bill/sections/section'
require 'prawn/swiss_qr_bill/sections/receipt_title'
require 'prawn/swiss_qr_bill/sections/receipt_information'
require 'prawn/swiss_qr_bill/sections/receipt_amount'
require 'prawn/swiss_qr_bill/sections/receipt_acceptance'
require 'prawn/swiss_qr_bill/sections/payment_title'
require 'prawn/swiss_qr_bill/sections/payment_information'
require 'prawn/swiss_qr_bill/sections/payment_amount'
require 'prawn/swiss_qr_bill/sections/payment_further_information'
require 'prawn/swiss_qr_bill/sections/qr_code'
require 'prawn/swiss_qr_bill/sections'
require 'prawn/swiss_qr_bill/debug_section'
require 'prawn/swiss_qr_bill/specifications'
require 'prawn/swiss_qr_bill/extension'
require 'prawn/swiss_qr_bill/bill'

# PrawnPDF: https://github.com/prawnpdf/prawn
module Prawn
end

Prawn::Document.extensions << Prawn::SwissQRBill::Extension
