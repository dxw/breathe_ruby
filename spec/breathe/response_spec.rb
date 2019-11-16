RSpec.describe Breathe::Response do
  let(:sawyer_response) { double("Sawyer::Response") }
  let(:type) { "foo" }
  let(:response) { described_class.new(response: sawyer_response, type: type) }

  describe "#success?" do
    subject { response.success? }

    context "when response is successful" do
      let(:sawyer_response) { double("Sawyer::Response", status: 200) }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when response is a 401" do
      let(:sawyer_response) { double("Sawyer::Response", status: 401) }

      it "raises an error" do
        expect { subject }.to raise_error(
          Breathe::AuthenticationError,
          "The BreatheHR API returned a 401 error - are you sure you've set the correct API key?"
        )
      end
    end

    context "when response is a 500" do
      let(:sawyer_response) { double("Sawyer::Response", status: 500) }

      it "raises an error" do
        expect { subject }.to raise_error(
          Breathe::UnknownError,
          "The BreatheHR API returned an unknown error"
        )
      end
    end
  end
end
