# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Check validity of IBAN.
    #
    # NOTE: *For Switzerland only*
    #
    # Simple implementation according to
    # https://en.wikipedia.org/wiki/International_Bank_Account_Number#Algorithms
    #
    # TODO: validate QR-iban
    class IBAN
      attr_reader :code

      def initialize(code)
        @code = standardize(code)
      end

      def country_code
        @code[0..1]
      end

      def check_digits
        @code[2..3]
      end

      def bban
        @code[4..-1]
      end

      # Convert Alpha-Numeric IBAN to numeric values (incl. rearrangement)
      #
      # Reference:
      # https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN
      def to_i
        "#{bban}#{country_code}#{check_digits}".gsub(/[A-Z]/) { |c| c.ord - 55 }.to_i
      end

      def prettify
        @code.gsub(/(.{4})/, '\1 ').strip
      end

      # valid IBAN:
      # CH77 8080 8004 1110 4136 9
      #
      # valid QR-IBAN:
      # CH08 3080 8004 1110 4136 9
      def valid?
        valid_check_digits? && valid_swiss_length? && valid_country?
      end

      def valid_check_digits?
        to_i % 97 == 1
      end

      # NOTE: Only the length for Switzerland is implemented because it is Swiss QR-bill specific
      def valid_length?
        valid_swiss_length?
      end

      def valid_swiss_length?
        @code.length == 21
      end

      def valid_country?
        country_code == 'CH'
      end

      private

      # Make the given string standard:
      #
      # CH21 2345 2123 5543 5554
      # ch21 2345 2123 5543 5554
      # " ch21 2345  2123 5543  5554 "
      #
      # => CH212345212355435554
      def standardize(code)
        code.to_s.strip.gsub(/\s+/, '').upcase
      end
    end
  end
end
