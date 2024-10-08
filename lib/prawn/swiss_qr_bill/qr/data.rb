# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module QR
      class MissingIBANError < StandardError; end
      class InvalidIBANError < StandardError; end
      class InvalidReferenceError < StandardError; end

      # The data of the Swiss QR-bill
      #
      # References:
      # https://www.paymentstandards.ch/dam/downloads/ig-qr-bill-en.pdf
      # * Chapter 4, Page 25
      class Data
        # Field structure:
        # * :default => default value to be set, if key is not given
        # * :format  => Proc to call when generating output
        # * :skippable  => Do not output in QR data if not given
        # * :validation => Proc or symbol for validation
        #   * if Proc given: will be called with value as argument
        #   * if symbol given: method "#{:symbol}_validator" will be called with value as argument
        Field = Struct.new(:default, :format, :skippable, :validation)

        # Available fields of the QR code data, ordered.
        FIELDS = {
          # fixed: SPC
          qr_type: Field.new('SPC'),
          version: Field.new('0200'),
          # fixed: 1
          coding: Field.new('1'),
          iban: Field.new(nil, nil, false, :iban),
          # enum: S, K
          creditor_address_type: Field.new('K'),
          creditor_address_name: Field.new,
          creditor_address_line1: Field.new,
          creditor_address_line2: Field.new,
          creditor_address_postal_code: Field.new,
          creditor_address_city: Field.new,
          creditor_address_country: Field.new,
          # omit ultimate_creditor_* => for future use
          # enum: S, K
          ultimate_creditor_address_type: Field.new,
          ultimate_creditor_address_name: Field.new,
          ultimate_creditor_address_line1: Field.new,
          ultimate_creditor_address_line2: Field.new,
          ultimate_creditor_address_postal_code: Field.new,
          ultimate_creditor_address_city: Field.new,
          ultimate_creditor_address_country: Field.new,
          amount: Field.new(nil, ->(value) { value && format('%.2f', value) }),
          # enum: CHF, EUR
          currency: Field.new('CHF'),
          # enum: S, K
          debtor_address_type: Field.new,
          debtor_address_name: Field.new,
          debtor_address_line1: Field.new,
          debtor_address_line2: Field.new,
          debtor_address_postal_code: Field.new,
          debtor_address_city: Field.new,
          debtor_address_country: Field.new,
          # enum: QRR, SCOR, NON
          reference_type: Field.new('NON'),
          reference: Field.new(nil, ->(v) { v && v.delete(' ') }, false, :reference),
          unstructured_message: Field.new,
          # fixed: EPD
          trailer: Field.new('EPD'),
          bill_information: Field.new(nil, nil, true),
          # key-value pairs:
          alternative_parameters: Field.new(nil, nil, true)
        }.freeze

        attr_accessor(*FIELDS.keys)

        def initialize(fields = {}, options = {})
          @options = options || {}

          # set defaults
          FIELDS.each_key do |field|
            instance_variable_set(:"@#{field}", FIELDS[field].default)
          end

          # set given
          fields.each_key do |field|
            instance_variable_set(:"@#{field}", fields[field])
          end
        end

        def generate
          validate if @options[:validate]

          stack = []
          FIELDS.each_key do |k|
            var = instance_variable_get(:"@#{k}")

            # TODO: fix possible wrong format if alt parameters (last one) is given
            next if FIELDS[k][:skippable] && var.nil?

            # TODO: use #process; generate method should only call validate, then process, then render as string
            var = FIELDS[k][:format].call(var) if FIELDS[k][:format].is_a?(Proc)

            stack << var
          end
          stack.join("\r\n")
        end

        def process
          FIELDS.each_key do |k|
            var = instance_variable_get(:"@#{k}")

            instance_variable_set(:"@#{k}", FIELDS[k][:format].call(var)) if FIELDS[k][:format].is_a?(Proc)
          end
        end

        def validate
          FIELDS.each_key do |k|
            next unless FIELDS[k][:validation]

            var = instance_variable_get(:"@#{k}")

            call_validator(FIELDS[k][:validation], var)
          end

          true
        end

        private

        def call_validator(validator, value)
          case validator
          when Proc
            # NOTE: currently not in use
            # :nocov:
            validator.call(value)
            # :nocov:
          when Symbol
            send(:"#{validator}_validator", value)
          end
        end

        def iban_validator(value)
          # IBAN must be given
          raise MissingIBANError, 'IBAN is missing' if value.nil? || value.empty?

          # IBAN must be valid
          iban = IBAN.new(value)
          raise InvalidIBANError, "IBAN #{iban.prettify} is invalid" unless iban.valid?

          true
        end

        def reference_validator(value)
          reference = Reference.new(value, reference_type)

          unless %w[QRR SCOR].include?(reference_type)
            raise InvalidReferenceError, "Reference Type #{reference_type} invalid. Allowed: QRR, SCOR"
          end

          raise InvalidReferenceError, "Reference #{value} is invalid" unless reference.valid?

          true
        end
      end
    end
  end
end
