RSpec.describe OpenAPI::Loader::Ref do
  describe ".new" do
    subject { described_class.new(source) }

    context "with a pointer to the external subpath" do
      let(:source) { "https://example.com#/foo/ /e%5Ef/a~10b/m~01n" }

      it { is_expected.to eq source }
      its(:uri)  { is_expected.to eq URI("https://example.com") }
      its(:path) { is_expected.to eq ["foo", " ", "e^f", "a/0b", "m~1n"] }
    end

    context "with an explicit pointer to the current root" do
      let(:source) { "#" }

      it { is_expected.to eq source }
      its(:uri)  { is_expected.to be_nil }
      its(:path) { is_expected.to eq [] }
    end

    context "with an implicit pointer to the current root" do
      let(:source) { "" }

      it { is_expected.to eq "#" }
      its(:uri)  { is_expected.to be_nil }
      its(:path) { is_expected.to eq [] }
    end

    context "with a local pointer" do
      let(:source) { "#/foo/ /e%5Ef/a~10b/m~01n" }

      it { is_expected.to eq source }
      its(:uri)  { is_expected.to be_nil }
      its(:path) { is_expected.to eq ["foo", " ", "e^f", "a/0b", "m~1n"] }
    end

    context "with an explicit pointer to the external root" do
      let(:source) { "https://example.com/#" }

      it { is_expected.to eq source }
      its(:uri)  { is_expected.to eq URI("https://example.com/") }
      its(:path) { is_expected.to eq [] }
    end

    context "without an implicit pointer to the external root" do
      let(:source) { "https://example.com/foo" }

      it { is_expected.to eq "https://example.com/foo#" }
      its(:uri)  { is_expected.to eq URI("https://example.com/foo") }
      its(:path) { is_expected.to eq [] }
    end

    context "with an external pointer" do
      let(:source) { "https://example.com/foo#/foo/ /e%5Ef/a~10b/m~01n" }

      it { is_expected.to eq source }
      its(:uri)  { is_expected.to eq URI("https://example.com/foo") }
      its(:path) { is_expected.to eq ["foo", " ", "e^f", "a/0b", "m~1n"] }
    end

    context "with several #" do
      let(:source) { "#/foo#/ /e%5Ef/a~10b/m~01n" }

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with a # succeeded not by a slash" do
      let(:source) { "# /foo/ /e%5Ef/a~10b/m~01n" }

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".[]" do
    subject { described_class[*path] }

    let(:path) { %w[foo~/bar 0 baz/~qux] }

    it { is_expected.to eq "#/foo~0~1bar/0/baz~1~0qux" }
  end

  describe "#fetch_from" do
    subject { ref.fetch_from(data) }

    let(:ref)  { described_class.new "#/foo/0/bar" }

    context "when value is present" do
      let(:data) { { "foo" => [{ "bar" => :BAZ }] } }

      it "finds the value" do
        expect(subject).to eq :BAZ
      end
    end

    context "when value is absent" do
      let(:data) { { "foo" => { "bar" => :BAZ } } }

      it "raises key error" do
        expect { subject }.to raise_error(KeyError, %r{'#/foo/0'})
      end
    end
  end
end
