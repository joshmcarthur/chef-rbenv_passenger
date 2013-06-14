#
# Cookbook Name:: rbenv_passenger
# Library:: Chef::RBEnvPassenger::RecipeHelpers
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
# Author:: Josh McArthur (joshua.mcarthur@gmail.com)
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
#

class Chef
  module RBEnvPassenger

    # Exceptions
    class GemVersionNotFound < RuntimeError; end

    module RecipeHelpers
      ##
      # Sets the version attribute to the most current RubyGems release,
      # unless set
      def determine_gem_version_if_not_given
        if node[:rbenv_passenger][:version].nil?
          require 'rubygems'
          require 'rubygems/dependency_installer'

          spec = Gem::DependencyInstaller.new.find_gems_with_sources(
            Gem::Dependency.new("passenger", '>= 0')).last

          if spec.nil?
            raise Chef::RVMPassenger::GemVersionNotFound,
              "Cannot find any suitable gem version of ruby Passenger. " +
              "Please specify node['rbenv_passenger']['version'] or check if " +
              "there are any connection problem with the gem sources."
          end

          node.set[:rbenv_passenger][:version] = spec[0].version.to_s
          Chef::Log.debug(%{Setting node['rbenv_passenger']['version'] = } +
            %{"#{node['rbenv_passenger']['version']}"})
        end
      end

      ##
      # Sets the rbenv_ruby attribute to rbenv/global ruby, unless set
      def determine_rbenv_ruby_if_not_given
        if node['rbenv_passenger']['rbenv_ruby'].nil?
          # FIXME I don't believe there's a way to access
          # the global ruby from chef-rbenv
          rbenv_ruby = node['rbenv']['rubies'].last

          node.set['rbenv_passenger']['rbenv_ruby'] = rvm_ruby
          Chef::Log.debug(%{Setting node['rbenv_passenger']['rbenv_ruby'] = } +
            %{"#{node['rbenv_passenger']['rbenv_ruby']}"})
        end
      end
    end
  end
end
