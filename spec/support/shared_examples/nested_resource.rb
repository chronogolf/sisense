shared_examples 'a sisense nested resource' do
  context 'constants' do
    describe 'RESOURCE_NAME' do
      it('is defined') { expect(described_class.const_defined?('RESOURCE_NAME')).to eq true }
    end

    describe 'PARENT_CLASS' do
      it('is defined') { expect(described_class.const_defined?('PARENT_CLASS')).to eq true }
      it { expect(described_class::PARENT_CLASS).to be < Sisense::API::Resource }
    end
  end

  it { expect(described_class).to be < Sisense::API::NestedResource }
end
