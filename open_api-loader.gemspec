Gem::Specification.new do |gem|
  gem.name     = "open_api-loader"
  gem.version  = "0.0.1"
  gem.author   = "Andrew Kozin (nepalez)"
  gem.email    = "andrew.kozin@gmail.com"
  gem.homepage = "https://github.com/nepalez/open_api-loader"
  gem.summary  = "Loads OAS scheme and updates it to OAS3 standard"
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]

  gem.required_ruby_version = "~> 2.3"

  gem.add_runtime_dependency "dry-initializer", "~> 2.4"
  gem.add_runtime_dependency "constructor_shortcut", "~> 0.3"

  gem.add_development_dependency "inch", "~> 0.8"
  gem.add_development_dependency "rake", "> 10"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rspec-its", "~> 1.2"
  gem.add_development_dependency "rubocop", "~> 0.55"
  gem.add_development_dependency "webmock", "~> 3.4"
end
