RSpec.describe OpenAPI::Loader::Reader, ".call" do
  subject { described_class.call(source) }

  context "from local yaml" do
    let(:source) { "spec/fixtures/oas2/source.yaml" }
    let(:target) { yaml_fixture_file "oas2/loaded.yaml" }

    it { is_expected.to eq target }
  end

  context "from local json" do
    let(:source) { "spec/fixtures/oas2/source.json" }
    let(:target) { yaml_fixture_file "oas2/loaded.yaml" }

    it { is_expected.to eq target }
  end

  context "from another existing local" do
    let(:source) { local_path target }
    let(:target) { "foo" }

    it { is_expected.to eq target }
  end

  context "from absent local" do
    let(:source) { "foo" }

    it "raises StandardError" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "from remote yaml" do
    let(:source) { yaml_remote_path(target) }
    let(:target) { { "foo" => "bar" } }

    it { is_expected.to eq target }
  end

  context "from remote json" do
    let(:source) { json_remote_path(target) }
    let(:target) { { "foo" => "bar" } }

    it { is_expected.to eq target }
  end

  context "from another remote" do
    let(:source) { remote_path(target) }
    let(:target) { "foo" }

    it { is_expected.to eq target }
  end
end
