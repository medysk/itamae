# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/object/blank'

apps = node['install_apps'] || []

apps += node['install_apps_4_ubuntu'] || [] if node['distro'] == 'ubuntu'
apps += node['install_apps_4_ol8']    || [] if node['distro'] == 'ol8'

return if apps.blank?

recipes = %i[update_package_manager update_package install_package]

apps.each do |app|
  case app
  when 'git'
    recipes.push :git
  when 'tmux'
    recipes.push :tmux
  when 'vim'
    recipes.push :vim
  end
end

include_recipes recipes
