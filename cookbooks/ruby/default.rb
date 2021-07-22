# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "ruby"']
  command zsh_wrapper['asdf plugin-add ruby']
end

# 2.7系の最新をインストール
max_ver_sh = [
  'asdf list all ruby',
  %(grep -P '^2.7.'),
  %(awk '{if(m<\\$1) m=\\$1} END{print m}'),
].join(' | ')

execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(asdf list ruby | grep -q '2.7.')]
  command zsh_wrapper["asdf install ruby $(#{zsh_wrapper[max_ver_sh]})"]
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current ruby']
  command zsh_wrapper["asdf global ruby $(#{zsh_wrapper[max_ver_sh]})"]
end
