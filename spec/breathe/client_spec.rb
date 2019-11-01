RSpec.describe Breathe::Client, :vcr do
  let(:client) { @client }

  describe "absences" do
    it { expect(client.absences).to be_a(Breathe::Absences) }
  end
end
