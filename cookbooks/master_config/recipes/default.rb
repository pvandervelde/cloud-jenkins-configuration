#
# Cookbook Name:: master_config
# Recipe:: default
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'master_config::git'
include_recipe 'master_config::configuration'
include_recipe 'master_config::plugins'
