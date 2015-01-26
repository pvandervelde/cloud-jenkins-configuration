#
# Cookbook Name:: master
# Recipe:: configuration
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'windows'

# Define the CI directory that contains the jenkins installation
# Should really get this from outside
ci_directory = 'c:\\ci'

# Copy all the default jenkins files from the cookbook
remote_directory ci_directory do
  source 'jenkins'
  action :create
end

# Create the jenkins config files