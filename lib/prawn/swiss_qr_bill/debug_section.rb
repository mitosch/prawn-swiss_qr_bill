# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Draws a blue debug section.
    #
    # Reference:
    # https://www.paymentstandards.ch/dam/downloads/style-guide-en.pdf
    #
    # OPTIMIZE: move several general styling functions to helpers (bb-helper)
    class DebugSection
      SECTIONS = [
        'receipt',
        'receipt.title',
        'receipt.information',
        'receipt.amount',
        'receipt.acceptance',
        'payment',
        'payment.title',
        'payment.information',
        'payment.qr_code',
        'payment.qr_cross',
        'payment.amount',
        'payment.further_information'
      ].freeze

      attr_reader :doc, :properties

      def initialize(document)
        @doc = document

        @brain = { font: {}, border: { color: nil, width: nil } }

        @spec = Prawn::SwissQRBill::Specifications.new
      end

      def draw
        SECTIONS.each do |section|
          name = @spec.get(section)['name']
          specs = @spec.get_specs(section)
          point = specs.point
          options = { width: specs.width, height: specs.height }.merge(
            text: name,
            background: false, border: true, font_size: 10
          )

          draw_debug_box(point, options)
        end
      end

      private

      # Draws a box like in the style guide.
      #
      # NOTE: Background removed for simplicity, color was: D4EDFC
      def draw_debug_box(*args)
        position = args[0]
        text = args[1].delete(:text)
        border_style = { color: '71C4E9', width: 0.75 } if args[1][:border]
        debug_box_opts = args[1].merge(padding: 1.mm,
                                       border: border_style,
                                       font: { size: args[1][:font_size] })

        draw_padded_box(position, debug_box_opts) do
          doc.text text, color: '71C4E9'
        end
      end

      def draw_padded_box(*args, &block)
        padding = args[1].delete(:padding) || 0

        doc.bounding_box(*args) do
          height = doc.bounds.height
          width = doc.bounds.width

          ensure_styles(args[1])

          doc.bounding_box([padding, height - padding],
                           width: width - (2 * padding),
                           height: height - (2 * padding)) { yield block }
        end

        reset_styles
      end

      # ensures setting the styles by meaningful options:
      #
      # {
      #   border: { color: '123456', width: 2 },
      #   font: { size: 10 }
      # }
      def ensure_styles(opts)
        stroke_style(opts[:border])
        font_style(opts[:font])
      end

      def stroke_style(opts)
        return unless opts

        remember_style(:border)

        doc.line_width opts[:width]
        doc.stroke_color opts[:color]
        doc.stroke_bounds
      end

      def font_style(opts)
        return unless opts

        remember_style(:font)
        doc.font_size opts[:size]
      end

      def remember_style(style_type)
        case style_type
        when :font
          @brain[:font][:size] = doc.font_size
        when :border
          @brain[:border][:color] = doc.line_width
          @brain[:border][:width] = doc.stroke_color
        end
      end

      def reset_styles
        reset_style(:font)
        reset_style(:border)
      end

      def reset_style(style_type)
        case style_type
        when :font
          doc.font_size @brain[:font][:size]
        when :border
          doc.line_width @brain[:border][:color]
          doc.stroke_color @brain[:border][:width]
        end
      end
    end
  end
end
