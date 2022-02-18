# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Helpers
      # Helpers for drawing boxes
      module BoxHelper
        def corner_box(doc, point, options)
          Prawn::SwissQRBill::CornerBox.new(doc, point, options).draw
        end
      end
    end
  end
end
