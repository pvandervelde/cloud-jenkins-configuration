require 'chefspec'
require_relative '../libraries/paths'
require_relative '../libraries/plugins'

include Master::Config::Paths
include Master::Config::Plugins

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

describe 'master_config'  do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  dir = ci_directory()
  plugins_directory = "#{dir}\\plugins"
  it 'creates the plugin directory' do
    expect(chef_run).to create_directory(plugins_directory)
  end

  # Verify the plugins
  # Note that the plugin variable is defined in the plugin.rb file in the root of the cookbook.
  # plugins().each do |name, version|
    # it "installs the #{name} plugin" do
      # expect(chef_run).to create_remote_file("#{plugins_directory}\\#{name}.hpi").with_source("http://updates.jenkins-ci.org/download/plugins/#{name}/#{version}/#{name}.hpi")
    # end
  # end

  jenkins_plugin_emailext_version = plugins['email-ext']
  jenkins_emailext_default_recipient = 'cc:builds@example.com'
  jenkins_emailext_default_replyto = 'builds@example.com'
  jenkins_plugin_emailext_config_content = <<-XML
<?xml version='1.0' encoding='UTF-8'?>
<hudson.plugins.emailext.ExtendedEmailPublisherDescriptor plugin="email-ext@#{jenkins_plugin_emailext_version}">
  <useSsl>false</useSsl>
  <charset>UTF-8</charset>
  <defaultContentType>text/html</defaultContentType>
  <defaultSubject>${PROJECT_DISPLAY_NAME} - Build # $BUILD_NUMBER - $BUILD_STATUS!</defaultSubject>
  <defaultBody> ${SCRIPT, template=&quot;groovy-builds-html.template&quot;}</defaultBody>
  <defaultPresendScript></defaultPresendScript>
  <defaultClasspath/>
  <emergencyReroute></emergencyReroute>
  <maxAttachmentSize>-1</maxAttachmentSize>
  <recipientList>#{jenkins_emailext_default_recipient}</recipientList>
  <defaultReplyTo>#{jenkins_emailext_default_replyto}</defaultReplyTo>
  <excludedCommitters></excludedCommitters>
  <overrideGlobalSettings>false</overrideGlobalSettings>
  <precedenceBulk>false</precedenceBulk>
  <debugMode>false</debugMode>
  <enableSecurity>true</enableSecurity>
  <requireAdminForTemplateTesting>true</requireAdminForTemplateTesting>
  <enableWatching>false</enableWatching>
</hudson.plugins.emailext.ExtendedEmailPublisherDescriptor>
  XML
  it 'creates the email-ext config file' do
    expect(chef_run).to create_file("#{ci_directory}\\hudson.plugins.emailext.ExtendedEmailPublisher.xml").with_content(jenkins_plugin_emailext_config_content)
  end

  jenkins_plugin_gittool_version = plugins['git-client']
  jenkins_plugin_gittool_config_content = <<-XML
<?xml version='1.0' encoding='UTF-8'?>
<hudson.plugins.git.GitTool_-DescriptorImpl plugin="git-client@#{jenkins_plugin_gittool_version}">
  <installations class="hudson.plugins.git.GitTool-array">
    <hudson.plugins.git.GitTool>
      <name>Default</name>
      <home>git.exe</home>
      <properties/>
    </hudson.plugins.git.GitTool>
  </installations>
</hudson.plugins.git.GitTool_-DescriptorImpl>
  XML
  it 'creates the git-client config file' do
    expect(chef_run).to create_file("#{ci_directory}\\hudson.plugins.git.GitTool.xml").with_content(jenkins_plugin_gittool_config_content)
  end

  jenkins_plugin_msbuild_version = plugins['msbuild']
  jenkins_plugin_msbuild_config_content = <<-XML
<?xml version='1.0' encoding='UTF-8'?>
<hudson.plugins.msbuild.MsBuildBuilder_-DescriptorImpl plugin="msbuild@#{jenkins_plugin_msbuild_version}">
  <installations>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>Net-3.5 (x86)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework\\v3.5\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>Net-3.5 (x64)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework64\\v3.5\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>Net-4.5 (x86)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>Net-4.5 (x64)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>12.0 (x86)</name>
      <home>C:\\Program Files (x86)\\MSBuild\\12.0\\Bin\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>12.0 (x64)</name>
      <home>C:\\Program Files (x86)\\MSBuild\\12.0\\Bin\\amd64\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
  </installations>
</hudson.plugins.msbuild.MsBuildBuilder_-DescriptorImpl>
  XML
  it 'creates the git-client config file' do
    expect(chef_run).to create_file("#{ci_directory}\\hudson.plugins.msbuild.MsBuildBuilder.xml").with_content(jenkins_plugin_msbuild_config_content)
  end
end
