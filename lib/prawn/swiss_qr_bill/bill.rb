# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Bill renders the Swiss QR-bill at the bottom of a page
    class Bill
      def initialize(document, data)
        @doc = document
        @data = data
      end

      def draw
        @doc.canvas do
          Sections.draw_all(@doc, @data)
          CuttingLines.new(@doc).draw
        end
      end
    end
  end
end
