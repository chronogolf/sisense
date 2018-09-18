RSpec.describe Sisense::User do
  it_behaves_like 'a listable resource'
  it_behaves_like 'a retrievable resource' do
    let(:resource_id) { '5b3293ad1ed43bccb04e2029' }
  end
  it_behaves_like 'a creatable resource' do
    let(:params) { { first_name: 'Sisense', last_name: 'User', email: 'sisense.user@chronogolf.ca' } }
  end
  it_behaves_like 'an updatable resource' do
    let(:resource_id) { '5ba152c029ae0907d8b72d79' }
    let(:params) { { last_name: 'UpdatedUser', email: 'sisense.updateduser@chronogolf.ca' } }
  end
  it_behaves_like 'a deletable resource' do
    let(:resource_id) { '5ba152c029ae0907d8b72d79' }
  end
end
