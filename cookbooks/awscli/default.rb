# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "awscli"']
  command zsh_wrapper['asdf plugin-add awscli']
end

# 3.9系の最新をインストール
max_ver_sh = [
  'asdf list all awscli',
  %(grep -P '^2.2.'),
  %(awk 'END{print}'),
].join(' | ')

execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(asdf list awscli | grep -q '2.2.')]
  command zsh_wrapper["asdf install awscli $(#{zsh_wrapper[max_ver_sh]})"]
end

[
  'autoload -U bashcompinit && bashcompinit',
  "complete -C '~/.asdf/shims//aws_completer' aws",
].each do |cmd|
  execute 'write zsh config' do
    user node['user_name']
    only_if	'[ -f ~/.zshrc ]'
    not_if "grep -q '#{cmd}' ~/.zshrc"
    command "echo '#{cmd}' >>  ~/.zshrc"
  end
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current awscli']
  command zsh_wrapper["asdf global awscli $(#{zsh_wrapper[max_ver_sh]})"]
end
