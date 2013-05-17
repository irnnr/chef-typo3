#
# Author:: Ingo Renner (<ingo@typo3.org>)
# Cookbook Name:: typo3
# Recipe:: scheduler
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

# set up a scheduler task for TYPO3 to run every minute
cron "TYPO3 scheduler" do
  minute '*'
  command "php /var/www/site-#{node['typo3']['site_name']}/typo3/cli_dispatch.phpsh scheduler"
  user node['apache']['user']
end