#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: vagrant
#
# Copyright 2014, Ingo Renner
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Add the vagrant user to the Apache group and vice versa
# Useful when using PhpStorm's remote sync feature with the vagrant user
group node['apache']['group'] do
  action :modify
  members "vagrant"
  append true
end

group "vagrant" do
  action :modify
  members node['apache']['user']
  append true
end


# Install MailCatcher http://mailcatcher.me
# rquires sqllite headers
package "sqllite-devel" do 
  action :install
  case node['platform_family']
  when "rhel","centos"
    package_name "sqlite-devel"
  when "debian","ubuntu"
    package_name "libsqlite3-dev"
  end
end

gem_package "mailcatcher" do
  action :install
end

service "mailcatcher" do
  supports :start => true, :stop => true, :restart => true
  action :nothing
end

template "mailcatcher service" do
  path "/etc/init.d/mailcatcher"
  source "mailcatcher.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[mailcatcher]"
  notifies :start, "service[mailcatcher]"
end

template "mailcatcher php" do
  path "#{node['php']['ext_conf_dir']}/mailcatcher.ini"
  source "mailcatcher.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[apache2]"
end


