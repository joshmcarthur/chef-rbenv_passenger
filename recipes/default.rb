#
# Cookbook Name:: rbenv_passenger
# Based on passenger_enterprise
# Recipe:: default
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
# Author:: Josh McArthur <joshua.mcarthur@gmail.com>
#
# Copyright:: 2010, 2011, Fletcher Nichol
# Copyright:: 2013, Josh McArthur
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

class Chef::Recipe
  # mix in recipe helpers
  include Chef::RBEnvPassenger::RecipeHelpers
end

determine_gem_version_if_not_given
determine_rbenv_ruby_if_not_given

rbenv_ruby          = node['rbenv_passenger']['rbenv_ruby']
passenger_version = node['rbenv_passenger']['version']

include_recipe "rbenv::system"

Array(node['rbenv_passenger']['common_pkgs']).each do |pkg|
  package pkg
end

rbenv_gem "passenger" do
  rbenv_version rvm_ruby
  version     passenger_version
end

# # calculate the root_path attribute if it isn't set. This is evaluated in the
# # execute phase because the RVM environment is queried and the Ruby must be
# # installed.
# ruby_block "Calculate node['rvm_passenger']['root_path']" do
#   block do
#     Chef::RVMPassenger::CalculateAttribute.new(node).for_root_path
#   end

#   not_if  { node['rvm_passenger']['root_path'] }
# end

# calculate the ruby_wrapper attribute if it isn't set. This is evaluated in
# the execute phase because the RVM environment is queried and the Ruby must be
# installed.
# ruby_block "Calculate node['rvm_passenger']['ruby_wrapper']" do
#   block do
#     Chef::RVMPassenger::CalculateAttribute.new(node).for_ruby_wrapper
#   end

#   not_if  { node['rvm_passenger']['ruby_wrapper'] }
# end
