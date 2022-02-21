# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Horizontal and vertical cutting lines with a scissor symbol
    class CuttingLines
      SCISSOR_FILE = File.expand_path("#{__dir__}/images/scissor.png")

      SCISSOR_WIDTH = 5.mm
      SCISSOR_HEIGHT = 3.mm

      PAD_LEFT = 5.mm
      PAD_TOP = 1.mm

      attr_reader :doc, :receipt_width, :receipt_height

      def initialize(document)
        @doc = document

        @brain = { border: { color: nil, width: nil } }

        load_specs
      end

      def draw
        set_styles

        draw_strokes
        draw_scissors

        reset_styles
      end

      private

      def load_specs
        specs = Specifications.new
        @receipt_height = specs.get('receipt.height').mm
        @receipt_width = specs.get('receipt.width').mm
      end

      def set_styles
        @brain[:border][:width] = doc.line_width
        @brain[:border][:color] = doc.stroke_color

        doc.stroke_color '000000'
        doc.line_width 0.5
        doc.dash 2, space: 2
      end

      def draw_strokes
        doc.stroke { doc.line [0, receipt_height], [doc.bounds.right, receipt_height] }
        doc.stroke { doc.line [receipt_width, receipt_height], [receipt_width, doc.bounds.bottom] }
      end

      def draw_scissors
        doc.bounding_box([doc.bounds.left + PAD_LEFT, receipt_height + (SCISSOR_HEIGHT / 2)],
                         width: SCISSOR_WIDTH, height: SCISSOR_HEIGHT) do
          doc.image SCISSOR_FILE, width: SCISSOR_WIDTH
        end

        doc.bounding_box([receipt_width - (SCISSOR_HEIGHT / 2), receipt_height - PAD_TOP],
                         width: SCISSOR_WIDTH, height: SCISSOR_HEIGHT) do
          doc.rotate(270, origin: [0, 0]) do
            doc.image SCISSOR_FILE, width: SCISSOR_WIDTH
          end
        end
      end

      def reset_styles
        doc.line_width = @brain[:border][:width]
        doc.stroke_color = @brain[:border][:color]
        doc.undash
      end
    end
  end
end
