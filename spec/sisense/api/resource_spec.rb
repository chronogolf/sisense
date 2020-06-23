RSpec.describe Sisense::API::Resource do
  describe '#api_client' do
    it 'returns an instance of Sisense::API::Client' do
      expect(described_class.api_client).to be_a Sisense::API::Client
    end
  end

  describe '#class_name' do
    it 'returns the class as a string excluding modules' do
      expect(described_class.class_name).to eq 'Resource'
    end
  end

  describe '#resource_base_path' do
    it 'raises an error if called on itself' do
      expect { described_class.resource_base_path }.to raise_error(NotImplementedError)
    end

    context 'when using legacy API' do
      let(:nested_resource_class) { Sisense::Elasticube }
      it 'returns the parent path used by the legacy API' do
        expect(nested_resource_class.resource_base_path(use_legacy_api: true)).to eq '/api/elasticubes'
      end
    end

    context 'when using the V1 API' do
      let(:nested_resource_class) { Sisense::Elasticube }
      it 'returns the parent path used by the V1 API' do
        expect(nested_resource_class.resource_base_path(use_legacy_api: false)).to eq '/api/v1/elasticubes'
      end
    end
  end

  describe '#descendants' do
    let(:known_resources) do
      [Sisense::Elasticube,
       Sisense::Dataset,
       Sisense::Dashboard,
       Sisense::Connection,
       Sisense::Translation,
       Sisense::Share,
       Sisense::Group,
       Sisense::Widget,
       Sisense::Folder,
       Sisense::ElasticubeDatasecurity,
       Sisense::Alert,
       Sisense::Role,
       Sisense::User].freeze
    end

    it 'returns all classes that inherite from the current class' do
      expect(described_class.descendants).to match_array known_resources
    end
  end

  describe '#initialize' do
    let(:parsed_json) do
      { '_id' => '5b3293ad1ed43bccb04e2029',
        'roleId' => '5b3293aa1ed43bccb04e1f37',
        'firstName' => 'olivier' }
    end

    it 'initialize a new object base on data passed as params using snake_case standard' do
      object = described_class.new(parsed_json)
      parsed_json.keys.each do |key|
        expect(object.respond_to?(key.to_snake_case)).to eq true
      end
    end
  end

  describe '#to_h' do
    let(:parsed_json) do
      { '_id' => '5b3293ad1ed43bccb04e2029',
        'roleId' => '5b3293aa1ed43bccb04e1f37',
        'firstName' => 'olivier' }
    end

    it 'converts any resource object as a hash snake_case standard' do
      object = Sisense::User.new(parsed_json)
      expect(object.to_h).to eq(_id: '5b3293ad1ed43bccb04e2029',
                                role_id: '5b3293aa1ed43bccb04e1f37',
                                first_name: 'olivier')
    end
  end
end
