RSpec.describe OpenAPI::Loader::Collector, ".call" do
  subject { described_class.call(source) }

  context "OAS 2" do
    let(:target) { yaml_fixture_file "oas2/collected.yaml" }

    context "from local yaml" do
      let(:source) { "spec/fixtures/oas2/source.yaml" }
      it { is_expected.to eq target }
    end

    context "from local json" do
      let(:source) { "spec/fixtures/oas2/source.json" }
      it { is_expected.to eq target }
    end
  end

  context "OAS 3" do
    let(:target) { yaml_fixture_file "oas3/collected.yaml" }

    context "from local yaml" do
      let(:source) { "spec/fixtures/oas3/source.yaml" }
      it { is_expected.to eq target }
    end

    context "from local json" do
      let(:source) { "spec/fixtures/oas3/source.json" }
      it { is_expected.to eq target }
    end
  end
end
