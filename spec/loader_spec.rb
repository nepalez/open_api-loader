RSpec.describe OpenAPI::Loader do
  subject { described_class }

  context "with OAS 2" do
    let(:target) { yaml_fixture_file "oas2/target.yaml" }

    context "in YAML" do
      let(:source) { "spec/fixtures/oas2/source.yaml" }
      xit { is_expected.to eq target }
    end

    context "in JSON" do
      let(:source) { "spec/fixtures/oas2/source.json" }
      xit { is_expected.to eq target }
    end
  end

  context "with OAS 3" do
    let(:target) { yaml_fixture_file "oas3/target.yaml" }

    context "in YAML" do
      let(:source) { "spec/fixtures/oas3/source.yaml" }
      xit { is_expected.to eq target }
    end

    context "in JSON" do
      let(:source) { "spec/fixtures/oas3/source.json" }
      xit { is_expected.to eq target }
    end
  end
end
