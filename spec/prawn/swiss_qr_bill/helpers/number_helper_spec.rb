# frozen_string_literal: true

describe Prawn::SwissQRBill::Helpers::NumberHelper do
  let(:formatter) do
    Class.new do
      include Prawn::SwissQRBill::Helpers::NumberHelper
    end
  end

  describe '.format_with_delimiter' do
    context 'when two decimals given' do
      it 'formats the number with spaces' do
        amount = 1234.55

        expect(formatter.new.format_with_delimiter(amount)).to eq('1 234.55')
      end
    end

    context 'when one decimal given' do
      it 'formats the number with spaces' do
        amount = 1234.5

        expect(formatter.new.format_with_delimiter(amount)).to eq('1 234.50')
      end
    end

    context 'when three decimals are given' do
      it 'rounds to two decimals and formats the number with spaces' do
        amount = 9.555

        expect(formatter.new.format_with_delimiter(amount)).to eq('9.56')
      end
    end

    context 'when a small amount as intiger is given' do
      it 'adds trailing zeros and formats the number with spaces' do
        amount = 9

        expect(formatter.new.format_with_delimiter(amount)).to eq('9.00')
      end
    end

    context 'when a very high number without decimal given' do
      it 'formats the number with spaces' do
        amount = 1_000_000

        expect(formatter.new.format_with_delimiter(amount)).to eq('1 000 000.00')
      end
    end

    context 'when a string with decimals is given' do
      it 'formats the number with spaces' do
        amount = '1010.96'

        expect(formatter.new.format_with_delimiter(amount)).to eq('1 010.96')
      end
    end

    context 'when a string without decimals is given' do
      it 'adds trailing zeros and formats the number with spaces' do
        amount = '1010'

        expect(formatter.new.format_with_delimiter(amount)).to eq('1 010.00')
      end
    end
  end
end
