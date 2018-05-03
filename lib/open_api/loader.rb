require "constructor_shortcut"
require "dry-initializer"
require "json"
require "yaml"
require "uri"

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
    require_relative "loader/cleaner"

    #
    # Loads the specification from given file
    #
    # @param  [String]  _filename The name of file containing a specification
    # @option [Boolean] :_clean Whether a loader should clean the specification
    # @return [Hash] the specification
    #
    def load(_filename, _clean: true)
      raise NotImplementedError
    end
  end
end
