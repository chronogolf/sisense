shared_examples "a sisense resource" do
  context "constants" do
    describe "RESOURCE_NAME" do
      it("is defined") { expect(described_class.const_defined?("RESOURCE_NAME")).to eq true }
    end
  end

  it { expect(described_class).to be < Sisense::API::Resource }
end
