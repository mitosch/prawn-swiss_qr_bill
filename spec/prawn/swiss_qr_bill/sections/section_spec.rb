# frozen_string_literal: true

describe Prawn::SwissQRBill::Sections::Section do
  let(:document) { Prawn::Document.new }
  let(:bill_data) { DataManager.build_bill }
  let(:section_class) { SomeSection.new(document, {}) }
  let(:fake_section) do
    klazz = Class.new(described_class) do
      def draw
        1
      end
    end

    klazz.const_set(:KEY, 'some.key')
    klazz
  end

  describe '.new' do
    it 'initializes a section' do
      section = fake_section.new(document, {})

      expect(section).to be_a(described_class)
    end

    it 'raises an exception when constant KEY is not defined' do
      expect do
        described_class.new(document, {})
      end.to raise_exception(NotImplementedError, "constant KEY not defined in class #{described_class}")
    end
  end

  describe '#draw' do
    it 'raises an exception when called on main class' do
      klass = described_class
      klass.const_set(:KEY, 'some.key')

      expect do
        klass.new(document, bill_data).draw
      end.to raise_exception(NotImplementedError, 'Subcluss must implement draw method.')
    end

    it 'executes the implemented method on the sub class' do
      section = fake_section.new(document, {})

      expect(section.draw).to eq(1)
    end
  end

  # NOTE: all other private methods will be tested by specs in bill_spec.rb
end
