
require 'etc'

begin
  user = 
    if username = node[:rvm][:user]
      Etc.getpwnam(username)
    else
      Etc.getpwuid(1000)
    end
  node.default[:rvm][:user] = rvm_user = user.name
  rvm_user_home = node[:rvm][:home] || user.dir
  node.default[:rvm][:home] = rvm_user_home
  
  group = 
    if groupname = node[:rvm][:group]
      Etc.getgrnam(groupname)
    else
      Etc.getgrgid(user.gid)
    end

  rvm_group = group.name

  group 'sudoers' do
    members rvm_user
  end

  file "/etc/sudoers.d/99_#{rvm_user}" do
    content "#{rvm_user} ALL=(ALL) NOPASSWD:ALL"
  end
end


