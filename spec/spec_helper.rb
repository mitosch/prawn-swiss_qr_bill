# frozen_string_literal: true

require 'simplecov'
require 'simplecov-cobertura'
require 'pdf-reader'

SimpleCov.start do
  add_filter 'spec/'
end

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

require 'prawn/swiss_qr_bill'

# TODO: remove when fonts are added
Prawn::Fonts::AFM.hide_m17n_warning = true

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

# Ensure tmp dir
TMP_DIR = "#{File.dirname(__FILE__)}/tmp"

FileUtils.mkdir(TMP_DIR) unless Dir.exist?(TMP_DIR)
