class OpenAPI::Loader::Translator
  #
  # Translates OAS2 host, basePath and schemes to OAS3 servers
  # Mutates the source
  #
  # @private
  #
  class ConvertServers < SimpleDelegator
    def call
      convert self
      paths.each { |item| convert item }
      operations.each { |item| convert item }
    end

    private

    def paths
      @paths ||= Enumerator.new do |yielder|
        fetch("paths", {}).each_value do |path|
          path.each_value { |item| yielder << item if item.is_a? Hash }
        end
      end
    end

    def operations
      @operations ||= Enumerator.new do |yielder|
        paths.each do |path|
          path.each_value { |item| yielder << item if item.is_a? Hash }
        end
      end
    end

    def url
      @url ||= File.join delete("host"), delete("basePath")
    end

    def convert(item)
      enum = item.delete "schemes"
      return unless enum
      item["servers"] = [{
        "url" => "{scheme}://#{url}",
        "variables" => { "scheme" => { "enum" => Array(enum) } }
      }]
    end
  end
end
