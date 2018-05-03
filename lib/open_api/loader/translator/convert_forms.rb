class OpenAPI::Loader::Translator
  #
  # Builds 'requestBody' from 'consumes' and 'formData' parameters
  #
  # @private
  #
  class ConvertForms < SimpleDelegator
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
      schema = form_schema(operation)
      form_encodings(operation).each do |encoding|
        operation["requestBody"] ||= {}
        operation["requestBody"]["content"] ||= {}
        operation["requestBody"]["content"][encoding] = { "schema" => schema }
      end
    end

    def form_encodings(operation)
      encodings = Array operation.delete("consumes")
      forms, others = encodings.partition { |item| FORMS.include? item }
      operation["consumes"] = others if others.any?
      forms
    end

    def form_schema(operation)
      properties = form_properties(operation)
      schema = { "type" => "object" }
      schema["properties"] = properties if properties.any?
      schema
    end

    def form_properties(operation)
      form_params(operation).each_with_object({}) do |item, obj|
        name = item["name"]
        data = item.reject { |key| %w[in name].include? key }
        data["type"] = "string" if data["type"] == "file"
        obj[name] = data
      end
    end

    def form_params(operation)
      params = Array operation.delete("parameters")
      forms, others = params.partition { |item| item["in"] == "formData" }
      operation["parameters"] = others if others.any?
      forms
    end
  end
end
