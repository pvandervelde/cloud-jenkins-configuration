require 'chefspec'

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

describe 'master'  do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  # install git (c:\program files (x86)\git --> 1.9.5)
  it 'installs git' do
    expect(chef_run).to install_windows_package('Git version 1.9.5-preview20141217')
    expect(chef_run).to add_windows_path(ENV['ProgramFiles(x86)'] + '\\Git\\Cmd')
  end

  # update the system git config
  git_config_content = <<-INI
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

  it 'updates gitconfig in the git/etc install directory' do
    expect(chef_run).to create_file('C:\\Program Files (x86)\\Git\\etc\\gitconfig').with_content(git_config_content)
  end
end
