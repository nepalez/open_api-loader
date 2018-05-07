class OpenAPI::Loader::Denormalizer
  #
  # Inserts server variables into server urls in all operations
  #
  # @private
  #
  class Variables < SimpleDelegator
    def call
      operations.each { |operation| convert(operation) }
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

    def convert(operation)
      servers = operation.delete("servers")
      return unless servers.is_a? Array
      operation["servers"] = servers.flat_map { |server| substitute(server) }
    end

    def substitute(server)
      url, variables = server.values_at "url", "variables"
      combinations(url, variables).map { |url| { "url" => url } }
    end

    def combinations(url, variables)
      return [url] unless variables.is_a? Hash

      variables.inject([url]) do |urls, (key, var)|
        enum = var["enum"]
        if enum.is_a?(Array) && enum.any?
          urls.flat_map { |url| enum.map { |val| url.gsub("{#{key}}", val) } }
        else
          urls
        end
      end
    end
  end
end
