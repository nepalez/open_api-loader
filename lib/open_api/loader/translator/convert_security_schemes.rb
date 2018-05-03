class OpenAPI::Loader::Translator
  #
  # Wraps the schema and moves its securityDefinitions
  # to components.securitySchemes
  #
  # Translates every securityScheme for oauth2 into new format.
  #
  # @private
  #
  class ConvertSecuritySchemes < SimpleDelegator
    def call
      return unless schemes.is_a? Hash
      convert_oauth_schemes
      self["components"] = { "securitySchemes" => schemes }
    end

    private

    def schemes
      @schemes ||= delete("securityDefinitions")
    end

    def oauth_keys
      @oauth_keys ||= schemes.select do |_, scheme|
        scheme.is_a?(Hash) && scheme["type"] == "oauth2"
      end.keys
    end

    def convert_oauth_schemes
      oauth_keys.each { |key| convert_scheme(key) }
    end

    def convert_scheme(key)
      scheme = schemes[key]
      flow   = scheme["flow"]
      flow   = FLOWS.fetch(flow, flow)
      data   = scheme.select { |detail| DETAILS.include? detail }

      schemes[key] = { "type" => "oauth2", "flows" => { flow => data } }
    end

    FLOWS = {
      "application" => "clientCredentials",
      "accessCode"  => "authorizationCode",
    }.freeze

    DETAILS = %w[authorizationUrl tokenUrl scopes]
  end
end
