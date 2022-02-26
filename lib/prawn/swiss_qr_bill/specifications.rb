# frozen_string_literal: true

module Prawn
  module SwissQRBill
    class SpecificationError < StandardError; end

    # Access common style specifications according to the style guide.
    #
    # Reference:
    # https://www.paymentstandards.ch/dam/downloads/style-guide-en.pdf
    class Specifications
      Spec = Struct.new(:default, :format)

      SPECS_FILE = 'specs.yml'

      DEFAULTS = {
        point: Spec.new(nil, ->(v) { from_mm(v) }),
        width: Spec.new(nil, ->(v) { from_mm(v) }),
        height: Spec.new(nil, ->(v) { from_mm(v) }),
        content_font_size: Spec.new,
        content_font_leading: Spec.new(0),
        content_font_style: Spec.new(:normal, ->(v) { v.to_sym }),
        label_font_size: Spec.new,
        label_font_leading: Spec.new(0),
        label_font_style: Spec.new(:bold, ->(v) { v.to_sym })
      }.freeze

      def initialize
        # OPTIMIZE: unnessecary assignement
        @specs = load_specs
      end

      def get(spec_key)
        @specs.dig(*key_path(spec_key)) || {}
      end

      def get_specs(spec_key)
        # get hash from yaml by path
        spec_values = get(spec_key)

        values = {}
        DEFAULTS.each_key do |key|
          # set defaults
          values[key] = DEFAULTS[key].default
          # overwrite if set
          values[key] = spec_values[key.to_s] if spec_values.key?(key.to_s)
          # format
          values[key] = DEFAULTS[key][:format].call(values[key]) if DEFAULTS[key][:format].is_a?(Proc)
        end

        spec_values = values.values_at(*DEFAULTS.keys)

        Struct.new(*DEFAULTS.keys).new(*spec_values)
      end

      # Transform a value or an array of values from mm to pt
      def self.from_mm(value)
        case value
        when Numeric
          value.mm
        when Array
          value.map(&:mm)
        else
          value
        end
      end

      private

      def load_specs
        @specs = YAML.load_file(File.expand_path(SPECS_FILE, File.dirname(__FILE__)))
      end

      def key_path(key)
        key.split('.')
      end
    end
  end
end
