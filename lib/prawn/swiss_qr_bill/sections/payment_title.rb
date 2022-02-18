# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Title section at payment
      class PaymentTitle < Section
        KEY = 'payment.title'

        def draw
          box do
            content I18n.t('payment', scope: i18n_scope)
          end
        end
      end
    end
  end
end
