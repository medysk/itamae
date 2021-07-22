# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "python"']
  command zsh_wrapper['asdf plugin-add python']
end

# 3.9系の最新をインストール
max_ver_sh = [
  'asdf list all python',
  %(grep -P '^3.9.'),
  %(awk '{if(m<\\$1) m=\\$1} END{print m}'),
].join(' | ')

execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(asdf list python | grep -q '3.9.')]
  command zsh_wrapper["asdf install python $(#{zsh_wrapper[max_ver_sh]})"]
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current python']
  command zsh_wrapper["asdf global python $(#{zsh_wrapper[max_ver_sh]})"]
end
