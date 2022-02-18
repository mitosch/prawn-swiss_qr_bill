# frozen_string_literal: true

describe Prawn::SwissQRBill::CornerBox do
  let(:document) { Prawn::Document.new }

  describe '.new' do
    context 'when all options given' do
      it 'can instantiate the object' do
        expect(described_class.new(document, [3, 4], { width: 100, height: 50 })).to be_a(described_class)
      end
    end

    context 'when no width option given' do
      it 'raises an error' do
        expect do
          described_class.new(document, [3, 4], { some: :nonce })
        end.to raise_exception(ArgumentError, 'corner_box needs the :width and :height option to be set')
      end
    end

    context 'when no height option given' do
      it 'raises an error' do
        expect do
          described_class.new(document, [3, 4], { width: 100 })
        end.to raise_exception(ArgumentError, 'corner_box needs the :width and :height option to be set')
      end
    end
  end

  describe '#draw' do
    it 'can draw a corner box' do
      described_class.new(document, [3, 4], { width: 100, height: 50 }).draw
    end
  end
end
