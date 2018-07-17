
property :version, String, name_property: true
property :user, String
property :group, String

load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group]) unless property_is_set? :group
end

action :run do
  rvm_bash "rvm install #{new_resource.version}" do
    user new_resource.user
    group new_resource.user
    code <<~BASH
      rvm use --default #{new_resource.version} 
    BASH
  end
end

