#
# Cookbook Name:: master_config
# Recipe:: configuration
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#
::Chef::Recipe.send(:include, Master::Config::Paths)

include_recipe 'windows'

# Define the CI directory that contains the jenkins installation
# Should really get this from outside
jenkins_workspace_dir = '\\\\invalid\\workspace'
jenkins_data_dir = '\\\\invalid\\data'
jenkins_master_labels = ''

# Copy all the default jenkins files from the cookbook
remote_directory ci_directory do
  source 'jenkins'
  action :create
end

file "#{ci_directory}\\config.xml" do
  content <<-XML
<?xml version='1.0' encoding='UTF-8'?>
<hudson>
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
  action :create
end
