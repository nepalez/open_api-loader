RSpec.describe OpenAPI::Loader::Cleaner, ".call" do
  subject { described_class.call(source) }

  context "OAS 2" do
    let(:source) { yaml_fixture_file "oas2/collected.yaml" }
    let(:target) { yaml_fixture_file "oas2/cleaned.yaml" }

    it { is_expected.to eq target }
  end

  context "OAS 3" do
    let(:source) { yaml_fixture_file "oas3/collected.yaml" }
    let(:target) { yaml_fixture_file "oas3/cleaned.yaml" }

    it { is_expected.to eq target }
  end
end
