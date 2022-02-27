# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Check validity of reference number
    #
    # QRR reference:
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

      def initialize(reference, type = 'QRR')
        @type = type
        @reference = standardize(reference)
      end

      # Number without check digit
      def number
        case @type
        when 'QRR'
          @reference[0...-1]
        when 'SCOR'
          @reference[4..-1]
        end
      end

      # QRR: Last number, the check digit
      # SCOR: 2 numbers after RF
      def check_digits
        case @type
        when 'QRR'
          @reference[-1].to_i
        when 'SCOR'
          @reference[2..3]
        end
      end

      def valid?
        valid_check_digits? && valid_length?
      end

      def valid_check_digits?
        case @type
        when 'QRR'
          check_digits == modulo10_recursive(number)
        when 'SCOR'
          scor_to_i % 97 == 1
        end
      end

      # NOTE: for SCOR only
      def scor_to_i
        "#{number}RF#{check_digits}".gsub(/[A-Z]/) { |c| c.ord - 55 }.to_i
      end

      # According to the payment standards (PDF, Annex B):
      # The QR reference consists of 27 positions and is numerical.
      def valid_length?
        case @type
        when 'QRR'
          @reference.length <= 27
        when 'SCOR'
          @reference.length <= 25
        end
      end

      private

      def standardize(reference)
        reference.to_s.strip.gsub(/\s+/, '').upcase
      end

      def modulo10_recursive(reference)
        numbers = reference.to_s.chars.map(&:to_i)
        report = numbers.inject(0) { |memo, c| MODULO_TABLE[memo][c] }

        (10 - report) % 10
      end
    end
  end
end
