# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'Install awscli-local' do
  user node['user_name']
  not_if zsh_wrapper['which awslocal']
  command zsh_wrapper['pip install awscli-local && asdf reshim python']
end
