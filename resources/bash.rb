
property :code, String, name_property: true
property :user, String
property :group, String

load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group]) unless property_is_set? :group
end

action :run do
  bash new_resource.name do
    guard_interpreter :bash
    flags "--login"
    cwd ::Dir.home(new_resource.user)
    user new_resource.user
    group new_resource.user
    environment(
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    code new_resource.code
    # not_if { ::File.exist?(extract_path) }
    live_stream true
  end
end

