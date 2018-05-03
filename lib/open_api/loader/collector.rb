module OpenAPI::Loader
  #
  # Collects the schema from given [#source] file
  # - loads the schema (and recursively loads and caches all its "$ref" files)
  # - hashifies the schema to provide nested hash with stringified keys
  # - collects the schema from the cached sources
  #
  # Notice: The service is one-off because its instances cache variables:
  #         `@uri` and `@path` (to provide absolute paths for `$ref`-s)
  #         `@refs` (to minimize the number of remote file loading)
  #
  # TODO: For now it doesn't check that the graph of "$ref"-s has no cycles!
  #
  # @private
  #
  class Collector
    extend Dry::Initializer
    extend ConstructorShortcut[:call] # class-level .call

    param  :source, proc(&:to_s)
    option :uri,    default: -> { URI(source) if URI(source).absolute? }
    option :path,   default: -> { Pathname(source) unless uri }

    def call
      build refs[""]
    end

    private

    def refs
      @refs ||= { "" => Reader.call(source) }
    end

    def build(data)
      case data = deref(data)
      when Hash  then data.each_with_object({}) { |(k, v), o| o[k] = build(v) }
      when Array then data.map { |item| build(item) }
      else data
      end
    end

    def deref(data)
      ref = data["$ref"] if data.is_a? Hash
      return data unless ref

      pointer = Ref.new(ref)
      source  = remote(pointer.uri.to_s)
      pointer.fetch_from(source)
    end

    def remote(value)
      refs[value] ||= Collector.call absolute_path(value)
    end

    def absolute_path(value)
      return value if URI(value).absolute?
      return value if Pathname(value).absolute?
      uri&.merge(value) || path.dirname.join(value)
    end
  end
end
