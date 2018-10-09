
package 'git'
package 'gnupg2'

include_recipe 'rvm::user'

rvm node[:rvm][:user] do
  ruby node[:rvm][:ruby]
  gems node[:rvm][:gems]
end
