# frozen_string_literal: true

ubuntu_packages = %w[
  gcc
  g++
  make
  libssl-dev
  libreadline-dev
  zlib1g-dev
]

ol8_packages = %w[
  gcc
  gcc-c++
  make
  openssl-devel
  readline-devel
  zlib-devel
]

packages = ubuntu_packages if node['distro'] == 'ubuntu'
packages = ol8_packages    if node['distro'] == 'ol8'

packages.each do |pkg|
  package pkg do
    action :install
  end
end

home_dir = "/home/#{node['user_name']}"

git "#{home_dir}/.anyenv" do
  user node['user_name']
  not_if "[ -d #{home_dir}/.anyenv ]"
  repository 'https://github.com/riywo/anyenv'
end

git "#{home_dir}/.anyenv/plugins/anyenv-update" do
  user node['user_name']
  not_if "[ -d #{home_dir}/.asdf/plugins/anyenv-update ]"
  repository 'https://github.com/znz/anyenv-update.git'
end

execute 'write bash config' do
  user node['user_name']
  only_if	'[ -f ~/.bashrc ]'
  not_if "grep -q 'anyenv' ~/.bashrc" # anyenvが記述されていれば既に設定済みとみなす
  command <<~SH
    echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(anyenv init -)"' >> ~/.bashrc
  SH
end

execute 'write zsh config' do
  user node['user_name']
  only_if	'[ -f ~/.zshrc ]'
  not_if "grep -q 'anyenv' ~/.zshrc" # anyenvが記述されていれば既に設定済みとみなす
  command <<~SH
    echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(anyenv init -)"' >> ~/.zshrc
  SH
end

execute 'write fish config' do
  user node['user_name']
  only_if	'[ -f ~/.config/fish/config.fish ]'
  # anyenvが記述されていれば既に設定済みとみなす
  not_if "grep -q 'anyenv' ~/.config/fish/config.fish"
  command <<~SH
    echo 'set -x PATH $HOME/.anyenv/bin $PATH' >> ~/.config/fish/config.fish
    echo 'eval (anyenv init - | source)' >> ~/.config/fish/config.fish
  SH
end

git "#{home_dir}/.config/anyenv/anyenv-install" do
  user node['user_name']
  not_if "[ -d #{home_dir}/.config/anyenv/anyenv-install ]"
  repository 'https://github.com/anyenv/anyenv-install'
end
