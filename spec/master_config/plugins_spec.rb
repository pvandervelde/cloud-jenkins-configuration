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
jenkins_plugin_emailext_version = plugins['email-ext']
jenkins_emailext_default_recipient = 'cc:builds@example.com'
jenkins_emailext_default_replyto = 'builds@example.com'
emailext_config_content = <<-XML
[user]
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

describe file("#{ci_directory}\\hudson.plugins.emailext.ExtendedEmailPublisher.xml") do
  it { should be_file }
  its(:content) { should start_with(emailext_config_content) }
end

jenkins_plugin_gittool_version = plugins['git-client']
gittool_config_content = <<-XML
[user]
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

describe file("#{ci_directory}\\hudson.plugins.git.GitTool.xml") do
  it { should be_file }
  its(:content) { should start_with(gittool_config_content) }
end

jenkins_plugin_msbuild_version = plugins['msbuild']
msbuild_config_content = <<-XML
[user]
<?xml version='1.0' encoding='UTF-8'?>
<hudson.plugins.msbuild.MsBuildBuilder_-DescriptorImpl plugin="msbuild@#{jenkins_plugin_msbuild_version}">
  <installations>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>3.5 (x86)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework\\v3.5\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>3.5 (x64)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework64\\v3.5\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>4.0 (x86)</name>
      <home>C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe</home>
      <properties/>
    </hudson.plugins.msbuild.MsBuildInstallation>
    <hudson.plugins.msbuild.MsBuildInstallation>
      <name>4.0 (x64)</name>
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

describe file("#{ci_directory}\\hudson.plugins.msbuild.MsBuildBuilder.xml") do
  it { should be_file }
  its(:content) { should start_with(msbuild_config_content) }
end
