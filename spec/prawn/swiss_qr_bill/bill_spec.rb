# frozen_string_literal: true

describe Prawn::SwissQRBill::Bill do
  let(:document) { Prawn::Document.new(page_size: 'A4') }

  let(:bill_full) { DataManager.build_bill }

  describe '.new' do
    it 'initializes a new bill' do
      bill = described_class.new(document, {})

      expect(bill).to be_a(described_class)
    end
  end

  describe '#draw' do
    it 'draws all the sections' do
      described_class.new(document, bill_full).draw

      reader = PDF::Reader.new(StringIO.new(document.render))

      expect(reader.pages.length).to eq(1)
    end

    it 'can be drawn through prawn' do
      document.swiss_qr_bill(bill_full)
    end
  end
end
