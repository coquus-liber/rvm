rvm = node['rvm']
rvm_user = rvm['user']
rvm_group = rvm['group'] || rvm_user
rvm_home = '/home/' + rvm_user, # decent guess

rvm_env = { 
  'HOME': rvm_home,
  'USER': rvm_user,
  'USERNAME': rvm_user,
  'LOGNAME': rvm_user 
}

# curl -sSL https://rvm.io/mpapis.asc
directory File.join(rvm_home,'.rvm') do
  user rvm_user
  group rvm_user
  mode '0755'
end

directory File.join(rvm_home,".gnupg") do
  user rvm_user
  group rvm_user
  mode '0700'
end

remote_file File.join(rvm_home,".rvm/mpapis.asc") do
  source 'https://rvm.io/mpapis.asc'
  owner rvm_user
  group rvm_user
  mode '0644'
  action :create
end

execute 'install mpapis public keys' do
  cwd rvm_home
  user rvm_user
  group rvm_user
  environment(rvm_home)
  command "gpg --import #{rvm_home}/.rvm/mpapis.asc"
  live_stream true
  # not_if "gpg --list-keys D39DC0E3"
  not_if "gpg --list-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
end

git File.join(rvm_home,".rvm/src") do
  repository node[:rvm][:git][:repo]
  revision node[:rvm][:git][:version]
  user rvm_user
  group rvm_user
end

bash 'install rvm' do
  cwd File.join(rvm_home,".rvm/src")
  user rvm_user
  group rvm_user
  environment(rvm_env)
  code "./install --ignore-dotfiles"
  creates File.join(rvm_home,".rvm/installed.at")
  live_stream true
end

cookbook_file File.join(rvm_home,".bash_profile") do
  source 'dot/bash_profile'
  mode "0755"
end

cookbook_file File.join(rvm_home,".bashrc") do
  source 'dot/bashrc'
  mode "0755"
end

cookbook_file File.join(rvm_home,".profile") do
  source 'dot/profile'
  mode "0755"
end

node[:rvm][:rubies].each do |ruby|
  execute "rvm install #{ruby}" do
    command "sudo -iHu #{rvm_user} rvm install #{ruby}"
    creates "#{rvm_home}/.rvm/rubies/#{ruby}"
    live_stream true
  end
end

rvm_ruby = node[:rvm][:use]
execute "rvm use #{rvm_ruby}" do
  command "sudo -iHu #{rvm_user} rvm use #{rvm_ruby} --default"
  creates "#{rvm_home}/.rvm/rubies/default"
  live_stream true
end
