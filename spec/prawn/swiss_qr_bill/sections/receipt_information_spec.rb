# frozen_string_literal: true

# OPTIMIZE: almost the same as ReceiptInformation spec, see commented lines => shared spec
describe Prawn::SwissQRBill::Sections::ReceiptInformation do
  let(:document) { Prawn::Document.new }
  let(:bill_data) { DataManager.build_bill }
  let(:bill_data_no_reference) { DataManager.build_bill(:no_reference) }
  # let(:bill_data_no_additional_information) { DataManager.build_bill(:no_additional_information) }
  let(:bill_data_no_debtor) { DataManager.build_bill(:no_debtor) }

  describe '.new' do
    it 'initializes the section' do
      described_class.new(document, bill_data)
    end
  end

  describe '#draw' do
    context 'when full bill data is given' do
      it 'draws payable to, reference, additional information, payable by' do
        described_class.new(document, bill_data).draw
      end
    end

    context 'when reference is not given' do
      it 'draws payable to, additional information, payable by' do
        described_class.new(document, bill_data_no_reference).draw
      end
    end

    # context 'when additional information is not given' do
    #   it 'draws payable to, reference, payable by' do
    #     described_class.new(document, bill_data_no_additional_information).draw
    #   end
    # end

    context 'when debtor is not given' do
      it 'draws a corner box for the debtor' do
        described_class.new(document, bill_data_no_debtor).draw
      end
    end
  end
end
