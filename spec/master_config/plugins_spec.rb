require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', 'paths')
require File.join(File.dirname(__FILE__), '..', 'plugins')

require 'jenkins_api_client'

# Verify that the plugins have been installed through the jenkins api
describe 'jenkins plugins' do
  begin
    client = JenkinsApi::Client.new(server_ip: '127.0.0.1', server_port: '8080')
    installed_plugins = client.plugin.list_installed

    diff_in_plugins_to_install = plugins_to_install.reject { |k, v| installed_plugins[k] == v }
    diff_in_installed_plugins = installed_plugins.reject { |k, v| plugins_to_install[k] == v }

    it 'are installed' do
      expect(diff_in_plugins_to_install).to be_empty
      expect(diff_in_installed_plugins).to be_empty
    end
  rescue
    it 'fails' do
      # this always fails because there was an exception of some kind
      expect(false).to be true
    end
  end
end

# configurations
