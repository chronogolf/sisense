shared_examples 'an updatable resource' do
  around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_update") { test.run } }

  it "returns the updated #{described_class.name} object" do
    updated_object = described_class.update(id: resource_id, params: params)
    expect(updated_object).to be_a described_class
    expect(updated_object._id).to eq resource_id
  end

  it 'matches the informations sent' do
    updated_object = described_class.update(id: resource_id, params: params)
    params.keys.each { |key| expect(updated_object.send(key.to_s.underscore)).to eq params[key] }
  end
end

shared_examples 'an updatable nested resource' do
  around do |test|
    VCR.use_cassette("#{described_class::PARENT_CLASS::RESOURCE_NAME}_#{described_class::RESOURCE_NAME}_update") do
      test.run
    end
  end

  it "returns the updated #{described_class.name} object" do
    updated_object = described_class.update(id: resource_id, params: params)
    expect(updated_object).to be_a described_class
    expect(updated_object._id).to eq resource_id
  end

  it 'matches the informations sent' do
    updated_object = described_class.update(id: resource_id, params: params)
    params.keys.each { |key| expect(updated_object.send(key.to_s.underscore)).to eq params[key] }
  end
end
