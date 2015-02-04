require 'chefspec'

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks (default: [inferred from
  # the location of the calling spec file])
  # config.cookbook_path = File.join(File.dirname(__FILE__), '..', '..')

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  # config.role_path = '/var/roles'

  # Specify the path for Chef Solo to find environments (default: [ascending search])
  # config.environment_path = '/var/environments'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data (default: nil)
  # config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'windows'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '2012'
end

ci_directory = 'c:\\ci'
jenkins_version = '1.598'
jenkins_workspace_dir = '\\\\invalid\\workspace'
jenkins_data_dir = '\\\\invalid\\data'
jenkins_master_labels = ''

describe 'master'  do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  # install git (c:\program files (x86)\git --> 1.9.5)
  it 'copies the master files' do
    expect(chef_run).to create_remote_directory(ci_directory).with_source('jenkins')
  end

  # update the system git config
  jenkins_config_content = <<-XML
<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <version>#{jenkins_version}</version>
  <numExecutors>0</numExecutors>
  <mode>EXCLUSIVE</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class="hudson.security.AuthorizationStrategy$Unsecured"/>
  <securityRealm class="hudson.security.SecurityRealm$None"/>
  <disableRememberMe>false</disableRememberMe>
  <projectNamingStrategy class="jenkins.model.ProjectNamingStrategy$DefaultProjectNamingStrategy"/>
  <workspaceDir>#{jenkins_workspace_dir}</workspaceDir>
  <buildsDir>#{jenkins_data_dir}</buildsDir>
  <viewsTabBar class="hudson.views.DefaultViewsTabBar"/>
  <myViewsTabBar class="hudson.views.DefaultMyViewsTabBar"/>
  <clouds>
  </clouds>
  <slaves>
  </slaves>
  <quietPeriod>5</quietPeriod>
  <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
  <views>
    <hudson.model.AllView>
      <owner class="hudson" reference="../../.."/>
      <name>All</name>
      <filterExecutors>false</filterExecutors>
      <filterQueue>false</filterQueue>
      <properties class="hudson.model.View$PropertyList"/>
    </hudson.model.AllView>
  </views>
  <primaryView>All</primaryView>
  <slaveAgentPort>0</slaveAgentPort>
  <label>#{jenkins_master_labels}</label>
  <nodeProperties/>
  <globalNodeProperties>
    <hudson.slaves.EnvironmentVariablesNodeProperty>
    </hudson.slaves.EnvironmentVariablesNodeProperty>
  </globalNodeProperties>
</hudson>
  XML

  it 'creates the jenkins config.xml file' do
    expect(chef_run).to create_file("#{ci_directory}\\config.xml").with_content(jenkins_config_content)
  end
end
