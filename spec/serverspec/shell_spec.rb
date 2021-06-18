# frozen_string_literal: true

require 'spec_helper'

describe package('zsh') do
  it { should be_installed }
end

describe package('fish') do
  it { should be_installed }
end

case node['login_shell']
when 'zsh'
  describe user(node['user_name']) do
    it { should have_login_shell /.*zsh$/ } # rubocop:disable Lint/AmbiguousRegexpLiteral
  end
when  'fish'
  describe user(node['user_name']) do
    it { should have_login_shell /.*fish$/ } # rubocop:disable Lint/AmbiguousRegexpLiteral
  end
end
