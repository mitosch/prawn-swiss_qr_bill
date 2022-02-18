# frozen_string_literal: true

describe Prawn::SwissQRBill::IBAN do
  let(:valid_iban) { 'CH77 8080 8004 1110 4136 9' }
  let(:invalid_iban) { 'CH77 8080 0804 1110 4136 9' }
  let(:toolong_iban) { 'CH77 8080 8004 1110 4136 99' }
  let(:eu_iban) { 'EU77 8080 8004 1110 4136 9' }

  describe '.new' do
    it 'initializes an iban object' do
      expect(described_class.new(valid_iban)).to be_a(described_class)
    end

    it 'assigns and standardizes the code' do
      code = described_class.new(valid_iban).instance_variable_get(:@code)

      expect(code).to eq(valid_iban.delete(' '))
    end
  end

  describe '#country_code' do
    it 'returns the country code' do
      expect(described_class.new(valid_iban).country_code).to eq('CH')
    end
  end

  describe '#check_digits' do
    it 'returns the two check digits' do
      expect(described_class.new(valid_iban).check_digits).to eq('77')
    end
  end

  describe '#bban' do
    it 'returns the bban' do
      expect(described_class.new(valid_iban).bban).to eq('80808004111041369')
    end
  end

  describe '#to_i' do
    it 'returns iban in decimals' do
      expect(described_class.new(valid_iban).to_i).to eq(80_808_004_111_041_369_121_777)
    end
  end

  describe '#prettify' do
    it 'returns iban in pretty format' do
      expect(described_class.new(valid_iban).prettify).to eq(valid_iban)
    end

    it 'adds spaces' do
      iban = valid_iban.delete(' ')

      expect(described_class.new(iban).prettify).to eq(valid_iban)
    end

    it 'upcases lower chars' do
      iban = valid_iban.downcase

      expect(described_class.new(iban).prettify).to eq(valid_iban)
    end

    it 'removes trailing and leading spaces' do
      iban = ' ch77    8080 8004 1110  4136 9 '

      expect(described_class.new(iban).prettify).to eq(valid_iban)
    end
  end

  describe '#valid?' do
    it 'returns true for a valid iban' do
      expect(described_class.new(valid_iban)).to be_valid
    end

    it 'returns false for an invalid iban' do
      expect(described_class.new(invalid_iban)).not_to be_valid
    end
  end

  describe '#valid_check_digits?' do
    it 'returns true for valid check digits' do
      expect(described_class.new(valid_iban)).to be_valid_check_digits
    end

    it 'returns false for invalid check digits' do
      expect(described_class.new(invalid_iban)).not_to be_valid_check_digits
    end
  end

  describe '#valid_length?' do
    it 'returns true for valid length' do
      expect(described_class.new(valid_iban)).to be_valid_length
    end

    it 'returns false for invalid length' do
      expect(described_class.new(toolong_iban)).not_to be_valid_length
    end
  end

  describe '#valid_swiss_length?' do
    it 'returns true for valid swiss length' do
      expect(described_class.new(valid_iban)).to be_valid_swiss_length
    end

    it 'returns false for invalid swiss length' do
      expect(described_class.new(toolong_iban)).not_to be_valid_swiss_length
    end
  end

  describe '#valid_country?' do
    it 'returns true for valid swiss iban' do
      expect(described_class.new(valid_iban)).to be_valid_country
    end

    it 'returns false for invalid country' do
      expect(described_class.new(eu_iban)).not_to be_valid_country
    end
  end
end
