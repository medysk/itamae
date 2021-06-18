# frozen_string_literal: true

execute 'set config name' do
  user node['user_name']
  command "git config --global user.name #{node['git_name']}"
end

execute 'set config email' do
  user node['user_name']
  command "git config --global user.email #{node['git_email']}"
end

execute 'set config alias.permission-reset' do
  user node['user_name']
  not_if 'git config --global --get alias.permission-reset'
  command %q[git config --global --add alias.permission-reset "!git diff -p | grep -E \"^(diff|old mode|new mode)\" | sed -e \"s/^old/NEW/;s/^new/old/;s/^NEW/new/\" | git apply"] # rubocop:disable Layout/LineLength
end
