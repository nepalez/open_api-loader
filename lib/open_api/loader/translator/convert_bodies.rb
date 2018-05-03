class OpenAPI::Loader::Translator
  #
  # Builds 'requestBody' from 'consumes' and 'body' parameters
  #
  # @private
  #
  class ConvertBodies < SimpleDelegator
    def call
      operations.each { |item| update_body(item) }
    end

    private

    FORMS = %w[application/x-www-form-urlencoded multipart/form-data].freeze

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

    def update_body(operation)
      data, body = body_data(operation)
      return unless data

      body_encodings(operation).each do |encoding|
        schema = encoding["/xml"] ? data : drop_xml(data)
        operation["requestBody"] ||= Hash(body)
        operation["requestBody"]["content"] ||= {}
        operation["requestBody"]["content"][encoding] = { "schema" => schema }
      end
    end

    def body_encodings(operation)
      encodings = Array operation.delete("consumes")
      forms, others = encodings.partition { |item| FORMS.include? item }
      operation["consumes"] = forms if forms.any?
      others
    end

    def body_data(operation)
      param = body_params(operation).first
      return unless param.is_a?(Hash)
      schema  = param.delete("schema")
      content = param.select { |key, _| %w[description required].include? key }
      [schema, content]
    end

    def body_params(operation)
      params = Array operation.delete("parameters")
      bodies, others = params.partition { |item| item["in"] == "body" }
      operation["parameters"] = others if others.any?
      bodies
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
