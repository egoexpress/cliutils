require 'uri'

module CLIUtils
  # PrefValidation Module
  # Validation rules that can be applied to a Pref.
  module PrefValidation
    Validator = Struct.new(:code, :message)

    # Validates that a value is only letters.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.alphabetic(text)
      m = "Response is not alphabetic: #{ text }"
      c = text.to_s =~ /\A[A-Za-z\s]+\z/
      Validator.new(c, m)
    end

    # Validates that a value is only letters and numbers.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.alphanumeric(text)
      m = "Response is not alphanumeric: #{ text }"
      c = text.to_s =~ /\A[A-Za-z0-9\s]+\z/
      Validator.new(c, m)
    end

    # Validates that a value is a date.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.date(text)
      m = "Response is not a date: #{ text }"
      c = !(Date.parse(text) rescue nil).nil?
      Validator.new(c, m)
    end

    # Validates that a value is passed and is not
    # empty.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.non_nil(text)
      m = 'Nil text not allowed'
      c = !text.nil? && !text.empty?
      Validator.new(c, m)
    end

    # Validates that a value is some sort of number.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.numeric(text)
      m = "Response is not a number: #{ text }"
      c = text.to_s =~ /\A[-+]?\d*\.?\d+\z/
      Validator.new(c, m)
    end

    # Validates that passed value is a URL.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.url(text)
      m = "Response is not a url: #{ text }"
      c = text.to_s =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      Validator.new(c, m)
    end
  end
end