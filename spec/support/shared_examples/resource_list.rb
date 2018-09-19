shared_examples 'a listable resource' do
  around { |test| VCR.use_cassette("#{described_class::RESOURCE_NAME}_list") { test.run } }

  it 'responds with an Array' do
    expect(described_class.list).to be_a(Array)
  end

  it "returns a list of #{described_class.name} objects" do
    expect(described_class.list.all? { |item| item.is_a?(described_class) }).to eq true
  end
end

shared_examples 'a listable nested resource' do
  around do |test|
    VCR.use_cassette("#{described_class::PARENT_CLASS::RESOURCE_NAME}_#{described_class::RESOURCE_NAME}_list") do
      test.run
    end
  end

  it 'responds with an Array' do
    expect(described_class.list(params: params)).to be_a(Array)
  end

  it "returns a list of #{described_class.name} objects" do
    expect(described_class.list(params: params).all? { |item| item.is_a?(described_class) }).to eq true
  end
end
