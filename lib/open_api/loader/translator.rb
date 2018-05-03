module OpenAPI::Loader
  #
  # Translates OAS2 to OAS3 specification
  # @private
  #
  class Translator
    extend Dry::Initializer
    extend ConstructorShortcut[:call] # class-level .call

    param :source

    def call
      return source unless oas2?
      WRAPPERS.each { |wrapper| wrapper.new(source).call }
      source
    end

    private

    def oas2?
      source.is_a?(Hash) && source["swagger"].to_s.start_with?("2")
    end

    require_relative "translator/clean_definitions"
    require_relative "translator/convert_bodies"
    require_relative "translator/convert_forms"
    require_relative "translator/convert_parameters"
    require_relative "translator/convert_responses"
    require_relative "translator/convert_security_schemes"
    require_relative "translator/convert_servers"
    require_relative "translator/convert_version"
    require_relative "translator/denormalize_consumes"
    require_relative "translator/denormalize_parameters"
    require_relative "translator/denormalize_produces"

    WRAPPERS = [
      CleanDefinitions,
      DenormalizeParameters,
      DenormalizeConsumes,
      DenormalizeProduces,
      ConvertForms,
      ConvertBodies,
      ConvertParameters,
      ConvertResponses,
      ConvertServers,
      ConvertSecuritySchemes,
      ConvertVersion
    ].freeze
  end
end
