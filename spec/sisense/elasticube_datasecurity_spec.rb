RSpec.describe Sisense::ElasticubeDatasecurity do
  it_behaves_like "a sisense nested resource"

  it_behaves_like "a listable nested resource" do
    let(:params) { {server: "LocalHost", elasticube_title: "Clubs reporting"} }
  end

  it_behaves_like "a creatable nested resource" do
    let(:params) do
      [{
        table: "DimClubs",
        column: "id",
        datatype: "numeric",
        server: "LocalHost",
        elasticube: "Clubs reporting",
        members: [],
        shares: [{type: "default"}],
        all_members: nil
      }]
    end
  end

  it_behaves_like "an updatable nested resource" do
    let(:resource_id) { "5b7f0d7d368b38a59e943cdf" }
    let(:params) { {members: ["123"]} }
  end
end
