# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "kubectl"']
  command zsh_wrapper['asdf plugin-add kubectl']
end

# alpha, bate, rc版を除く最新バージョンをインストール
max_ver_sh = [
  'asdf list all kubectl',
  %(grep -P '^(\\d|\\.)+$'),
  %(awk 'END{print}'),
].join(' | ')

# run_commandだとユーザ指定できないようなので自力で指定
cmd = "sudo su -l #{node['user_name']} -c  #{zsh_wrapper[max_ver_sh]}"
ver = run_command(cmd).stdout.chomp

execute 'install' do
  user node['user_name']
  not_if zsh_wrapper['kubectl --help']
  command zsh_wrapper["asdf install kubectl #{ver}"]
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current kubectl']
  command zsh_wrapper["asdf global kubectl #{ver}"]
end

execute 'write zsh config' do
  user node['user_name']
  only_if	'[ -f ~/.zshrc ]'
  not_if "grep -q 'kubectl' ~/.zshrc"
  command %(echo 'source <(kubectl completion zsh)' >>  ~/.zshrc)
end

execute 'add fisher plugin' do
  user node['user_name']
  not_if "fisher list | grep -q 'evanlucas/fish-kubectl-completions'"
  command 'fish -lc "fisher install evanlucas/fish-kubectl-completions"'
end
