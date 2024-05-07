# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Amount section at receipt
      #
      # TODO: allow EUR payment
      # TODO: find solution to put measurements to specs.yml
      # OPTIMIZE: refactor with payment_amount
      class ReceiptAmount < Section
        KEY = 'receipt.amount'

        # width of the currency field with enough space for both variants
        CURRENCY_WIDTH = 11.mm

        # measurement of the box for the amount as value and as corner-box
        AMOUNT_BOX_WIDTH = 30.mm
        AMOUNT_BOX_HEIGHT = 10.mm

        # padding of the amount label to corner-box
        AMOUNT_LABEL_PAD = 1.mm

        include Helpers::NumberHelper
        include Helpers::BoxHelper

        def draw
          box do
            draw_currency
            draw_amount
          end
        end

        private

        def draw_currency
          # use the half width of the available size: space for amount-box
          doc.bounding_box([doc.bounds.left, doc.bounds.top],
                           width: CURRENCY_WIDTH, height: specs.height) do
            doc.pad_top(1.4) { label I18n.t('currency', scope: i18n_scope) }
            doc.pad_top(2.5) { content @data.fetch(:currency, 'CHF') }
          end
        end

        def draw_amount
          if @data.key?(:amount)
            draw_amount_label_and_value
          else
            draw_amount_label
            draw_amount_corner_box
          end
        end

        def draw_amount_label_and_value
          # amount value is placed where the box would be, same width/height
          left = specs.width - AMOUNT_BOX_WIDTH
          doc.bounding_box([left, doc.bounds.top],
                           width: AMOUNT_BOX_WIDTH, height: specs.height) do
            doc.pad_top(1.4) { label I18n.t('amount', scope: i18n_scope) }
            # format_with_delimiter => NumberHelper
            doc.pad_top(2.5) { content format_with_delimiter(@data[:amount]) }
          end
        end

        def draw_amount_label
          # amount label is pushed to left, right after the currency box,
          # which is the currency width
          left = CURRENCY_WIDTH

          # width is calculated by the left over space - 1.mm padding
          width = specs.width - CURRENCY_WIDTH - AMOUNT_BOX_WIDTH - AMOUNT_LABEL_PAD
          doc.bounding_box([left, doc.bounds.top],
                           width: width, height: specs.height) do
            doc.pad_top(1.4) { label I18n.t('amount', scope: i18n_scope), align: :right }
          end
        end

        def draw_amount_corner_box
          corner_box(doc, [specs.width - AMOUNT_BOX_WIDTH, doc.bounds.top - 1.4],
                     width: AMOUNT_BOX_WIDTH,
                     height: AMOUNT_BOX_HEIGHT)
        end
      end
    end
  end
end
