RSpec.describe Sisense::Role do
  it_behaves_like "a sisense resource"
  it_behaves_like "a listable resource"
  it_behaves_like "a retrievable resource" do
    let(:resource_id) { "a665a45920422f9d417e4867" }
  end
end
