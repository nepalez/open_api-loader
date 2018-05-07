class OpenAPI::Loader::Denormalizer
  #
  # Denormalizes all the 'parameters' definitions
  # by moving them from the root OpenAPI object and path objects
  # right into the corresponding operation objects.
  #
  # @private
  #
  class Parameters < SimpleDelegator
    def call
      root_params = extract_from(self)
      paths.each do |path|
        path_params = extract_from(path, root_params)
        operations(path).each do |operation|
          parameters = extract_from(operation, path_params)
          operation["parameters"] = parameters if parameters.any?
        end
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

    def operations(path)
      Enumerator.new do |yielder|
        path.each_value { |item| yielder << item if item.is_a? Hash }
      end
    end

    def extract_from(data, default = [])
      custom = Array(data.delete("parameters")).select do |item|
        item.is_a?(Hash) && item["name"]
      end

      custom_names = custom.map { |item| item["name"] }
      default.reject { |item| custom_names.include? item["name"] } + custom
    end
  end
end
