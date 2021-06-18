# frozen_string_literal: true

package 'zsh' do
  action :install
end

if node['login_shell'] == 'zsh'
  execute 'set login shell' do
    user node['user_name']
    command "sudo chsh -s $(which zsh) #{node['user_name']}"
  end
end

execute 'install zprezto' do
  user node['user_name']
  not_if 'test -d $HOME/.zprezto'
  command <<~SH
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    zsh -c 'setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done'
  SH
end

[
  "alias ll='ls -lsah'",
  "alias be='bundle exec'",
  'autoload -Uz promptinit',
  'promptinit',
  'prompt giddie',
].each do |cmd|
  execute "write #{cmd}" do
    user node['user_name']
    not_if "grep -q '^\s*#{cmd}' ~/.zshrc"
    command %(echo "#{cmd}" >> ~/.zshrc)
  end
end
