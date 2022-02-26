# frozen_string_literal: true

# Support different data structures
class DataManager
  DATA_FILE = 'bill_data.yml'

  attr_reader :data

  def initialize
    @data = {}

    load_data
  end

  def bill(key)
    @data[:bill_data][key]
  end

  def self.build_bill(option = :default)
    new.bill(option)
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
end
