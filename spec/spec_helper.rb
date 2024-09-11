# frozen_string_literal: true

# All specs in the features/ folder are the slower ones and target integration
# of the gem (consumer specific tests).
#
# Goal for code coverage is to get 100% withouth feature specs.
#
# for faster testing cycles, use the following command:
#
#   $ bundle exec rspec --exclude-pattern "spec/features/*_spec.rb"
#

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

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

# Ensure tmp dir
FileUtils.mkdir_p(TMP_DIR)
