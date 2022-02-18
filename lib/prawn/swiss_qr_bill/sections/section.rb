# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Section main class which can draw itself at the right position.
      #
      # Subclasses shall implement the draw method with the box block:
      #
      #   def draw
      #     box do
      #       doc.text 'example'
      #       draw_something
      #     end
      #   end
      class Section
        attr_reader :doc

        # specifications for subclass' section, @see Specification for details
        attr_accessor :specs

        def initialize(document, data)
          unless self.class.const_defined?(:KEY)
            raise NotImplementedError, "constant KEY not defined in class #{self.class}"
          end

          @doc = document
          @data = data

          load_specs
        end

        def draw
          raise NotImplementedError, 'Subcluss must implement draw method.'
        end

        private

        def box(&block)
          doc.bounding_box(specs.point, width: specs.width, height: specs.height, &block)
        end

        def label(text, options = {})
          options = options.merge(
            size: specs.label_font_size,
            leading: specs.label_font_leading,
            style: specs.label_font_style.to_sym
          )

          doc.text text, options
        end

        def content(text, options = {})
          options = options.merge(
            size: specs.content_font_size,
            leading: specs.content_font_leading,
            style: specs.content_font_style.to_sym
          )

          doc.text text, options
        end

        def line_spacing
          doc.move_down specs.content_font_size + 1
        end

        def build_address(address)
          [
            address[:name],
            address[:line1],
            address[:line2],
            [address[:postal_code], address[:city]].join(' ')
          ].compact.join("\n")
        end

        def load_specs
          spec_factory = Prawn::SwissQRBill::Specifications.new

          self.specs = spec_factory.get_specs(self.class::KEY)
        end

        def i18n_scope
          'swiss_qr_bill'
        end
      end
    end
  end
end
