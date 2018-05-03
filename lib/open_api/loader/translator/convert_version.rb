class OpenAPI::Loader::Translator
  #
  # Wraps the schema and changes version of the OAS
  # @private
  #
  class ConvertVersion < SimpleDelegator
    def call
      delete "swagger"
      self["openapi"] = "3.0.0"
    end
  end
end
