# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/object/blank'
require 'spec_helper'

apps = node['install_apps'] || []

apps += node['install_apps_4_ubuntu'] || [] if node['distro'] == 'ubuntu'
apps += node['install_apps_4_ol8']    || [] if node['distro'] == 'ol8'

return if apps.blank?

home = "/home/#{node['user_name']}"

apps.each do |app|
  describe package(app) do
    it { should be_installed }
  end

  case app
  when  'git'
    describe file("#{home}/.gitconfig") do
      it { should be_file }
      # rubocop:disable Lint/AmbiguousRegexpLiteral
      its(:content) { should match /\[user\]/ }
      its(:content) { should match /\[alias\]/ }
      # rubocop:enable Lint/AmbiguousRegexpLiteral
    end
  when  'tmux'
    describe file("#{home}/.tmux.conf") do
      it { should be_file }
    end
  when 'vim'
    describe file("#{home}/.vimrc") do
      it { should be_file }
    end
  end
end
