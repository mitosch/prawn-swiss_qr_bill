# frozen_string_literal: true

# OPTIMIZE: exactly the same as ReceiptAmount spec => shared spec
describe Prawn::SwissQRBill::Sections::PaymentAmount do
  let(:document) { Prawn::Document.new }
  let(:bill_data) { DataManager.build_bill }
  let(:bill_data_no_amount) { DataManager.build_bill(:no_amount) }
  let(:bill_data_no_currency) { DataManager.build_bill(:no_currency) }

  describe '.new' do
    it 'initializes the section' do
      described_class.new(document, bill_data)
    end
  end

  describe '#draw' do
    context 'when full bill data is given' do
      it 'draws currency and amount' do
        described_class.new(document, bill_data).draw
      end
    end

    context 'when amount is not given' do
      it 'draws currency and a corner box for amount' do
        described_class.new(document, bill_data_no_amount).draw
      end
    end

    context 'when currency is not given' do
      it 'draws currency as CHF and a corner box for amount' do
        described_class.new(document, bill_data_no_currency).draw
      end
    end
  end
end
