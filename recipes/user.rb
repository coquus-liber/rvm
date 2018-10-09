
rvm_user = node[:rvm][:user]
rvm_group = node[:rvm][:group] || rvm_user
rvm_user_home = node[:rvm][:home] || "/home/#{rvm_user}"

user rvm_user do
  home rvm_user_home
  shell '/bin/bash'
  manage_home true
end

group rvm_user do
  members rvm_user
end

group 'sudoers' do
  members rvm_user
end

directory rvm_user_home do
  owner rvm_user
  group rvm_group
end
  
file "/etc/sudoers.d/99_#{rvm_user}" do
  content "#{rvm_user} ALL=(ALL) NOPASSWD:ALL"
end


