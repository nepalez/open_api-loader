module OpenAPI::Loader
  #
  # Denormalizes OAS3 `parameters`, `servers`, and `security`
  # by moving them from OpenAPI root and Path objects
  # right into the corresponding Operation objects.
  #
  # @private
  #
  class Denormalizer
    require_relative "denormalizer/parameters"
    require_relative "denormalizer/security"
    require_relative "denormalizer/servers"

    extend Dry::Initializer
    extend ConstructorShortcut[:call] # class-level .call

    param :source

    def call
      WRAPPERS.each { |wrapper| wrapper.new(source).call }
      source
    end

    WRAPPERS = [Parameters, Security, Servers].freeze
  end
end
