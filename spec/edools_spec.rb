require "spec_helper"

RSpec.describe Edools::Client do
  let(:authenticated_client) { described_class.new(access_token: 'token="test"', raise_errors: true) }
  let(:anonymous_client) { described_class.new(raise_errors: true) }

  it "has a version number" do
    expect(Edools::VERSION).not_to be nil
  end

  describe "BASE_URI" do
    it "should have correct value" do
      expect(Edools::Client::BASE_URI).to eq('https://core.myedools.info/api')
    end
  end



end
