# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require './spec/spec_helper'
require 'yaml'

task :serverspec => 'serverspec:all'
task :default    => :serverspec

namespace :serverspec do
  ENV['ITAMAE_ENV'] ||= 'development'
  ENV['TARGET_HOST'] ||= 'localhost'

  task :all => node['roles']
  task :default => :all

  node['roles'].each do |role|
    desc "Run serverspec tests to #{role}"
    RSpec::Core::RakeTask.new(role.to_sym) do |t|
      t.pattern = "spec/serverspec/#{role}_spec.rb"
    end
  end
end
