require "constructor_shortcut"
require "dry-initializer"
require "json"
require "yaml"
require "uri"
require "delegate"

#
# Namespace for gems dealing with OAS specifications
#
module OpenAPI
  #
  # Loads OAS specification from a file and converts it to OAS3 format
  #
  # @see OAS2
  #   https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md
  # @see OAS3
  #   https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md
  #
  module Loader
    module_function

    require_relative "loader/ref"
    require_relative "loader/reader"
    require_relative "loader/collector"
    require_relative "loader/translator"
    require_relative "loader/denormalizer"

    #
    # Loads the specification from given file
    #
    # @param  [String]  filename The name of file containing a specification
    # @option [Boolean] :denormalize Whether to denormalize specification
    # @return [Hash] the specification
    #
    def call(filename, denormalize: true)
      normalized = [Collector, Translator].inject(filename) do |output, item|
        item.call(output)
      end

      denormalize ? Denormalizer.call(normalized) : normalized
    end
  end
end
