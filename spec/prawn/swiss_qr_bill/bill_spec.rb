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

    context 'with structured address (address type S)' do
      let(:s_type_address) { DataManager.build_bill(:s_type_address) }

      it 'combines `line1` (street name) and `line2` (street number) on a single line' do
        described_class.new(document, s_type_address).draw

        pdf_text = PDF::Reader.new(StringIO.new(document.render)).page(1).text

        expect(pdf_text).to include('Schybenächerweg 553')
          .and include('Musterstrasse 1')
      end
    end

    context 'with unstructured address (address type K)' do
      let(:k_type_address) { DataManager.build_bill(:k_type_address) }

      it 'draws `line1` (street name + number ) and `line2` (postal_code + city) on separate lines' do
        described_class.new(document, k_type_address).draw

        pdf_text = PDF::Reader.new(StringIO.new(document.render)).page(1).text

        expect(pdf_text).to include("Musterstrasse 123\n")
          .and include("8000 Seldwyla\n")
          .and include("Simonstrasse 1\n")
          .and include("5000 Aarau\n")
      end
    end
  end
end
