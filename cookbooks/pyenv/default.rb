# frozen_string_literal: true

execute 'install pyenv' do
  user node['user_name']
  not_if '~/.anyenv/bin/anyenv versions | grep -q pyenv'
  command '~/.anyenv/bin/anyenv install pyenv'
end
