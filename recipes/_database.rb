#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: _database
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