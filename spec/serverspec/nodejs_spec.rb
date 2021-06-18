# frozen_string_literal: true

require 'spec_helper'

home = "/home/#{node['user_name']}"

describe command("#{home}/.anyenv/bin/anyenv -v") do
  its(:exit_status) { should eq 0 }
end

describe command("#{home}/.anyenv/envs/nodenv/bin/nodenv -v") do
  its(:exit_status) { should eq 0 }
end
