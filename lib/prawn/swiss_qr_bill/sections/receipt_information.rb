# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Information section at receipt
      class ReceiptInformation < Section
        KEY = 'receipt.information'

        include Helpers::BoxHelper

        def draw
          box do
            draw_payable_to
            draw_reference if @data.key?(:reference)
            draw_payable_by
          end
        end

        private

        def draw_payable_to
          label I18n.t('creditor', scope: i18n_scope)
          content [@data[:creditor][:iban],
                   build_address(@data[:creditor][:address])].join("\n")

          line_spacing
        end

        def draw_reference
          label I18n.t('reference', scope: i18n_scope)
          content @data[:reference]

          line_spacing
        end

        def draw_payable_by
          if @data.key?(:debtor)
            label I18n.t('debtor', scope: i18n_scope)
            content build_address(@data[:debtor][:address])
          else
            label I18n.t('debtor_blank', scope: i18n_scope)

            doc.move_down 2
            corner_box(doc, [0, doc.cursor], width: 52.mm, height: 20.mm)
          end
        end
      end
    end
  end
end
