RSpec.describe Sisense::Elasticube do
  it_behaves_like "a sisense resource"
  it_behaves_like "a listable resource"

  subject(:elasticube) do
    VCR.use_cassette("elasticube") { described_class.list.first }
  end

  describe "#datasecurity" do
    around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_create") { test.run } }
    it { expect(elasticube.datasecurity).to be_a Array }
    it "returns a list of all elasticube datasecurity objects" do
      result = elasticube.datasecurity
      expect(result.all? { |item| item.is_a? Sisense::ElasticubeDatasecurity }).to eq true
      expect(result.all? { |item| item.cube_id == elasticube._id }).to eq true
    end
  end
end
