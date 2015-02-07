# install GIT
default['git']['version'] = '1.9.5-preview20141217'
default['git']['checksum'] = 'd7e78da2251a35acd14a932280689c57ff9499a474a448ae86e6c43b882692dd'
default['git']['display_name'] = "Git version #{ node['git']['version'] }"

# rubocop:disable Metrics/LineLength
default['git']['url'] = "https://github.com/msysgit/msysgit/releases/download/Git-#{node['git']['version']}/Git-#{node['git']['version']}.exe"
# rubocop:enable Metrics/LineLength
