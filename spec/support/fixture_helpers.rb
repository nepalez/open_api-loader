require "yaml"
require "json"

def fixture_file_path(filename)
  File.expand_path "spec/fixtures/#{filename}"
end

def read_fixture_file(filename)
  File.read fixture_file_path(filename)
end

def yaml_fixture_file(filename, **_params)
  YAML.load read_fixture_file(filename)
end

def json_fixture_file(filename)
  JSON.parse read_fixture_file(filename)
end
