
property :code, String, name_property: true
property :user, String
property :group, String

load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group]) unless property_is_set? :group
end

action :run do
  rvm_bash "rvm #{new_resource.name}" do
    user new_resource.user
    group new_resource.user
    code "rvm #{new_resource.code}"
  end
end

