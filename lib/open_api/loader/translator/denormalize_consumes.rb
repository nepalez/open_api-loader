class OpenAPI::Loader::Translator
  #
  # Denormalizes 'consumes' setting for requestBody
  #
  # @private
  #
  class DenormalizeConsumes < SimpleDelegator
    def call
      paths.each do |path|
        path_consumes = path.delete("consumes") || root_consumes
        operations(path).each do |operation|
          consumes = operation.delete("consumes") || path_consumes
          operation["consumes"] = consumes if consumes?(operation)
        end
      end
    end

    private

    def root_consumes
      @root_consumes ||= delete("consumes")
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

    def consumes?(operation)
      Array(operation["parameters"]).any? do |item|
        item.is_a?(Hash) && %w[body formData].include?(item["in"])
      end
    end
  end
end
