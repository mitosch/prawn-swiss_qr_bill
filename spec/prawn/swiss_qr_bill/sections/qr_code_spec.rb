# frozen_string_literal: true

describe Prawn::SwissQRBill::Sections::QRCode do
  let(:document) { Prawn::Document.new }
  let(:bill_data) { DataManager.build_bill }

  describe '.new' do
    it 'initializes the section' do
      described_class.new(document, bill_data)
    end
  end

  describe '#draw' do
    context 'without validation option' do
      it 'draws the qr code' do
        described_class.new(document, bill_data).draw
      end
    end

    context 'with validation option' do
      it 'draws the qr code' do
        described_class.new(document, bill_data, validate: true).draw
      end

      it 'raises an error for missing iban' do
        bill_data[:creditor].delete(:iban)

        expect do
          described_class.new(document, bill_data, validate: true).draw
        end.to raise_error(Prawn::SwissQRBill::MissingIBANError, 'IBAN is missing')
      end

      it 'raises an error for invalid iban' do
        iban = 'CH08 3088 8004 1110 4136 9'
        bill_data[:creditor][:iban] = iban

        expect do
          described_class.new(document, bill_data, validate: true).draw
        end.to raise_error(Prawn::SwissQRBill::InvalidIBANError, "IBAN #{iban} is invalid")
      end

      it 'raises an error for invalid reference' do
        reference = '00 00000 00000 22202 20202 99991'
        bill_data[:reference] = reference

        expect do
          described_class.new(document, bill_data, validate: true).draw
        end.to raise_error(Prawn::SwissQRBill::InvalidReferenceError, "Reference #{reference} is invalid")
      end
    end
  end
end
