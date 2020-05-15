RSpec.describe Sisense::Group do
  it_behaves_like "a sisense resource"
  it_behaves_like "a listable resource"
  it_behaves_like "a retrievable resource" do
    let(:resource_id) { "5b3293ab0800930a10dd0d3b" }
  end
  it_behaves_like "a creatable resource" do
    let(:params) { {name: "Test"} }
  end
  it_behaves_like "a deletable resource" do
    let(:resource_id) { "5b3293ab0800930a10dd0d3b" }
  end
end
