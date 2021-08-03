# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "direnv"']
  command zsh_wrapper['asdf plugin-add direnv']
end

# 最新をインストール
execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(which direnv)]
  command zsh_wrapper['asdf install direnv latest']
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current direnv']
  command zsh_wrapper['asdf global direnv latest']
end

execute 'write zsh config' do
  user node['user_name']
  only_if	'[ -f ~/.zshrc ]'
  # direnvが記述されていれば既に設定済みとみなす
  not_if "grep -q 'direnv' ~/.zshrc"
  command %(echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc)
end

execute 'write fish config' do
  user node['user_name']
  only_if	'[ -f ~/.config/fish/config.fish ]'
  # direnvが記述されていれば既に設定済みとみなす
  not_if "grep -q 'direnv' ~/.config/fish/config.fish"
  command "echo 'eval (direnv hook fish)' >> ~/.config/fish/config.fish"
end
