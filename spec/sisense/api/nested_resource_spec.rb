RSpec.describe Sisense::API::NestedResource do
  it { expect(described_class).to be < Sisense::API::Resource }

  describe '#resource_base_path' do
    it 'raises an error if it calls on itself' do
      expect { described_class.resource_base_path }.to raise_error(NotImplementedError)
    end

    context 'when using legacy API' do
      let(:nested_resource_class) { Sisense::ElasticubeDatasecurity }
      it 'returns the parent path used by the legacy API' do
        expect(nested_resource_class.resource_base_path(use_legacy_api: true)).to eq '/api/elasticubes'
      end
    end

    context 'when using the V1 API' do
      let(:nested_resource_class) { Sisense::ElasticubeDatasecurity }
      it 'returns the parent path used by the V1 API' do
        expect(nested_resource_class.resource_base_path(use_legacy_api: false)).to eq '/api/v1/elasticubes'
      end
    end
  end
end
