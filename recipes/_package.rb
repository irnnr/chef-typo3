#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: _package
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

# download TYPO3 package
unless File.directory? typo3_source_directory 
  execute "Download TYPO3 #{node['typo3']['package']} package, TYPO3 version #{node['typo3']['version']}" do
    cwd node['apache']['docroot_dir']
    command "wget http://get.typo3.org/#{node['typo3']['package']}-#{node['typo3']['version']} -O typo3.tgz"
  end

  execute "Unpack TYPO3 package" do
    cwd node['apache']['docroot_dir']
    command "tar -xzf typo3.tgz"
  end

  ruby_block "Rename TYPO3 package directory" do
    block do
      File.rename(
        "#{node['apache']['docroot_dir']}/#{node['typo3']['package']}package-#{node['typo3']['version']}", 
        "#{site_docroot}"
      )
    end
  end

  execute "Clean up TYPO3 package download" do
    cwd node['apache']['docroot_dir']
    command "rm typo3.tgz"
  end
end

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
