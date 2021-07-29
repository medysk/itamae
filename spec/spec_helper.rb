# frozen_string_literal: true

require 'serverspec'
require 'net/ssh'
require 'yaml'
require 'itamae'
require 'pry'

def node
  return @node if @node

  hash = YAML.load_file("#{__dir__}/../nodes/#{ENV['ITAMAE_ENV']}.yml")
  @node = Itamae::Node.new(hash, Specinfra.backend)
end

def user_command(cmd)
  command "sudo su -l #{node['user_name']} -c zsh -lc '#{cmd}'"
end

if ENV['TARGET_HOST'] == 'localhost'
  set :backend, :exec
else
  set :backend, :ssh

  RSpec.configure do |c|
    c.before :all do
      host = ENV['TARGET_HOST']
      options = Net::SSH::Config.for(host, files = %W(ENV['SSH_CONFIG'])) # rubocop:disable Lint/UselessAssignment

      set :host,        options[:host_name] || host
      set :ssh_options, options
    end
  end
end
