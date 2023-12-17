# frozen_string_literal: true

home = "/home/#{node['user_name']}"

remote_file "#{home}/.vimrc" do
  user node['user_name']
  owner node['user_name']
  group node['group_name']
  mode '755'
  source 'files/.vimrc'
end

directory "#{home}/.vim/colors" do
  user node['user_name']
  owner node['user_name']
  group node['group_name']
  mode '755'
end

themes = {
  molokai: 'https://github.com/tomasr/molokai',
  vim_material_theme: 'https://github.com/jdkanani/vim-material-theme',
  vim_atom_dark: 'https://github.com/gosukiwi/vim-atom-dark'
}

themes.each do |name, repo|
  git "#{home}/.vim/#{name}" do
    user node['user_name']
    not_if "[ -d #{home}/.vim/#{name} ]"
    repository repo
  end
end

execute 'copy vim theme' do
  user node['user_name']
  command "cp #{home}/.vim/*/colors/*.vim #{home}/.vim/colors/"
end
