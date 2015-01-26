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

  'azure-slave-plugin' => '0.3.0',

  'git' => '2.3.4',
  'promoted-builds' => '2.19',
  'credentials' => '1.20',
  'git-client' => '1.15.0',
  'scm-api' => '0.2',
  'matrix-project' => '1.4',
  'token-macro' => '1.10',
  'parametrized-trigger' => '2.4',
  'ssh-credentials' => '1.10',
  'mailer' => '1.11',


}

#
plugins.each do |name, version|
  remote_file "#{ci_directory}\\plugins\\#{name}.hpi" do
    source 'http://updates.jenkins-ci.org/download/plugins/#{name}/#{version}/#{name}.hpi'
    action :create
  end
end



# Create the jenkins config files