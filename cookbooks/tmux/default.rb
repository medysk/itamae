# frozen_string_literal: true

home_dir = "/home/#{node['user_name']}"

git "#{home_dir}/.tmux/plugins/tpm" do
  user node['user_name']
  repository 'https://github.com/tmux-plugins/tpm'
end

remote_file "#{home_dir}/.tmux.conf" do
  user node['user_name']
  owner node['user_name']
  group node['group_name']
  mode '755'
  source 'files/.tmux.conf'
end
