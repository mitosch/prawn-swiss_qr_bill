# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Bill renders the Swiss QR-bill at the bottom of a page
    class Bill
      FONT_DIR = File.expand_path("#{__dir__}/../../../assets/fonts")

      def initialize(document, data)
        @doc = document
        @data = data
      end

      def draw
        set_font

        @doc.canvas do
          Sections.draw_all(@doc, @data)
          CuttingLines.new(@doc).draw
        end
      end

      private

      def set_font
        @doc.font_families.update(
          'Inter' => {
            normal: "#{FONT_DIR}/inter/Inter-Regular.ttf",
            bold: "#{FONT_DIR}/inter/Inter-Bold.ttf"
          }
        )
        @doc.font 'Inter'
      end
    end
  end
end
