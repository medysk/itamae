# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "task"']
  command zsh_wrapper['asdf plugin-add task']
end

execute 'install' do
  user node['user_name']
  not_if zsh_wrapper[%(asdf list task | grep -q '2.7.')]
  command zsh_wrapper['asdf install task latest']
end

execute 'task completion' do
  not_if '[ -f /usr/local/share/zsh/site-functions/_task ]'
  command 'curl https://raw.githubusercontent.com/go-task/task/master/completion/zsh/_task -o /usr/local/share/zsh/site-functions/_task' # rubocop:disable Layout/LineLength
end

[
  'autoload -U compinit',
  'compinit -i',
].each do |cmd|
  execute 'write zsh config' do
    user node['user_name']
    only_if	'[ -f ~/.zshrc ]'
    not_if "grep -q '#{cmd}' ~/.zshrc"
    command "echo '#{cmd}' >>  ~/.zshrc"
  end
end
