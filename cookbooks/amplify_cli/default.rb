# frozen_string_literal: true

execute 'Install amplify-cli' do
  user node['user_name']
  not_if 'zsh -lc "source ~/.zshrc && which amplify"'
  command 'zsh -lc "source ~/.zshrc && npm i -g @aws-amplify/cli"'
end
