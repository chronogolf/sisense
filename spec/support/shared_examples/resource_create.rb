shared_examples 'a creatable resource' do
  around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_create") { test.run } }

  it "returns the created #{described_class.name} object" do
    result = described_class.create(params: params)
    if result.is_a?(Array)
      expect(result.all? { |item| item.is_a?(described_class) }).to eq true
    else
      expect(result).to be_a described_class
    end
  end

  it 'matches the informations sent' do
    created_object = described_class.create(params: params)
    params.keys.each { |key| expect(created_object.send(key.to_s.underscore)).to eq params[key] }
  end
end

shared_examples 'a creatable nested resource' do
  around do |test|
    VCR.use_cassette("#{described_class::PARENT_CLASS::RESOURCE_NAME}_#{described_class::RESOURCE_NAME}_create") do
      test.run
    end
  end

  it "returns the created #{described_class.name} object" do
    result = described_class.create(params: params)
    if result.is_a?(Array)
      expect(result.all? { |item| item.is_a?(described_class) }).to eq true
    else
      expect(result).to be_a described_class
    end
  end
end
