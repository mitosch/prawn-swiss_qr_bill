# frozen_string_literal: true

# These specs checks for backwards compatibility. E.g. calling swiss_qr_bill()
# with one argument shall work in any future minor version.
describe 'Compatibility' do
  let(:document) { Prawn::Document.new(page_size: 'A4') }
  let(:bill_full) { DataManager.build_bill }

  describe '#swiss_qr_bill' do
    context 'when one argument is given' do
      it 'works without arguments' do
        document.swiss_qr_bill(bill_full)
      end
    end

    # introduced with 0.5 for forcing validation
    context 'when two argument are given' do
      it 'works with nil' do
        document.swiss_qr_bill(bill_full, nil)
      end

      it 'works with empty hash' do
        document.swiss_qr_bill(bill_full, {})
      end

      it 'works with an option' do
        document.swiss_qr_bill(bill_full, validation: true)
      end
    end
  end
end
