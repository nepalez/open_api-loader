module OpenAPI::Loader
  #
  # Describes json pointer used in "$ref"-erences
  # @see RFC-6901 https://tools.ietf.org/html/rfc6901
  #
  # @private
  #
  class Ref < String
    #
    # Builds the pointer from a path
    #
    # @param  [Array<#to_s>, #to_s] path
    # @return [OpenAPI::Ref]
    #
    def self.[](*path)
      path.flatten.compact.each_with_object("#") do |key, obj|
        obj << "/#{key.to_s.gsub('~', '~0').gsub('/', '~1')}"
      end
    end

    #
    # The URI to the remote document
    # @return [URI, nil]
    #
    def uri
      URI split("#").first unless start_with? "#"
    end

    #
    # The local pointer to the json
    # @return [Array<String>]
    #
    def path
      return [] if end_with? "#"
      split(%r{#/?}).last.to_s.split("/").map do |item|
        PARSER.unescape(item).gsub("~1", "/").gsub("~0", "~")
      end
    end

    #
    # Extracs referred value from given source by local path (after #)
    #
    # @param  [Hash]
    # @return [Object]
    #
    def fetch_from(data)
      read(data, [], *path)
    end

    private

    PARSER = URI::Parser.new.freeze

    def initialize(source)
      source = "#{source}#" if source.count("#").zero?
      super(source)
      return if count("#") == 1 && (end_with?("#") || self["#/"])
      raise ArgumentError, "Invalid reference '#{source}'"
    end

    def read(data, head, key = nil, *rest)
      return data unless key
      case data
      when Array then read_array(data, head, key, rest)
      when Hash  then read_hash(data, head, key, rest)
      else raise_error(*head, key)
      end
    end

    def read_array(data, head, key, rest)
      int = key.to_i
      raise_error(*head, key) unless int.to_s == key.to_s && data.count > int
      read(data[int], [*head, key], *rest)
    end

    def read_hash(data, head, key, rest)
      raise_error(*head, key) unless data.key? key
      read(data[key], [*head, key], *rest)
    end

    def raise_error(*path)
      raise KeyError, "Cannot find value by reference '#{self.class[*path]}'"
    end
  end
end
