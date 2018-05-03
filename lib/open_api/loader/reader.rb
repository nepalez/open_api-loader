module OpenAPI::Loader
  #
  # Loads data from [#source] file and strinfies all its keys
  # @private
  #
  class Reader
    extend Dry::Initializer
    extend ConstructorShortcut[:call] # class-level .call

    param :source

    def call
      stringify_keys(try_json || try_yaml)
    end

    private

    def raw
      @raw ||= begin
        uri  = URI source
        path = Pathname source
        uri.absolute? ? Net::HTTP.get(uri) : File.read(path)
      end
    end

    def stringify_keys(data)
      case data
      when Hash
        data.each_with_object({}) { |(k, v), o| o[k.to_s] = stringify_keys(v) }
      when Array then data.map { |item| stringify_keys(item) }
      else data
      end
    end

    def try_json
      JSON.load raw
    rescue JSON::ParserError
      nil
    end

    def try_yaml
      YAML.load raw
    rescue Psych::SyntaxError
      nil
    end
  end
end
