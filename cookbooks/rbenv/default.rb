# frozen_string_literal: true

execute 'install rbenv' do
  user node['user_name']
  not_if '~/.anyenv/bin/anyenv versions | grep -q rbenv'
  command '~/.anyenv/bin/anyenv install rbenv'
end
