# frozen_string_literal: true

package 'fish' do
  action :install
end

if node['login_shell'] == 'fish'
  execute 'set login shell' do
    user node['user_name']
    command "sudo chsh -s $(which fish) #{node['user_name']}"
  end
end

directory '$HOME/.config/fish/' do
  mode '755'
  owner node['user_name']
  group node['group_name']
end

file '$HOME/.config/fish/config.fish' do
  not_if 'test -f $HOME/.config/fish/config.fish'
  owner node['user_name']
  group node['group_name']
end

execute 'install fisher' do
  user node['user_name']
  not_if 'test -d $HOME/.config/fish'
  command 'curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish' # rubocop:disable Layout/LineLength
end

execute 'add plugin' do
  user node['user_name']
  command 'fish -c "fisher install oh-my-fish/theme-bobthefish"'
end

[
  "alias ll='ls -lsah'",
  "alias be='bundle exec'",
].each do |cmd|
  execute "write #{cmd}" do
    user node['user_name']
    not_if "grep -q '#{cmd}' $HOME/.config/fish/config.fish"
    command "echo '#{cmd}' >> $HOME/.config/fish/config.fish"
  end
end
