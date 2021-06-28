# frozen_string_literal: true

require 'spec_helper'

describe command('docker -v') do
  its(:exit_status) { should eq 0 }
end

describe command('/usr/local/bin/docker-compose -v') do
  its(:exit_status) { should eq 0 }
end
