#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: default
#
# Copyright 2013, Ingo Renner
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




site_docroot = "/var/www/site-#{node['typo3']['site_name']}"
typo3_source_directory = "#{site_docroot}/typo3_src-#{node['typo3']['version']}"

# define mysql connection parameters
mysql_connection_info = {
  :host     => "localhost", 
  :username => "root", 
  :password => node['mysql']['server_root_password']
}

# create the database
mysql_database node['typo3']['db']['database'] do
  connection mysql_connection_info
  action :create
end

# create database user
mysql_database_user node['typo3']['db']['user'] do
  connection mysql_connection_info
  password node['typo3']['db']['password']
  database_name node['typo3']['db']['database']
  privileges [:select,:update,:insert,:create,:alter,:drop,:delete]
  action :grant
end




# set up TYPO3 directory structure
directory "#{site_docroot}" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "0755"
  recursive true
  action :create
end

# download TYPO3 source
unless File.directory? typo3_source_directory 
  execute "Download TYPO3 source, version #{node['typo3']['version']}" do
    cwd "#{site_docroot}"
    command "wget http://get.typo3.org/#{node['typo3']['version']} -O typo3.tgz"
  end

  execute "Unpack TYPO3 source" do
    cwd "#{site_docroot}"
    command "tar -xzf typo3.tgz"
    creates "#{typo3_source_directory}/index.php"
  end

  execute "Clean up TYPO3 source download" do
    cwd "#{site_docroot}"
    command "rm typo3.tgz"
  end
end




# symlink source
link "#{site_docroot}/typo3_src" do
  to "typo3_src-#{node['typo3']['version']}"
  owner node['apache']['user']
  group node['apache']['group']
end

%w{
  t3lib
  typo3
  index.php
}.each do |link_target|
  link "#{site_docroot}/#{link_target}" do
    to "typo3_src/#{link_target}"
    owner node['apache']['user']
    group node['apache']['group']
  end
end

link "#{site_docroot}/clear.gif" do
  to "typo3_src/typo3/clear.gif"
  owner node['apache']['user']
  group node['apache']['group']
end

if node['typo3']['use_typo3_htaccess']
  link "#{site_docroot}/.htaccess" do
    to "typo3_src/_.htaccess"
  end
end

# actual directories
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

# create TYPO3 site / web app
Chef::Log.info "Setting up TYPO3 site \"#{node['typo3']['site_name']}\""
web_app node['typo3']['site_name'] do 
  template "typo3-web_app.conf.erb"
  docroot site_docroot
  server_name node['typo3']['server_name']
  server_aliases node['typo3']['server_aliases']
end
