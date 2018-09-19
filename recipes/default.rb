
package 'git'
package 'gnupg2'

user 'vagrant' do
  home '/home/vagrant'
  shell '/bin/bash'
  manage_home true
end

group 'vagrant' do
  members 'vagrant'
end

group 'sudoers' do
  members 'vagrant'
end

file "/etc/sudoers.d/99_vagrant" do
  content "vagrant ALL=(ALL) NOPASSWD:ALL"
end

directory "/home/vagrant" do
  owner "vagrant"
  group "vagrant"
end
  

rvm "vagrant" do
  ruby 'ruby'
  gems %w(rails)
end
