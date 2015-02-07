#
# Cookbook Name:: master_config
# Recipe:: plugins
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#
::Chef::Recipe.send(:include, MasterConfiguration::Paths)
::Chef::Recipe.send(:include, MasterConfiguration::Plugins)

include_recipe 'windows'

# Install the plugins
plugins_directory = "#{ci_directory}\\plugins"
directory plugins_directory do
  action :create
end

# plugins is defined in the plugins.rb file in the root of the current cookbook.
plugins.each do |name, version|
  remote_file "#{plugins_directory}\\#{name}.hpi" do
    source "http://updates.jenkins-ci.org/download/plugins/#{name}/#{version}/#{name}.hpi"
    action :create
  end
end

# Create the jenkins config files
# credentials

# email-ext
jenkins_plugin_emailext_version = plugins['email-ext']
jenkins_emailext_default_recipient = 'cc:builds@example.com'
jenkins_emailext_default_replyto = 'builds@example.com'

file "#{ci_directory}\\hudson.plugins.emailext.ExtendedEmailPublisher.xml" do
  content <<-XML
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
  action :create
end

# gittool
jenkins_plugin_gittool_version = plugins['git-client']
file "#{ci_directory}\\hudson.plugins.git.GitTool.xml" do
  content <<-XML
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
  action :create
end

# msbuild
jenkins_plugin_msbuild_version = plugins['msbuild']
file "#{ci_directory}\\hudson.plugins.msbuild.MsBuildBuilder.xml" do
  content <<-XML
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
  action :create
end
