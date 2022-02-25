# frozen_string_literal: true

module Prawn
  module SwissQRBill
    class InvalidReferenceError < StandardError; end

    # Check validity of reference number
    #
    # Refer to the implementation guides of SIX: https://www.paymentstandards.ch/dam/downloads/ig-qr-bill-en.pdf
    class Reference
      MODULO_TABLE = [
        [0, 9, 4, 6, 8, 2, 7, 1, 3, 5],
        [9, 4, 6, 8, 2, 7, 1, 3, 5, 0],
        [4, 6, 8, 2, 7, 1, 3, 5, 0, 9],
        [6, 8, 2, 7, 1, 3, 5, 0, 9, 4],
        [8, 2, 7, 1, 3, 5, 0, 9, 4, 6],
        [2, 7, 1, 3, 5, 0, 9, 4, 6, 8],
        [7, 1, 3, 5, 0, 9, 4, 6, 8, 2],
        [1, 3, 5, 0, 9, 4, 6, 8, 2, 7],
        [3, 5, 0, 9, 4, 6, 8, 2, 7, 1],
        [5, 0, 9, 4, 6, 8, 2, 7, 1, 3]
      ].freeze

      def initialize(reference)
        @reference = standardize(reference)
      end

      # Number without check digit
      def number
        @reference[0...-1]
      end

      # Last number, the check digit
      def check_digit
        @reference[-1].to_i
      end

      def valid?
        valid_check_digit? && valid_length?
      end

      def valid_check_digit?
        check_digit == modulo10_recursive(number)
      end

      # According to the payment standards (PDF, Annex B):
      # The QR reference consists of 27 positions and is numerical.
      def valid_length?
        @reference.length <= 27
      end

      private

      def standardize(reference)
        reference.to_s.strip.gsub(/\s+/, '')
      end

      def modulo10_recursive(reference)
        numbers = reference.to_s.chars.map(&:to_i)
        report = numbers.inject(0) { |memo, c| MODULO_TABLE[memo][c] }

        (10 - report) % 10
      end
    end
  end
end
