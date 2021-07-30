# frozen_string_literal: true

require 'securerandom'

zsh_wrapper = proc { |cmd| %(zsh -lc "source ~/.zshrc && #{cmd}") }

execute 'add plugin' do
  user node['user_name']
  not_if  zsh_wrapper['asdf plugin list | grep -q "gcloud"']
  command zsh_wrapper['asdf plugin-add gcloud']
end

# 最新バージョンをインストール
execute 'install' do
  user node['user_name']
  not_if zsh_wrapper['gcloud --version']
  command zsh_wrapper['asdf install gcloud latest']
end

execute 'set global version' do
  user node['user_name']
  not_if zsh_wrapper['asdf current gcloud']
  command zsh_wrapper['asdf global gcloud latest']
end

cur_ver_sh = "asdf current gcloud | awk '\\''{print $2}'\\''"

[
  "source ~/.asdf/installs/gcloud/$(#{cur_ver_sh})/path.zsh.inc",
  "source ~/.asdf/installs/gcloud/$(#{cur_ver_sh})/completion.zsh.inc",
].each do |cmd|
  execute 'write zsh config' do
    user node['user_name']
    only_if	'[ -f ~/.zshrc ]'
    not_if "grep -q '#{cmd[%r{(?!.*/).*}]}' ~/.zshrc"
    command %(echo '#{cmd}' >>  ~/.zshrc)
  end
end

cmd = "source ~/.asdf/installs/gcloud/(#{cur_ver_sh})/path.fish.inc"

execute 'write fish config' do
  user node['user_name']
  only_if	'[ -f ~/.config/fish/config.fish ]'
  not_if "grep -q '#{cmd[%r{(?!.*/).*}]}' ~/.config/fish/config.fish"
  command %(echo '#{cmd}' >>  ~/.config/fish/config.fish)
end

work_dir = "/home/#{node['user_name']}/tmp/itamae_tmp_#{SecureRandom.uuid}"

git work_dir do
  user node['user_name']
  not_if "[ -f /home/#{node['user_name']}/.config/fish/completions/gcloud.fish"
  repository 'https://github.com/lgathy/google-cloud-sdk-fish-completion.git'
end

execute 'Install fish completion' do
  user node['user_name']
  cwd work_dir
  not_if "[ -f /home/#{node['user_name']}/.config/fish/completions/gcloud.fish"
  command "#{work_dir}/install.sh"
end

execute "rm -fr #{work_dir}"
