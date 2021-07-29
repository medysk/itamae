# frozen_string_literal: true

require 'spec_helper'

describe user_command('source ~/.zshrc && asdf --version') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf plugin list | grep -q nodejs') do
  its(:exit_status) { should eq 0 }
end

describe user_command('source ~/.zshrc && asdf list nodejs | grep -q 16.4.') do
  its(:exit_status) { should eq 0 }
end
