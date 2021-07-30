# frozen_string_literal: true

require 'spec_helper'

describe user_command('source ~/.zshrc && asdf --version') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf plugin list |grep -q kubectl') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && which kubectl') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf plugin list |grep -q kubectx') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && which kubectx') do
  its(:exit_status) { should eq 0 }
end
