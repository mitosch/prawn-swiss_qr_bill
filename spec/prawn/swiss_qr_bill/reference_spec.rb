# frozen_string_literal: true

describe Prawn::SwissQRBill::Reference do
  let(:valid_ref) { '22022020299991' }
  let(:valid_ref_formatted) { '02202 20202 99991' }

  describe '.new' do
    it 'initializes a reference object' do
      expect(described_class.new(valid_ref)).to be_a(described_class)
    end

    it 'assigns and standardizes the reference' do
      reference = described_class.new(valid_ref_formatted).instance_variable_get(:@reference)

      expect(reference).to eq(valid_ref_formatted.delete(' '))
    end
  end

  describe '#valid?' do
    # valid: check digits
    context 'when valid reference given' do
      it 'returns true' do
        expect(described_class.new(valid_ref)).to be_valid
      end
    end

    context 'when valid reference given as integer' do
      let(:valid_ref_num) { 22_022_020_299_991 }

      it 'returns true' do
        expect(described_class.new(valid_ref_num)).to be_valid
      end
    end

    context 'when valid reference given as formatted string' do
      it 'returns true' do
        expect(described_class.new(valid_ref_formatted)).to be_valid
      end
    end

    context 'when valid reference given as formatted string with zeros' do
      let(:valid_ref_zeros_formatted) { '00 00000 00000 02202 20202 99991' }

      it 'returns true' do
        expect(described_class.new(valid_ref_zeros_formatted)).to be_valid
      end
    end

    # invalid: check digits
    context 'when invalid reference given' do
      let(:invalid_ref) { '20222020299991' }
      #                     ^^ swapped

      it 'returns false' do
        expect(described_class.new(invalid_ref)).not_to be_valid
      end
    end

    context 'when invalid reference given as integer' do
      let(:invalid_ref_num) { 22_022_020_299_992 }
      #                                        ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_ref_num)).not_to be_valid
      end
    end

    context 'when invalid reference given as formatted string with zeros' do
      let(:invalid_ref_zeros_formatted) { '10 00000 00000 02202 20202 99991' }
      #                                    ^ should: 0

      it 'returns false' do
        expect(described_class.new(invalid_ref_zeros_formatted)).not_to be_valid
      end
    end

    # length checks
    context 'when valid length with invalid check digit is given' do
      let(:invalid_ref_zeros_formatted) { '00 00000 00000 02202 20202 99993' }
      #                                                                   ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_ref_zeros_formatted)).not_to be_valid
      end
    end

    context 'when invalid length with invalid check digit is given' do
      let(:invalid_ref_zeros_formatted) { '000 00000 00000 02202 20202 99993' }
      #                                    ^ too long                      ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_ref_zeros_formatted)).not_to be_valid
      end
    end

    context 'when invalid length with valid check digit is given' do
      let(:invalid_ref_zeros_formatted) { '000 00000 00000 02202 20202 99991' }
      #                                    ^ too long                      ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_ref_zeros_formatted)).not_to be_valid
      end
    end
  end
end
