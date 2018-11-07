
package 'git'
package 'gnupg2'

include_recipe 'rvm::user'
include_recipe 'rvm::bundle_config'

rvm node[:rvm][:user] do
  ruby node[:rvm][:ruby]
  rubygems node[:rvm][:rubygems]
  gems node[:rvm][:gems]
end

