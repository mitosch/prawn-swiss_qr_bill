# frozen_string_literal: true

module Prawn
  # Attach padded_box to Prawn
  #
  #   padded_box(point, options = {}, &block)
  #
  # NOTE: not in use, not working properly. it is not easy to stroke the outer box.
  #   was an idea for DebugSection, maybe deprecate/remove or make it work later.
  #
  # :nocov:
  class Document
    def padded_box(point, *args, &block)
      init_padded_box(block) do |parent_box|
        point = map_to_absolute(point)
        @bounding_box = PaddedBox.new(self, parent_box, point, *args)
      end
    end

    private

    def init_padded_box(user_block)
      # binding.pry
      parent_box = @bounding_box

      yield(parent_box)

      self.y = @bounding_box.absolute_top

      pad = @bounding_box.padding
      bounding_box([@bounding_box.left + pad, @bounding_box.top - pad],
                   width: @bounding_box.width - (2 * pad),
                   height: @bounding_box.height - (2 * pad)) do
        user_block.call
      end

      @bounding_box = parent_box
    end
  end

  # Bounding box with padding
  class PaddedBox < Prawn::Document::BoundingBox
    attr_reader :padding

    def initialize(document, parent, point, options = {})
      super

      @padding = options[:padding] || 0
    end
  end
  # :nocov:
end
