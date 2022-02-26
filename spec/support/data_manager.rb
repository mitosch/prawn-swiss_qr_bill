# frozen_string_literal: true

# Support different data structures
class DataManager
  DATA_FILE = 'bill_data.yml'

  MAPPING = Prawn::SwissQRBill::Sections::QRCode::MAPPING

  attr_reader :data

  def initialize
    @data = {}

    load_data
  end

  def bill_data(key)
    @data[:bill_data][key]
  end

  def flat_data(key)
    data = bill_data(key)

    flat_data = {}
    MAPPING.each_key do |k|
      # check if the key exists
      next unless deep_key?(data, MAPPING[k])

      flat_data[k] = data.dig(*MAPPING[k])
    end

    iban = Prawn::SwissQRBill::IBAN.new(data[:creditor][:iban])

    flat_data.merge(iban: iban.code)
  end

  def self.build_bill(option = :default, flat: false)
    if flat
      new.flat_data(option)
    else
      new.bill_data(option)
    end
  end

  private

  def load_data
    @data = YAML.load_file(File.expand_path(DATA_FILE, File.dirname(__FILE__)))
    @data = symbolize_keys(@data)
  end

  # rubocop:disable Metrics/MethodLength
  def symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key = case key
                when String then key.to_sym
                else key
                end
      new_value = case value
                  when Hash then symbolize_keys(value)
                  else value
                  end
      result[new_key] = new_value
    end
  end
  # rubocop:enable Metrics/MethodLength

  # NOTE: copied from qr_code.rb
  #
  # hash: hash to test key path for
  # key_path: array of symbols to search the key
  def deep_key?(hash, key_path)
    path = key_path.dup

    return false if path.empty?
    return hash.key?(path[0]) if path.length == 1

    last_key = path.pop

    !!hash.dig(*path)&.key?(last_key)
  end
end
