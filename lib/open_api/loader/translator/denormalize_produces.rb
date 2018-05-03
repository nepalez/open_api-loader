class OpenAPI::Loader::Translator
  #
  # Denormalizes 'consumes' and 'produces' setting
  #
  # @private
  #
  class DenormalizeProduces < SimpleDelegator
    def call
      paths.each do |path|
        path_produces = path.delete("produces") || root_produces
        operations(path).each do |operation|
          produces = operation.delete("produces") || path_produces
          responses(operation).each do |response|
            response["produces"] = produces
          end
        end
      end
    end

    private

    def root_produces
      @root_produces ||= delete("produces")
    end

    def paths
      Enumerator.new do |yielder|
        fetch("paths", {}).each_value do |item|
          yielder << item if item.is_a? Hash
        end
      end
    end

    def operations(path)
      Enumerator.new do |yielder|
        path.each_value { |item| yielder << item if item.is_a? Hash }
      end
    end

    def responses(operation)
      data = operation["responses"]
      if data.is_a? Hash
        Enumerator.new do |yielder|
          data.each_value do |response|
            yielder << response if response.is_a?(Hash) && response["schema"]
          end
        end
      else
        []
      end
    end
  end
end
