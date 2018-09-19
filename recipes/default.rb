
package 'git'

user 'vagrant' do
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
  

rvm "vagrant" do
  ruby 'ruby'
  gems %w(rails)
end
