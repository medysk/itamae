# frozen_string_literal: true

home_dir = "/home/#{node['user_name']}"

git "#{home_dir}/.asdf" do
  user node['user_name']
  not_if "[ -d #{home_dir}/.asdf ]"
  repository 'https://github.com/asdf-vm/asdf.git'
end

# zsh

execute 'write zsh config' do
  user node['user_name']
  only_if	'[ -f ~/.zshrc ]'
  not_if "grep -q '$HOME/.asdf/asdf.sh' ~/.zshrc"
  command <<~SH
    echo '. $HOME/.asdf/asdf.sh' >>  ~/.zshrc
    echo 'fpath=(${ASDF_DIR}/completions $fpath)' >>  ~/.zshrc
    echo 'compaudit || compaudit | xargs chmod g-w,o-w' >> ~/.zshrc
    echo 'autoload -Uz compinit && compinit' >>  ~/.zshrc
  SH
end

# fish

execute 'write fish config' do
  user node['user_name']
  only_if	'[ -f ~/.config/fish/fishfile ]'
  not_if "grep -q '$HOME/.asdf/asdf.fish' ~/.config/fish/fishfile"
  command 'echo "source ~/.asdf/asdf.fish" >> ~/.config/fish/fishfile'
end

directory "#{home_dir}/.config/fish/completions" do
  mode '755'
  owner node['user_name']
  group node['group_name']
  only_if	'[ -f ~/.config/fish/config.fish ]'
end

link "#{home_dir}/.config/fish/completions/asdf.fish" do
  not_if "[ -f #{home_dir}/.asdf/completions/asdf.fish ]"
  to "#{home_dir}/.asdf/completions/asdf.fish"
end

execute 'write fish config' do
  user node['user_name']
  only_if	'[ -f ~/.config/fish/config.fish ]'
  not_if "grep -q '~/.asdf/asdf.fish' ~/.config/fish/config.fish"
  command 'echo "source ~/.asdf/asdf.fish" >> ~/.config/fish/config.fish'
end

file "#{home_dir}/.asdfrc" do
  not_if '[ -f ~/.asdfrc ]'
  owner node['user_name']
  group node['group_name']
end

execute 'write asdfrc' do
  user node['user_name']
  not_if "grep -q 'legacy_version_file' ~/.asdfrc"
  command 'echo "legacy_version_file = yes" >> ~/.asdfrc'
end
