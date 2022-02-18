# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Sections
      # Acceptance point section at receipt
      class ReceiptAcceptance < Section
        KEY = 'receipt.acceptance'

        def draw
          box do
            label I18n.t('acceptance', scope: i18n_scope), align: :right
          end
        end
      end
    end
  end
end
