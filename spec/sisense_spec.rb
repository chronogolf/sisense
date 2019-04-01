RSpec.describe Sisense do
  let(:basic_resources) do
    %w[alerts connections dashboards datasets elasticubes folders groups shares translations users widgets]
  end
  let(:nested_resources) { %w[datasecurity] }
  let(:supported_resources) { (basic_resources + nested_resources).sort }

  describe '#api_resources' do
    it 'returns a hash listing all supported resources sorted alphabetically by key' do
      expect(subject.api_resources.keys).to match_array supported_resources
    end
  end
end
