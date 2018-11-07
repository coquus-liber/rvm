
include_recipe 'rvm::user'

bundle_dir = File.join(node[:rvm][:home],'.bundle')

directory '~/.bundle' do
  path bundle_dir
  owner node[:rvm][:user]
  group node[:rvm][:group]
end

cookbook_file '~/.bundle/config' do
  source 'bundle_config.yml'
  path File.join(bundle_dir,'config')
  owner node[:rvm][:user]
  group node[:rvm][:group]
end

