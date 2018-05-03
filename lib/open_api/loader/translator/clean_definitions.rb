class OpenAPI::Loader::Translator
  #
  # Cleans definitions that aren't in use any more, because all references
  # to them were expanded by [OpenAPI::Loader::Collector].
  #
  # @private
  #
  class CleanDefinitions < SimpleDelegator
    def call
      KEYS.each { |key| delete(key) }
    end

    # Keys to be dropped
    KEYS = %w[definitions parameters responses].freeze
  end
end
