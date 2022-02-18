# frozen_string_literal: true

describe Prawn::SwissQRBill::Helpers::BoxHelper do
  let(:document) { Prawn::Document.new }
  let(:formatter) do
    Class.new do
      include Prawn::SwissQRBill::Helpers::BoxHelper
    end
  end

  describe '.corner_box' do
    context 'when all options given' do
      it 'can draw the box without an error' do
        formatter.new.corner_box(document, [3, 4], { width: 100, height: 50 })
      end
    end
  end
end
