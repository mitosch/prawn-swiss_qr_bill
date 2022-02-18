# frozen_string_literal: true

module Prawn
  module SwissQRBill
    module Helpers
      # Helpers to format numbers
      module NumberHelper
        def format_with_delimiter(number)
          left, right = format('%.2f', number).split('.')
          left.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/) { |d| "#{d} " }
          [left, right].compact.join('.')
        end
      end
    end
  end
end
