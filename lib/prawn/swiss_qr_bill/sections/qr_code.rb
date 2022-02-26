# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # QR code section
      #
      # The swiss cross is applied directly on the QR PNG. The PNG needs to be
      # resized down, that the swiss cross overlaps exactly 9x9 modules for a
      # QR-code of compression level :m.
      #
      # swiss_cross.png =>   166px ~>  7.mm
      # QR-code:            1090px <~ 46.mm
      #
      # TODO: iban check -> raise exception if configured
      class QRCode < Section
        KEY = 'payment.qr_code'

        QR_PX_SIZE = 1160

        SWISS_CROSS_FILE = File.expand_path("#{__dir__}/../../../../assets/images/swiss_cross.png")

        MAPPING = {
          creditor_address_type: %i[creditor address type],
          creditor_address_name: %i[creditor address name],
          creditor_address_line1: %i[creditor address line1],
          creditor_address_line2: %i[creditor address line2],
          creditor_address_postal_code: %i[creditor address postal_code],
          creditor_address_city: %i[creditor address city],
          creditor_address_country: %i[creditor address country],
          debtor_address_type: %i[debtor address type],
          debtor_address_name: %i[debtor address name],
          debtor_address_line1: %i[debtor address line1],
          debtor_address_line2: %i[debtor address line2],
          debtor_address_postal_code: %i[debtor address postal_code],
          debtor_address_city: %i[debtor address city],
          debtor_address_country: %i[debtor address country],
          amount: [:amount],
          currency: [:currency],
          reference: [:reference],
          reference_type: [:reference_type]
        }.freeze

        def draw
          png = qr_as_png(@data)
          add_swiss_cross!(png)

          io = StringIO.new(png.to_blob)

          box do
            doc.image io, width: specs.width
          end
        end

        private

        def qr_as_png(data)
          qr_data = generate_qr_data(data)
          qr = RQRCode::QRCode.new(qr_data, level: :m)
          png = qr.as_png(module_px_size: 20, border_modules: 0)
          png.resize(QR_PX_SIZE, QR_PX_SIZE)
        end

        def add_swiss_cross!(png)
          swiss_cross = ChunkyPNG::Image.from_file(SWISS_CROSS_FILE)

          png.compose!(
            swiss_cross,
            (png.width - swiss_cross.width) / 2,
            (png.height - swiss_cross.height) / 2
          )
        end

        def generate_qr_data(data)
          validate(data) if @options[:validate]

          flat_data = {}
          MAPPING.each_key do |key|
            # check if the key exists
            next unless deep_key?(data, MAPPING[key])

            flat_data[key] = data.dig(*MAPPING[key])
          end

          iban = IBAN.new(data[:creditor][:iban])

          qr_data = QR::Data.new(flat_data.merge(iban: iban.code))
          qr_data.generate
        end

        def validate(data)
          # IBAN must be given
          raise MissingIBANError, 'IBAN is missing' unless data[:creditor][:iban]

          iban = IBAN.new(data[:creditor][:iban])

          raise InvalidIBANError, "IBAN #{iban.prettify} is invalid" unless iban.valid?

          # reference may be missing (optional)
          return unless data[:reference]

          ref = Reference.new(data[:reference])

          raise InvalidReferenceError, "Reference #{@data[:reference]} is invalid" unless ref.valid?
        end

        # hash: hash to test key path for
        # key_path: array of symbols to search the key
        def deep_key?(hash, key_path)
          path = key_path.dup

          return false if path.empty?
          return hash.key?(path[0]) if path.length == 1

          last_key = path.pop

          !!hash.dig(*path)&.key?(last_key)
        end
      end
    end
  end
end
