# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Information section at payment
      class PaymentInformation < Section
        KEY = 'payment.information'

        include Helpers::BoxHelper

        def draw
          box do
            draw_payable_to
            draw_reference if @data.key?(:reference)
            draw_additional_information if @data.key?(:additional_information)
            draw_payable_by
          end
        end

        private

        def draw_payable_to
          doc.pad_top(2.1) { label I18n.t('creditor', scope: i18n_scope) }
          content [@data[:creditor][:iban],
                   build_address(@data[:creditor][:address])].join("\n")

          line_spacing
        end

        def draw_reference
          label I18n.t('reference', scope: i18n_scope)
          content @data[:reference]

          line_spacing
        end

        def draw_additional_information
          label I18n.t('additional_info', scope: i18n_scope)
          content @data[:additional_information]

          line_spacing
        end

        def draw_payable_by
          if @data.key?(:debtor)
            label I18n.t('debtor', scope: i18n_scope)
            content build_address(@data[:debtor][:address])
          else
            label I18n.t('debtor_blank', scope: i18n_scope)

            doc.move_down 2
            corner_box(doc, [0, doc.cursor], width: 65.mm, height: 25.mm)
          end
        end
      end
    end
  end
end
