class OpenAPI::Loader::Denormalizer
  #
  # Denormalizes all the 'servers' definitions
  # by moving them from the root OpenAPI object and path objects
  # right into the corresponding operation objects.
  #
  # @private
  #
  class Servers < SimpleDelegator
    def call
      root_default = delete "servers"
      paths.each do |path|
        default = path.delete("servers") || root_default
        operations(path).each do |operation|
          operation["servers"] ||= default if default
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
  end
end
