property :version, [String,Array], name_property: true
property :user, String
property :group, String

load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group]) unless property_is_set? :group
end

action :run do
  rvm_bash "rvm rubygems #{new_resource.version}" do
    user new_resource.user
    group new_resource.user
    # rvm use as guard clause
    code <<~BASH
      rvm rubygems #{new_resource.version}
    BASH
    # not_if "test $(gem -v) = #{new_resource.version}"
  end
end
