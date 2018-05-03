module OpenAPI::Loader
  #
  # Cleans definitions that aren't in use any more, because all references
  # to them were expanded by [OpenAPI::Loader::Collector].
  #
  # This couldn't have been done by collector because it should
  # cache the full structure for referencing.
  #
  # @private
  #
  module Cleaner
    module_function

    def call(source)
      source.reject { |key, _| KEYS.include? key }
    end

    # Keys to be dropped
    KEYS = %w[components definitions parameters responses].freeze
  end
end
