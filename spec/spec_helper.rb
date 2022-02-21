# frozen_string_literal: true

require 'simplecov'
require 'pdf-reader'

# Where to store temporary PDF files
TMP_DIR = "#{File.dirname(__FILE__)}/tmp"

SimpleCov.start do
  add_filter 'spec/'
end

if ENV['CI'] == 'true'
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require 'prawn/swiss_qr_bill'

# TODO: remove when fonts are added
Prawn::Fonts::AFM.hide_m17n_warning = true

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

# Ensure tmp dir
FileUtils.mkdir(TMP_DIR) unless Dir.exist?(TMP_DIR)
