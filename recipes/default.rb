#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: default
#
# Copyright 2013-2014, Ingo Renner
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

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "database::mysql"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_apc"
include_recipe "php::module_gd"
include_recipe "apache2::mod_php5"
include_recipe "typo3::graphicsmagick"


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

site_docroot = "#{node['apache']['docroot_dir']}/site-#{node['typo3']['site_name']}"
typo3_source_directory = "#{site_docroot}/typo3_src-#{node['typo3']['version']}"

include_recipe "typo3::_database"

if !node['typo3']['package'].empty?
  include_recipe "typo3::_package"
else
  include_recipe "typo3::_source"
end

# create actual directories, set permissions
%w{
  fileadmin
  typo3conf
  typo3conf/ext
  typo3temp
  uploads
}.each do |directory|
  directory "#{site_docroot}/#{directory}" do
    owner node['apache']['user']
    group node['apache']['group']
    mode "0755"
    recursive true
  end
end

# enable install tool
file "#{site_docroot}/typo3conf/ENABLE_INSTALL_TOOL" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "0755"
  action :touch
end

# set php.ini directives as recommended by Install Tool system check
# can't use the php cookbook's intended way since it only applies to cli
file "/etc/php5/apache2/conf.d/upload_max_filesize.ini" do
    owner "root"
    group "root"
    mode "0644"
    action :create
    content "upload_max_filesize = 10M\npost_max_size = 10M\n"
    notifies :restart, "service[apache2]"
end

file "/etc/php5/apache2/conf.d/max_execution_time.ini" do
    owner "root"
    group "root"
    mode "0644"
    action :create
    content "max_execution_time = 240\n"
    notifies :restart, "service[apache2]"
end

# create TYPO3 site / web app
Chef::Log.info "Setting up TYPO3 site \"#{node['typo3']['site_name']}\""
web_app node['typo3']['site_name'] do 
  template "typo3-web_app.conf.erb"
  docroot site_docroot
  server_name node['typo3']['server_name']
  server_aliases node['typo3']['server_aliases']
end
