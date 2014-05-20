#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: _source
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


site_docroot = "#{node['apache']['docroot_dir']}/site-#{node['typo3']['site_name']}"
typo3_source_directory = "#{site_docroot}/typo3_src-#{node['typo3']['version']}"

typo3_version_major, typo3_version_minor, typo3_version_patch = node['typo3']['version'].split('.')
typo3_version_patch ||= 0 # In case version was specified w/o patch level, e.g. "6.1" instead of "6.1.0"

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

%w{typo3 index.php}.each do |link_target|
  link "#{site_docroot}/#{link_target}" do
    to "typo3_src/#{link_target}"
    owner node['apache']['user']
    group node['apache']['group']
  end
end

if typo3_version_major == 4 || (typo3_version_major == 6 && typo3_version_minor < 2)
  link "#{site_docroot}/t3lib" do
    to "typo3_src/t3lib"
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
