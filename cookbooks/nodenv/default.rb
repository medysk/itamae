# frozen_string_literal: true

execute 'install nodenv' do
  user node['user_name']
  not_if '~/.anyenv/bin/anyenv versions | grep -q nodenv'
  command '~/.anyenv/bin/anyenv install nodenv'
end
