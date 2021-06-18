# frozen_string_literal: true

apps = node['install_apps'] || []
apps_4_ubuntu = node['install_apps_4_ubuntu'] || []
apps_4_ol8 = node['install_apps_4_ol8'] || []

apps += apps_4_ubuntu if node['distro'] == 'ubuntu'
apps += apps_4_ol8    if node['distro'] == 'ol8'

apps.each do |app|
  package app do
    action :install
  end
end
