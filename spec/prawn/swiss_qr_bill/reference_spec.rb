# frozen_string_literal: true

describe Prawn::SwissQRBill::Reference do
  let(:valid_qrr_ref) { '22022020299991' }
  let(:valid_qrr_ref_formatted) { '02202 20202 99991' }
  let(:valid_scor_ref) { 'RF18539007547034' }
  let(:valid_scor_ref_formatted) { 'RF18 5390 0754 7034' }

  describe '.new' do
    it 'initializes a reference object' do
      expect(described_class.new(valid_qrr_ref)).to be_a(described_class)
    end

    it 'assigns and standardizes the reference' do
      reference = described_class.new(valid_qrr_ref_formatted).instance_variable_get(:@reference)

      expect(reference).to eq(valid_qrr_ref_formatted.delete(' '))
    end
  end

  describe '.modulo10_recursive' do
    context 'when number given' do
      it 'returns the correct check digit' do
        expect(described_class.modulo10_recursive('2202202029999')).to eq(1)
      end
    end

    context 'when number with leading zeros given' do
      it 'returns the correct check digit' do
        expect(described_class.modulo10_recursive('000002202202029999')).to eq(1)
      end
    end
  end

  describe '#valid? (QRR)' do
    # valid: check digits
    context 'when valid reference given' do
      it 'returns true' do
        expect(described_class.new(valid_qrr_ref)).to be_valid
      end
    end

    context 'when valid reference given as integer' do
      let(:valid_qrr_ref_num) { 22_022_020_299_991 }

      it 'returns true' do
        expect(described_class.new(valid_qrr_ref_num)).to be_valid
      end
    end

    context 'when valid reference given as formatted string' do
      it 'returns true' do
        expect(described_class.new(valid_qrr_ref_formatted)).to be_valid
      end
    end

    context 'when valid reference given as formatted string with zeros' do
      let(:valid_qrr_ref_zeros_formatted) { '00 00000 00000 02202 20202 99991' }

      it 'returns true' do
        expect(described_class.new(valid_qrr_ref_zeros_formatted)).to be_valid
      end
    end

    # invalid: scor
    context 'when falsely valid SCOR reference given' do
      it 'returns false' do
        expect(described_class.new(valid_scor_ref, 'QRR')).not_to be_valid
      end
    end

    # invalid: check digits
    context 'when invalid reference given' do
      let(:invalid_qrr_ref) { '20222020299991' }
      #                     ^^ swapped

      it 'returns false' do
        expect(described_class.new(invalid_qrr_ref)).not_to be_valid
      end
    end

    context 'when invalid reference given as integer' do
      let(:invalid_qrr_ref_num) { 22_022_020_299_992 }
      #                                        ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_qrr_ref_num)).not_to be_valid
      end
    end

    context 'when invalid reference given as formatted string with zeros' do
      let(:invalid_qrr_ref_zeros_formatted) { '10 00000 00000 02202 20202 99991' }
      #                                    ^ should: 0

      it 'returns false' do
        expect(described_class.new(invalid_qrr_ref_zeros_formatted)).not_to be_valid
      end
    end

    # length checks
    context 'when valid length with invalid check digit is given' do
      let(:invalid_qrr_ref_zeros_formatted) { '00 00000 00000 02202 20202 99993' }
      #                                                                   ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_qrr_ref_zeros_formatted)).not_to be_valid
      end
    end

    context 'when invalid length with invalid check digit is given' do
      let(:invalid_qrr_ref_zeros_formatted) { '000 00000 00000 02202 20202 99993' }
      #                                    ^ too long                      ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_qrr_ref_zeros_formatted)).not_to be_valid
      end
    end

    context 'when invalid length with valid check digit is given' do
      let(:invalid_qrr_ref_zeros_formatted) { '000 00000 00000 02202 20202 99991' }
      #                                    ^ too long                      ^ should: 1

      it 'returns false' do
        expect(described_class.new(invalid_qrr_ref_zeros_formatted)).not_to be_valid
      end
    end
  end

  describe '#valid? (SCOR)' do
    # valid: check digits
    context 'when valid reference given' do
      it 'returns true' do
        expect(described_class.new(valid_scor_ref, 'SCOR')).to be_valid
      end
    end

    context 'when valid reference with leading zeros given' do
      it 'returns true'
    end

    context 'when valid reference given as formatted string' do
      it 'returns true' do
        expect(described_class.new(valid_scor_ref_formatted, 'SCOR')).to be_valid
      end
    end

    # invalid: qrr
    context 'when falsely valid QRR reference given' do
      it 'returns false' do
        expect(described_class.new(valid_qrr_ref, 'SCOR')).not_to be_valid
      end
    end

    # invalid: check digits
    context 'when invalid reference given' do
      let(:invalid_scor_ref) { 'RF18593007547034' }
      #                              ^^ swapped

      it 'returns false' do
        expect(described_class.new(invalid_scor_ref)).not_to be_valid
      end
    end

    # context 'when invalid reference given as formatted string with zeros' do
    #   let(:invalid_scor_ref_zeros_formatted) { '10 00000 00000 02202 20202 99991' }
    #   #                                    ^ should: 0

    #   it 'returns false' do
    #     expect(described_class.new(invalid_scor_ref_zeros_formatted)).not_to be_valid
    #   end
    # end

    # length checks
    # context 'when valid length with invalid check digit is given' do
    #   let(:invalid_scor_ref_zeros_formatted) { '00 00000 00000 02202 20202 99993' }
    #   #                                                                   ^ should: 1

    #   it 'returns false' do
    #     expect(described_class.new(invalid_scor_ref_zeros_formatted)).not_to be_valid
    #   end
    # end

    # context 'when invalid length with invalid check digit is given' do
    #   let(:invalid_scor_ref_zeros_formatted) { '000 00000 00000 02202 20202 99993' }
    #   #                                    ^ too long                      ^ should: 1

    #   it 'returns false' do
    #     expect(described_class.new(invalid_scor_ref_zeros_formatted)).not_to be_valid
    #   end
    # end

    # context 'when invalid length with valid check digit is given' do
    #   let(:invalid_scor_ref_zeros_formatted) { '000 00000 00000 02202 20202 99991' }
    #   #                                    ^ too long                      ^ should: 1

    #   it 'returns false' do
    #     expect(described_class.new(invalid_scor_ref_zeros_formatted)).not_to be_valid
    #   end
    # end
  end
end
