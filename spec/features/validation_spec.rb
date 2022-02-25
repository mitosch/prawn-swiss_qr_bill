# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe 'Validation' do
  let(:document) { Prawn::Document.new(page_size: 'A4') }

  # validation is not given (default: false)
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

    context 'when iban is not given' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:creditor][:iban] = nil
        document.swiss_qr_bill(bill_data)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when reference is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = '00 00000 00000 02202 20202 99991'
        document.swiss_qr_bill(bill_data)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when reference is invalid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = '00 00000 00000 22202 20202 99991'
        document.swiss_qr_bill(bill_data)

        expect(document).to be_a(Prawn::Document)
      end
    end
  end

  # explicit non-validation
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

    context 'when iban is not given' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:creditor][:iban] = nil
        document.swiss_qr_bill(bill_data, validate: false)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when reference is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = '00 00000 00000 02202 20202 99991'
        document.swiss_qr_bill(bill_data, validate: false)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when reference is invalid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = '00 00000 00000 22202 20202 99991'
        document.swiss_qr_bill(bill_data, validate: false)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when reference is not given' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = nil
        document.swiss_qr_bill(bill_data, validate: false)

        expect(document).to be_a(Prawn::Document)
      end
    end
  end

  # with validation
  context 'when validation is set' do
    context 'when iban is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        document.swiss_qr_bill(bill_data, validate: true)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when iban is invalid' do
      let(:bill_data) { DataManager.build_bill(:invalid_iban) }

      it 'raises an exception' do
        iban = bill_data[:creditor][:iban]
        expect do
          document.swiss_qr_bill(bill_data, validate: true)
        end.to raise_exception(Prawn::SwissQRBill::InvalidIBANError, "IBAN #{iban} is invalid")
      end
    end

    context 'when iban is not given' do
      let(:bill_data) { DataManager.build_bill }

      it 'raises an exception' do
        bill_data[:creditor][:iban] = nil
        expect do
          document.swiss_qr_bill(bill_data, validate: true)
        end.to raise_exception(Prawn::SwissQRBill::MissingIBANError, 'IBAN is missing')
      end
    end

    context 'when reference is valid' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = '00 00000 00000 02202 20202 99991'
        document.swiss_qr_bill(bill_data, validate: true)

        expect(document).to be_a(Prawn::Document)
      end
    end

    context 'when reference is invalid' do
      let(:bill_data) { DataManager.build_bill }

      it 'raises an exception' do
        bill_data[:reference] = '00 00000 00000 22202 20202 99991'
        expect do
          document.swiss_qr_bill(bill_data, validate: true)
        end.to raise_exception(Prawn::SwissQRBill::InvalidReferenceError,
                               "Reference #{bill_data[:reference]} is invalid")
      end
    end

    context 'when reference is not given' do
      let(:bill_data) { DataManager.build_bill }

      it 'does not raise an exception' do
        bill_data[:reference] = nil
        document.swiss_qr_bill(bill_data, validate: true)

        expect(document).to be_a(Prawn::Document)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
