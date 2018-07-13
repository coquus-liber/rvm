
property :command, [String, Array], name_property: true
property :version, [String, Array]

# default[:rvm][:rubies] = %w(ruby-2.4.4 ruby-2.5.1)
# default[:rvm][:use] = "ruby-2.4.4"

load_current_value do
end

action_class do 
  include RVM
end

action :run do
  install_rvm unless rvm_installed?
  rvm_install 'ruby'
  rvm_use 'ruby'
  rvm_exec new_resource.command
end


