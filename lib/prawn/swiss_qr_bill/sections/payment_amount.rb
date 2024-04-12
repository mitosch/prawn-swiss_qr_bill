# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Amount section at payment
      #
      # TODO: allow EUR payment
      # TODO: find solution to put measurements to specs.yml
      # OPTIMIZE: refactor with receipt_amount
      class PaymentAmount < Section
        KEY = 'payment.amount'

        # width of the currency field with enough space for both variants
        CURRENCY_WIDTH = 14.mm

        # width of amount when amount has to be displayed
        AMOUNT_WIDTH = 29.mm

        # height of the amount label when corner-box has to be displayed
        AMOUNT_LABEL_HEIGHT = 4.mm

        # measurement of amount corner-box
        AMOUNT_BOX_WIDTH = 40.mm
        AMOUNT_BOX_HEIGHT = 15.mm

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
          doc.bounding_box([doc.bounds.left, doc.bounds.top],
                           width: CURRENCY_WIDTH, height: specs.height) do
            label I18n.t('currency', scope: i18n_scope)
            content @data.fetch(:currency, 'CHF')
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
          left = specs.width - AMOUNT_WIDTH

          doc.bounding_box([left, doc.bounds.top],
                           width: AMOUNT_WIDTH, height: specs.height) do
            label I18n.t('amount', scope: i18n_scope)
            # format_with_delimiter => NumberHelper
            content format_with_delimiter(@data[:amount])
          end
        end

        def draw_amount_label
          # amount label is not left aligned with the corner-box, subtract
          # the currency width for alignment
          left = CURRENCY_WIDTH

          # width is calculated by the leftover space
          width = specs.width - CURRENCY_WIDTH
          doc.bounding_box([left, doc.bounds.top],
                           width: width, height: AMOUNT_LABEL_HEIGHT) do
            label I18n.t('amount', scope: i18n_scope)
          end
        end

        def draw_amount_corner_box
          corner_box(doc, [specs.width - AMOUNT_BOX_WIDTH, doc.bounds.top - AMOUNT_LABEL_HEIGHT],
                     width: AMOUNT_BOX_WIDTH,
                     height: AMOUNT_BOX_HEIGHT)
        end
      end
    end
  end
end
