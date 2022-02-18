# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Sections module manages all different sections.
    module Sections
      # All relevant classes to draw the full bill,
      # ordered by drawing order.
      SECTION_CLASSES = [
        ReceiptTitle,
        ReceiptInformation,
        ReceiptAmount,
        ReceiptAcceptance,
        PaymentTitle,
        PaymentInformation,
        PaymentAmount,
        PaymentFurtherInformation,
        QRCode
      ].freeze

      # Draw all sections in the right order.
      def self.draw_all(document, data)
        SECTION_CLASSES.each do |klass|
          klass.new(document, data).draw
        end
      end
    end
  end
end
