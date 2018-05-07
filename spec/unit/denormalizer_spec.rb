RSpec.describe OpenAPI::Loader::Denormalizer, ".call" do
  subject { described_class.call(source) }

  context "OAS 2" do
    let(:source) { yaml_fixture_file "oas2/translated.yaml" }
    let(:target) { yaml_fixture_file "oas2/denormalized.yaml" }

    it { is_expected.to eq target }
  end

  context "OAS 3" do
    let(:source) { yaml_fixture_file "oas3/collected.yaml" }
    let(:target) { yaml_fixture_file "oas3/denormalized.yaml" }

    it { is_expected.to eq target }
  end
end
