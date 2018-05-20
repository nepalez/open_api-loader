def local_path(content)
  file = Tempfile.create ""
  File.write file, content
  file.path
end

def remote_path(content)
  path = "https://www.example.com/source"
  stub_request(:get, path).to_return(body: content)
  path
end

def yaml_local_path(data)
  local_path YAML.dump(data)
end

def yaml_remote_path(data)
  remote_path YAML.dump(data)
end

def json_local_path(data)
  local_path JSON.dump(data)
end

def json_remote_path(data)
  remote_path JSON.dump(data)
end
