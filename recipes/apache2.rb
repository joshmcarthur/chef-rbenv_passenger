#
# Cookbook Name:: rbenv_passenger
# Based on passenger_enterprise
# Recipe:: apache2
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
# Author:: Fletcher Nichol <fnichol@nichol.ca>
# Author:: Josh McArthur (joshua.mcarthur@gmail.com)
#
# Copyright:: 2009, Opscode, Inc
# Copyright:: 2009, 37signals
# Coprighty:: 2009, Michael Hale
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

include_recipe "rbenv_passenger"
include_recipe "apache2"

rbenv_ruby    = node['rbenv_passenger']['rbenv_ruby']
apache_dir  = node['apache']['dir']

# set the module_path attribute if it isn't set
ruby_block "Calculate node['rbenv_passenger']['module_path']" do
  block do
    root_path = node['rbenv_passenger']['root_path']

    node.set['rvm_passenger']['module_path'] =
      "#{root_path}/ext/apache2/mod_passenger.so"
    Chef::Log.debug(%{Setting node['rbenv_passenger']['module_path'] = } +
      %{"#{node['rbenv_passenger']['module_path']}"})
  end

  not_if  { node['rbenv_passenger']['module_path'] }
end

Array(node['rbenv_passenger']['apache2_pkgs']).each do |pkg|
  package pkg
end

rbenv_script "passenger_apache2_module" do
  rbenv_version   rbenv_ruby
  code          %{passenger-install-apache2-module -a}

  not_if        { ::File.exists? node['rbenv_passenger']['module_path'] }
end

template "#{apache_dir}/mods-available/passenger.load" do
  source  'passenger.load.erb'
  owner   'root'
  group   'root'
  mode    '0755'
end

template "#{apache_dir}/mods-available/passenger.conf" do
  source  'passenger.conf.erb'
  owner   'root'
  group   'root'
  mode    '0755'
end

apache_module "passenger" do
  module_path node['rbenv_passenger']['module_path']
end
