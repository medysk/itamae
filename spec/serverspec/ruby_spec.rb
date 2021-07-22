# frozen_string_literal: true

require 'spec_helper'

describe user_command('source ~/.zshrc && asdf --version') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf plugin list | grep -q ruby') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf list ruby | grep -q 2.7.') do
  its(:exit_status) { should eq 0 }
end
