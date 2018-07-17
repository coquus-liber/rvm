
property :gems, [String,Array], name_property: true
property :user, String
property :group, String

load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group]) unless property_is_set? :group
end

action :run do
  rvm_bash "gem install #{new_resource.gems}" do
    user new_resource.user
    group new_resource.user
    # rvm use as guard clause
    code <<~BASH
      gem install #{new_resource.gems}
    BASH
  end
end

