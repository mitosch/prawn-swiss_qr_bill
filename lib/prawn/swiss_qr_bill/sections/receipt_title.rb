# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Title section at receipt
      class ReceiptTitle < Section
        KEY = 'receipt.title'

        def draw
          box do
            content I18n.t('receipt', scope: i18n_scope)
          end
        end
      end
    end
  end
end
