shared_examples 'a retrievable resource' do
  around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_retrieve") { test.run } }

  it "returns a #{described_class.name} object" do
    expect(described_class.retrieve(id: resource_id).is_a?(described_class)).to eq true
  end

  it 'returns the expected resource' do
    expect(described_class.retrieve(id: resource_id)._id).to eq resource_id
  end
end
