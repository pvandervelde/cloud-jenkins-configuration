#
# Cookbook Name:: master
# Recipe:: plugins
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'windows'

# Define the CI directory that contains the jenkins installation
# Should really get this from outside
ci_directory = 'c:\\ci'

# collection of plugins
plugins = {
  'active-directory' => '1.39',
  'all-changes' => '1.3',
  'analysis-collector' => '1.42',
  'analysis-core' => '1.67',
  'ant' => '1.2',
  'any-buildstep' => '0.1',
  'artifactdeployer' => '1.3',
  'audit-trail' => '2.1',
  'azure-slave-plugin' => '0.3.0',
  'build-failure-analyzer' => '1.12.1',
  'build-flow-plugin' => '0.10',
  'build-name-setter' => '1.3',
  'build-timeout' => '1.14.1',
  'buildgraph-view' => '1.0',
  'categorized-view' => '1.8',
  'claim' => '2.5',
  'cloudbees-folder' => '4.7',
  'cobertura' => '1.9.6',
  'conditional-buildstep' => '1.3.3',
  'config-file-provider' => '2.7.5',
  'copyartifact' => '1.34',
  'credentials' => '1.22',
  'dashboard-view' => '2.9.4',
  'email-ext' => '2.39',
  'envinject' => '1.90',
  'exclusive-execution' => '0.7',
  'flexible-publish' => '0.14.1',
  'gerrit-trigger' => '2.7.0',
  'git' => '2.3.4',
  'git-client' => '1.15.0',
  'git-parameter' => '0.4.0',
  'gravatar' => '2.1',
  'greenballs' => '1.14',
  'javadoc' => '1.3',
  'jenkins-multijob-plugin' => '1.16',
  'mailer' => '1.13',
  'mapdb-api' => '1.0.6.0',
  'matrix-auth' => '1.2',
  'matrix-project' => '1.4',
  'maven-plugin' => '2.8',
  'msbuild' => '1.24',
  'nunit' => '0.16',
  'parametrized-trigger' => '2.25',
  'powershell' => '1.2',
  'promoted-builds' => '2.19',
  'run-condition' => '1.0',
  'scm-api' => '0.2',
  'script-security' => '1.12',
  'ssh-credentials' => '1.10',
  'subversion' => '2.5',
  'swarm' => '1.22',
  'tasks' => '4.44',
  'token-macro' => '1.10',
  'violations' => '0.7.11',
  'warnings' => '4.45',
  'ws-cleanup' => '0.25',
}

#
plugins.each do |name, version|
  remote_file "#{ci_directory}\\plugins\\#{name}.hpi" do
    source 'http://updates.jenkins-ci.org/download/plugins/#{name}/#{version}/#{name}.hpi'
    action :create
  end
end



# Create the jenkins config files

# credentials

# email-ext

# git

# gittool


# msbuild