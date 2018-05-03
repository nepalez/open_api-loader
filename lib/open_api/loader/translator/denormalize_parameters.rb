class OpenAPI::Loader::Translator
  #
  # Denormalizes 'parameters' of 'body' and 'formData' rigth into operations
  # This is needed for building a 'requestBody' part of the schema
  # from 'parameters' and 'consumes'.
  #
  # @private
  #
  class DenormalizeParameters < SimpleDelegator
    def call
      root_params = extract(self)
      paths.each do |path|
        path_params = merge root_params, extract(path)
        operations(path).each do |operation|
          parameters = merge path_params, params(operation)
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

    def params(data)
      items = data.delete("parameters")
      return [] unless items.is_a? Array
      items.select { |item| item.is_a?(Hash) && item["in"] && item["name"] }
    end

    def extract(data)
      body, non_body = \
        params(data).partition { |item| %w[body formData].include? item["in"] }
      data["parameters"] = non_body if non_body.any?
      body
    end

    def merge(left, right)
      names = right.map { |item| item["name"] }
      left.reject { |item| names.include? item["name"] } + right
    end
  end
end
