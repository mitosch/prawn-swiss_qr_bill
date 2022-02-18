# frozen_string_literal: true

describe Prawn::SwissQRBill::Bill do
  let(:document) { Prawn::Document.new(page_size: 'A4') }

  let(:bill_full) { DataManager.build_bill }

  describe '.new' do
    it 'initializes a new bill' do
      bill = described_class.new(document, {})

      expect(bill).to be_a(described_class)
    end
  end

  describe '#draw' do
    it 'draws all the sections' do
      described_class.new(document, bill_full).draw

      reader = PDF::Reader.new(StringIO.new(document.render))

      expect(reader.pages.length).to eq(1)
    end
  end

  describe 'scanarios' do
    let(:outfile) { "#{TMP_DIR}/outfile.pdf" }
    let(:reader_for_bill) do
      document.text 'A Test-Bill'
      document.swiss_qr_bill(bill_data)
      document.render_file(outfile)
      PDF::Reader.new(outfile)
    end

    before do
      FileUtils.rm(outfile) if File.exist?(outfile)
    end

    context 'when full bill' do
      let(:bill_data) { DataManager.build_bill }
      # let(:i18n_test_keys) { %i[payment creditor amount currency acceptance] }

      %i[de fr it en].each do |lang|
        it "generates a bill in #{lang}" do
          I18n.locale = lang
          i18n_test_keys = %i[payment creditor amount currency acceptance]
          i18n_test_texts = i18n_test_keys.map { |k| I18n.t(k, scope: 'swiss_qr_bill') }

          pdf_text = reader_for_bill.pages[0].text

          expect(i18n_test_texts).to be_all { |t| pdf_text.include?(t) }
        end
      end
    end

    context 'when no debtor' do
      let(:bill_data) { DataManager.build_bill(:no_debtor) }

      it 'generates a correct pdf' do
        expect(reader_for_bill.pages.length).to eq(1)
      end

      it 'uses another label' do
        expect(reader_for_bill.pages[0].text).to include(I18n.t('debtor_blank', scope: 'swiss_qr_bill'))
      end
    end

    context 'when no debtor and no reference' do
      let(:bill_data) { DataManager.build_bill(:no_debtor_ref) }

      it 'generates a correct pdf' do
        expect(reader_for_bill.pages.length).to eq(1)
      end

      it 'uses another label' do
        expect(reader_for_bill.pages[0].text).to include(I18n.t('debtor_blank', scope: 'swiss_qr_bill'))
      end

      it 'does not have a reference' do
        expect(reader_for_bill.pages[0].text).not_to include(I18n.t('reference', scope: 'swiss_qr_bill'))
      end
    end

    context 'when no debtor, no reference, and no amount' do
      let(:bill_data) { DataManager.build_bill(:no_debtor_ref_amount) }

      it 'generates a correct pdf' do
        expect(reader_for_bill.pages.length).to eq(1)
      end

      it 'uses another label' do
        expect(reader_for_bill.pages[0].text).to include(I18n.t('debtor_blank', scope: 'swiss_qr_bill'))
      end

      it 'does not have a reference' do
        expect(reader_for_bill.pages[0].text).not_to include(I18n.t('reference', scope: 'swiss_qr_bill'))
      end
    end
  end
end
