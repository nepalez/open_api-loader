class OpenAPI::Loader::Translator
  #
  # Adds 'schema', 'style' and 'explode' to values of 'parameters'.
  #
  # @private
  #
  class ConvertParameters < SimpleDelegator
    def call
      parameters.each { |parameter| convert(parameter) }
    end

    private

    def parameters
      Enumerator.new do |yielder|
        root_parameters.each { |item| yielder << item }
        path_parameters.each { |item| yielder << item }
        operation_parameters.each { |item| yielder << item }
        headers.each { |item| yielder << item }
      end
    end

    def convert(item)
      place   = item["in"]
      format  = item.delete "collectionFormat"
      style   = style(place, format)
      explode = explode(format)
      schema  = schema(item)

      item.update("schema" => schema).update(style).update(explode)
    end

    def params(item)
      Array item.fetch("parameters", [])
    end

    def root_parameters
      Enumerator.new do |yielder|
        params(self).each { |item| yielder << item if item.is_a? Hash }
      end
    end

    def path_parameters
      Enumerator.new do |yielder|
        paths.each do |path|
          params(path).each { |item| yielder << item if item.is_a? Hash }
        end
      end
    end

    def operation_parameters
      Enumerator.new do |yielder|
        operations.each do |operation|
          params(operation).each { |item| yielder << item if item.is_a? Hash }
        end
      end
    end

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
          operation.fetch("responses", {}).each_value do |item|
            yielder << item if item.is_a? Hash
          end
        end
      end
    end

    def headers
      Enumerator.new do |yielder|
        responses.each do |response|
          response.fetch("headers", {}).each_value do |item|
            yielder << item if item.is_a? Hash
          end
        end
      end
    end

    def style(place, format)
      case format
      when "csv"
        { "style" => (%w[query cookie].include?(place) ? "form" : "simple") }
      when "ssv"   then { "style" => "spaceDelimited" }
      when "pipes" then { "style" => "pipeDelimited" }
      when "multi" then { "style" => "form" }
      else {}
      end
    end

    def explode(format)
      format == "multi" ? { "explode" => true } : {}
    end

    def schema(item)
      SCHEMA_KEYS.each_with_object({}) do |key, obj|
        obj[key] = item.delete(key) if item.key? key
      end
    end

    SCHEMA_KEYS = %w[
      default
      enum
      exclusiveMaximum
      exclusiveMinimum
      format
      items
      maxItems
      maxLength
      maximum
      minItems
      minLength
      minimum
      multipleOf
      pattern
      type
      uniqueItems
    ].freeze
  end
end
