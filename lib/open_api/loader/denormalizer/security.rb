class OpenAPI::Loader::Denormalizer
  #
  # Denormalizes all the 'security' definitions
  # by moving them from the root OpenAPI object
  # right into the corresponding operation objects.
  #
  # @private
  #
  class Security < SimpleDelegator
    def call
      default = delete "security"
      operations.each do |operation|
        operation["security"] ||= default if default
      end
    end

    private

    def paths
      Enumerator.new do |yielder|
        fetch("paths", {}).each_value do |path|
          yielder << path if path.is_a? Hash
        end
      end
    end

    def operations
      Enumerator.new do |yielder|
        paths.each do |path|
          path.each_value { |item| yielder << item if item.is_a? Hash }
        end
      end
    end
  end
end
