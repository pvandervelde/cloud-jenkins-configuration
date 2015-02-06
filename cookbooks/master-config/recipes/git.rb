#
# Cookbook Name:: master-config
# Recipe:: git
#
# Copyright 2014, Patrick van der Velde
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'windows'

# Install GIT 1.9.5
windows_package node['git']['display_name'] do
  action :install
  source node['git']['url']
  checksum node['git']['checksum']
  installer_type :inno
end

# Git is installed to Program Files (x86) on 64-bit machines and
# 'Program Files' on 32-bit machines
PROGRAM_FILES = ENV['ProgramFiles(x86)'] || ENV['ProgramFiles']
GIT_PATH = "#{ PROGRAM_FILES }\\Git\\Cmd"

# COOK-3482 - windows_path resource doesn't change the current process
# environment variables. Therefore, git won't actually be on the PATH
# until the next chef-client run
ruby_block 'Add Git Path' do
  block do
    ENV['PATH'] += ";#{GIT_PATH}"
  end
  action :nothing
end

windows_path GIT_PATH do
  action :add
  notifies :create, 'ruby_block[Add Git Path]', :immediately
end

# Set up the git default configuration. Because we assume the machine is only
# used for one purpose we can set the global configuration instead of the per user
# one (which is much harder to create given that Windows doesn't allow us to create
# the c:\Users\jenkins_master directory by ourselves).
GIT_CONFIG_PATH = "#{ PROGRAM_FILES }\\Git\\etc\\gitconfig"
file GIT_CONFIG_PATH do
  content <<-INI
[user]
    name = jenkins.master
    email = jenkins.master@cloud.jenkins.com
[credential]
    helper = wincred
[core]
    symlinks = false
    autocrlf = false
[color]
    diff = auto
    status = auto
    branch = auto
    interactive = true
[pack]
    packSizeLimit = 2g
[help]
    format = html
[http]
    sslCAinfo = /bin/curl-ca-bundle.crt
[sendemail]
    smtpserver = /bin/msmtp.exe
[diff "astextplain"]
    textconv = astextplain
[rebase]
    autosquash = true
  INI
  action :create
end
