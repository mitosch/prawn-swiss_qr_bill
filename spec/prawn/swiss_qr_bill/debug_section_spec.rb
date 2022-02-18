# frozen_string_literal: true

describe Prawn::SwissQRBill::DebugSection do
  let(:document) { Prawn::Document.new(page_size: 'A4') }

  describe '.new' do
    it 'can instanciate a debug section' do
      expect(described_class.new(document)).to be_a(described_class)
    end
  end

  describe '#draw' do
    it 'draws the debug section to the page without an error' do
      described_class.new(document).draw
    end

    it 'can be drawn through prawn' do
      document.swiss_qr_bill_sections
    end
  end
end
