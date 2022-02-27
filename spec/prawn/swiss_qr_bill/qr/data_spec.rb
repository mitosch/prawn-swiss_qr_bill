# frozen_string_literal: true

describe Prawn::SwissQRBill::QR::Data do
  let(:bill_data) { DataManager.build_bill(:default, flat: true) }

  describe '.new' do
    it 'initializes the qr data with defaults' do
      expect(described_class.new).to be_a(described_class)
    end

    it 'initializes the qr data given data' do
      expect(described_class.new(bill_data)).to be_a(described_class)
    end
  end

  describe '#generate' do
    # rubocop:disable RSpec/MultipleExpectations
    it 'generates a string of the given data' do
      qr_data = described_class.new(bill_data)
      qr_data_string = qr_data.generate
      qr_data_array = qr_data_string.split("\r\n")

      expect(qr_data_array.length).to eq(31)
      expect(qr_data_array[28]).to eq('000000000000022022020299991')
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe '#validate' do
    it 'generates valid data' do
      qr_data = described_class.new(bill_data, validate: true)
      expect(qr_data.validate).to be_truthy
    end

    it 'raises an error for missing iban' do
      qr_data = described_class.new(bill_data, validate: true)
      qr_data.iban = nil

      expect do
        qr_data.validate
      end.to raise_error(Prawn::SwissQRBill::QR::MissingIBANError, 'IBAN is missing')
    end

    it 'raises an error for invalid iban' do
      iban = 'CH08 3088 8004 1110 4136 9'
      qr_data = described_class.new(bill_data, validate: true)
      qr_data.iban = iban

      expect do
        qr_data.validate
      end.to raise_error(Prawn::SwissQRBill::QR::InvalidIBANError, "IBAN #{iban} is invalid")
    end

    it 'raises an error for invalid reference' do
      reference = '00 00000 00000 22202 20202 99991'
      qr_data = described_class.new(bill_data, validate: true)
      qr_data.reference = reference

      expect do
        qr_data.validate
      end.to raise_error(Prawn::SwissQRBill::QR::InvalidReferenceError, "Reference #{reference} is invalid")
    end

    it 'raises an error for wrong reference type' do
      qr_data = described_class.new(bill_data, validate: true)
      qr_data.reference_type = 'NON'

      expect do
        qr_data.validate
      end.to raise_error(Prawn::SwissQRBill::QR::InvalidReferenceError, 'Reference Type NON invalid. Allowed: QRR, SCOR')
    end

    context 'with scor reference' do
      it 'generates valid data' do
        scor_bill = DataManager.build_bill(:scor_ref, flat: true)
        qr_data = described_class.new(scor_bill, validate: true)
        expect(qr_data.validate).to be_truthy
      end
    end
  end

  describe '#process' do
    context 'with amount' do
      it 'formats string with decimals to decimal 2f string' do
        qr_data = described_class.new(amount: '9.95')
        qr_data.process

        expect(qr_data.amount).to eq('9.95')
      end

      it 'formats string without decimals to decimal 2f string' do
        qr_data = described_class.new(amount: '9')
        qr_data.process

        expect(qr_data.amount).to eq('9.00')
      end

      it 'formats float with one decimal to decimal 2f string' do
        qr_data = described_class.new(amount: 9.9)
        qr_data.process

        expect(qr_data.amount).to eq('9.90')
      end

      it 'formats integer to decimal 2f string' do
        qr_data = described_class.new(amount: 9)
        qr_data.process

        expect(qr_data.amount).to eq('9.00')
      end
    end

    context 'with reference' do
      it 'removes whitespaces in reference' do
        qr_data = described_class.new(reference: '00 00000 00000 02202 20202 99991')
        qr_data.process

        expect(qr_data.reference).to eq('000000000000022022020299991')
      end
    end
  end
end
