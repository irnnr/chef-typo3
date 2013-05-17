#
# Cookbook Name:: typo3
# Definition:: extension
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


# allows to install an extension

# ideas allow installation from TER (default) or git
# use EXT:coreapi?

# @see http://docs.opscode.com/chef/essentials_cookbook_definitions.html

define :extension, :extension_key => nil do
  
  if params[:extension_key].nil? or params[:extension_key].empty?
    raise ArgumentError, "Missing required argument: extension_key"
  end
  
end