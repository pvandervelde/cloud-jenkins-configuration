#
# Cookbook Name:: master_config
# Recipe:: default
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'master_config::git'
require File.join(File.dirname(__FILE__), 'git')
require File.join(File.dirname(__FILE__), 'configuration')
require File.join(File.dirname(__FILE__), 'plugins')
