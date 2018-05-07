RSpec.describe OpenAPI::Loader do
  subject { described_class.call(source, **options) }

  let(:options) { {} }

  context "with OAS 2" do
    context "in YAML" do
      let(:source) { "spec/fixtures/oas2/source.yaml" }
      let(:target) { yaml_fixture_file "oas2/denormalized.yaml" }

      it { is_expected.to eq target }
    end

    context "in JSON" do
      let(:source) { "spec/fixtures/oas2/source.json" }
      let(:target) { yaml_fixture_file "oas2/denormalized.yaml" }

      it { is_expected.to eq target }
    end

    context "with option denormalize: false" do
      let(:source)  { "spec/fixtures/oas2/source.yaml" }
      let(:target)  { yaml_fixture_file "oas2/translated.yaml" }
      let(:options) { { denormalize: false } }

      it { is_expected.to eq target }
    end
  end

  context "with OAS 3" do
    context "in YAML" do
      let(:source) { "spec/fixtures/oas3/source.yaml" }
      let(:target) { yaml_fixture_file "oas3/denormalized.yaml" }

      it { is_expected.to eq target }
    end

    context "in JSON" do
      let(:source) { "spec/fixtures/oas3/source.json" }
      let(:target) { yaml_fixture_file "oas3/denormalized.yaml" }

      it { is_expected.to eq target }
    end

    context "with option denormalize: false" do
      let(:source)  { "spec/fixtures/oas3/source.yaml" }
      let(:target)  { yaml_fixture_file "oas3/collected.yaml" }
      let(:options) { { denormalize: false } }

      it { is_expected.to eq target }
    end
  end
end
