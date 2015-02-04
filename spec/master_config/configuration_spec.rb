require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'jenkins_api_client'

describe 'jenkins configuration' do
  begin
    response = RestClient.get 'http://localhost:8080/api/json'
    it 'is active an returns the correct version' do
      expect(response.headers.empty?).to be(false)
      expect(response.headers.keys).to include(:x_jenkins)
      expect(response.headers[:x_jenkins]).to eq('1.595')
    end
  rescue
    it 'fails' do
      # this always fails because there was an exception of some kind
      expect(false).to be true
    end
  end
end

# Read the configuration via the API?