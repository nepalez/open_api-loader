# OpenAPI::Loader

Loads [OAS2][oas2] or [OAS3][oas3] scheme from YAML/JSON file(s), and converts it to OAS3 standard.

<a href="https://evilmartians.com/">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

[![Gem Version][gem-badger]][gem]
[![Build Status][travis-badger]][travis]
[![Dependency Status][gemnasium-badger]][gemnasium]
[![Inline docs][inch-badger]][inch]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open_api-loader'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install open_api-loader
```

## Usage

```ruby
require "open_api/loader"

OpenAPI::Loader.call "path_to/source.yaml"
# => { "openapi" => "3.0.0", ... }
```

It takes a filename of the specification (it should be in YAML or JSON), and returns a nested hash.

The loader transforms the source in several ways:

- reads the data,
- collects all the [reference objects][ref] both local and remote (like `./models.yaml#/Pet` or `https://example.com/models#/Pet`), and includes them into the specification,
- converts the specification from [OAS2][oas2] into [OAS3][oas3] standard,
- removes the [components][components] because all links to its definitions are dereferenced,
- denormalizes [servers][servers] and [parameters][parameters] by moving shared definitions from both [root][root] and [path items][paths] right into the corresponding [operations][operations],
- substitutes [server variables][server variables] into urls to provide "flat" servers list.

You can skip the last 3 steps using option:

```ruby
OpenAPI::Loader.call "path_to/source.yaml", clean: false
```

## Development

The loader should ultimately provide some additional checks and transformations:
- for now it doesn't check whether a [reference objects][ref] contain cycles

After checking out the repo, run `bin/setup` to install dependencies.

Before adding a PR, please run `rake` to run tests, style and documentation linters. You can also run `bin/console` for an interactive prompt [pry][pry] that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nepalez/open_api-loader.

## License

The gem is available as open source under the terms of the [MIT License][license].

[codeclimate-badger]: https://img.shields.io/codeclimate/github/nepalez/open_api-loader.svg?style=flat
[codeclimate]: https://codeclimate.com/github/nepalez/open_api-loader
[components]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#componentsObject
[gem-badger]: https://img.shields.io/gem/v/open_api-loader.svg?style=flat
[gem]: https://rubygems.org/gems/open_api-loader
[gemnasium-badger]: https://img.shields.io/gemnasium/nepalez/open_api-loader.svg?style=flat
[gemnasium]: https://gemnasium.com/nepalez/open_api-loader
[inch-badger]: http://inch-ci.org/github/nepalez/open_api-loader.svg
[inch]: https://inch-ci.org/github/nepalez/open_api-loader
[license]: https://opensource.org/licenses/MIT
[oas2]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md
[oas3]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md
[operations]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#operationObject
[parameters]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#parameterObject
[paths]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#pathItemObject
[pry]: https://github.com/pry/pry
[ref]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#referenceObject
[root]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#oasObject
[server variables]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#serverVariableObject
[servers]: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#serverObject
[travis-badger]: https://img.shields.io/travis/nepalez/open_api-loader/master.svg?style=flat
[travis]: https://travis-ci.org/nepalez/open_api-loader
