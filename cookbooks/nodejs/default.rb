# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "nodejs"']
  command zsh_wrapper['asdf plugin-add nodejs']
end

# 16.4系の最新をインストール
max_ver_sh = [
  'asdf list all nodejs',
  %(grep -P '^16.4.'),
  %(awk 'END{print}'),
].join(' | ')

execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(asdf list nodejs | grep -q '16.4.')]
  command zsh_wrapper["asdf install nodejs $(#{zsh_wrapper[max_ver_sh]})"]
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current nodejs']
  command zsh_wrapper["asdf global nodejs $(#{zsh_wrapper[max_ver_sh]})"]
end
