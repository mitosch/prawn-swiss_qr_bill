# frozen_string_literal: true

describe Prawn::SwissQRBill do
  it 'appends the locales to the load path' do
    locale_files = Dir[File.join(File.expand_path("#{File.dirname(__FILE__)}/../config/locales"), '*.yml')]

    result = (locale_files - I18n.load_path).empty?

    expect(result).to be_truthy
  end

  it 'adds a method for rendering the bill' do
    doc = Prawn::Document.new

    expect(doc).to respond_to(:swiss_qr_bill)
  end

  it 'adds a method for rendering the debug lines' do
    doc = Prawn::Document.new

    expect(doc).to respond_to(:swiss_qr_bill_sections)
  end
end
