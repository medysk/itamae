# frozen_string_literal: true

cmds = []

case node['distro']
when 'ol8'
  cmds.push 'sudo dnf -y update dnf'
when 'ubuntu'
  cmds.push 'sudo rm -rf /var/lib/apt/lists/*'
  cmds.push 'sudo apt-get autoclean'
  cmds.push 'sudo apt-get clean'
  cmds.push 'sudo apt update'
end

cmds.each do |cmd|
  execute 'update package manager' do
    user node['user_name']
    command cmd
  end
end
