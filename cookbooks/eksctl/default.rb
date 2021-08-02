# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "eksctl"']
  command zsh_wrapper['asdf plugin-add eksctl']
end

# 最新をインストール
execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(which eksctl)]
  command zsh_wrapper['asdf install eksctl latest']
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current eksctl']
  command zsh_wrapper['asdf global eksctl latest']
end
