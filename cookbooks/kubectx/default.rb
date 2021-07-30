# frozen_string_literal: true

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "kubectx"']
  command zsh_wrapper['asdf plugin-add kubectx']
end

# 最新バージョンをインストール
execute 'install' do
  user node['user_name']
  not_if zsh_wrapper['which kubectx']
  command zsh_wrapper['asdf install kubectx latest']
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current kubectx']
  command zsh_wrapper['asdf global kubectx latest']
end

zsh_fpath = '/usr/local/share/zsh/site-functions/'

directory zsh_fpath do
  mode '755'
  owner 'root'
  group 'root'
end

max_ver_sh = "asdf current kubectx | awk '{print \\$2}'"

# run_commandだとユーザ指定できないようなので自力で指定
cmd = "sudo su -l #{node['user_name']} -c  #{zsh_wrapper[max_ver_sh]}"
ver = run_command(cmd).stdout.chomp

home_dir = "/home/#{node['user_name']}"
kubectx_inst_path = "#{home_dir}/.asdf/installs/kubectx/#{ver}/completion/"

link "#{zsh_fpath}/_kubectx" do
  not_if "[ -L #{zsh_fpath}/_kubectx ]"
  to "#{kubectx_inst_path}/kubectx.zsh"
end

link "#{zsh_fpath}/_kubens" do
  not_if "[ -L #{zsh_fpath}/_kubens ]"
  to "#{kubectx_inst_path}/kubens.zsh"
end

fish_comp_path = "/home/#{node['user_name']}/.config/fish/completions"

link fish_comp_path do
  not_if "[ -L #{fish_comp_path}/kubectx.fish ]"
  to "#{kubectx_inst_path}/kubectx.fish"
end

link fish_comp_path do
  not_if "[ -L #{fish_comp_path}/kubens.fish ]"
  to "#{kubectx_inst_path}/kubens.fish"
end
