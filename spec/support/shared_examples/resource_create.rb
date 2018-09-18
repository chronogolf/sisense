shared_examples 'a creatable resource' do
  around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_create") { test.run } }

  it "returns the created #{described_class.name} object" do
    expect(described_class.create(params: params)).to be_a described_class
  end

  it 'matches the informations sent' do
    created_object = described_class.create(params: params)
    params.keys.each { |key| expect(created_object.send(key.to_s.underscore)).to eq params[key] }
  end
end
