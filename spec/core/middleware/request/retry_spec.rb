require 'core/spec_helper'

describe ZendeskAPI::Middleware::Request::Retry do

  context 'when the request is a GET' do
    before do
      stub_request(:get, %r{blergh}).
          to_return(:status => 403, :headers => { :retry_after => 1 }).
          to_return(:status => 200)
    end

    it "should retry the request" do
      expect_any_instance_of(ZendeskAPI::Middleware::Request::Retry).to receive(:retry_if_safe)
      client.connection.get("blergh")
    end

    it "should print to logger" do
      expect(client.config.logger).to receive(:info).at_least(:once)
      client.connection.get("blergh")
    end
  end

  context "when the request is a POST" do
    before do
      stub_request(:post, %r{blergh}).
          to_return(:status => 403, :headers => { :retry_after => 1 }).
          to_return(:status => 200)
    end

    it "should raise error" do
      expect{client.connection.post("blergh")}.to raise_error(ZendeskAPI::Error::NetworkError)
    end
  end
end