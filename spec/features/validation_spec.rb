# frozen_string_literal: true

describe 'Validation' do
  let(:document) { Prawn::Document.new(page_size: 'A4') }

  context 'when validation is not given' do
    context 'when iban is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        document.swiss_qr_bill(bill_data)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when iban is invalid' do
      let(:bill_data) { DataManager.build_bill(:invalid_iban) }

      it 'does not raise an exception' do
        document.swiss_qr_bill(bill_data)

        expect(document).to be_a(Prawn::Document)
      end
    end
  end

  context 'when validation is deactivated' do
    context 'when iban is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        document.swiss_qr_bill(bill_data, validate: false)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when iban is invalid' do
      let(:bill_data) { DataManager.build_bill(:invalid_iban) }

      it 'does not raise an exception' do
        document.swiss_qr_bill(bill_data, validate: false)

        expect(document).to be_a(Prawn::Document)
      end
    end
  end

  context 'when validation is set' do
    context 'when iban is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        document.swiss_qr_bill(bill_data, validation: true)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when iban is invalid' do
      let(:bill_data) { DataManager.build_bill(:invalid_iban) }

      it 'raises an exception' do
        iban = bill_data[:creditor][:iban]
        expect do
          document.swiss_qr_bill(bill_data, validation: true)
        end.to raise_exception("IBAN #{iban} is invalid")
      end
    end
  end
end
