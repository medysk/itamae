# frozen_string_literal: true

require 'spec_helper'

describe user_command('source ~/.zshrc && asdf --version') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf plugin list | grep -q awscli') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf list awscli | grep -q 2.2.') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && which amplify') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && which eksctl') do
  its(:exit_status) { should eq 0 }
end

# describe user_command('source ~/.zshrc && which awslocal') do
#   its(:exit_status) { should eq 0 }
# end
