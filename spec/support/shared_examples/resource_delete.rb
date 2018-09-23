shared_examples 'a deletable resource' do
  around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_delete") { test.run } }

  it 'returns a boolean as the response' do
    expect(described_class.delete(id: resource_id)).to be_a Net::HTTPNoContent
  end
end
