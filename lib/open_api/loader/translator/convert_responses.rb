class OpenAPI::Loader::Translator
  #
  # Builds 'response.content' from 'schema' and 'produces' parameters
  #
  # @private
  #
  class ConvertResponses < SimpleDelegator
    def call
      responses.each { |response| convert(response) }
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

    def responses
      Enumerator.new do |yielder|
        operations.each do |operation|
          responses = operation["responses"]
          next unless responses.is_a? Hash
          responses.each_value { |item| yielder << item if item.is_a? Hash }
        end
      end
    end

    def convert(response)
      content_types = Array response.delete("produces")
      schema =        Hash  response.delete("schema")
      return if content_types.empty?
      response["content"] = {}
      content_types.each do |type|
        response["content"][type] = {
          "schema" => type["/xml"] ? schema : drop_xml(schema)
        }
      end
    end

    def drop_xml(data)
      case data
      when Hash
        data.each_with_object({}) do |(key, val), obj|
          obj[key] = drop_xml(val) unless key == "xml"
        end
      when Array then data.map { |item| drop_xml(item) }
      else data
      end
    end
  end
end
