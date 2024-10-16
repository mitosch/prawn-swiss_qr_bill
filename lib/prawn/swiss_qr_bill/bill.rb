# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Bill renders the Swiss QR-bill at the bottom of a page
    class Bill
      FONT_DIR = File.expand_path("#{__dir__}/../../../assets/fonts")

      def initialize(document, data, options = {})
        @doc = document
        @data = data
        @options = options || {}
      end

      def draw
        set_font

        @doc.canvas do
          Sections.draw_all(@doc, @data, @options)
          CuttingLines.new(@doc).draw
        end
      end

      private

      def set_font
        @doc.font_families.update(
          'Noto' => {
            normal: "#{FONT_DIR}/noto/NotoSans-Regular.ttf",
            bold: "#{FONT_DIR}/noto/NotoSans-Regular.ttf"
          }
        )
        @doc.font 'Noto'
      end
    end
  end
end
