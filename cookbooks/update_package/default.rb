# frozen_string_literal: true

cmd = ''

case node['distro']
when 'ol8'
  cmd = 'sudo dnf -y update'
when 'ubuntu'
  cmd = 'sudo apt upgrade -y'
end

execute 'update package' do
  user node['user_name']
  command cmd
end
