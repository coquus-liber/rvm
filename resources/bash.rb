
property :command, String, name_property: true
property :user, String
property :group, String

load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group]) unless property_is_set? :group
end

action :run do
  script new_resource.command do
    interpreter "bash"
    flags "--login"
    cwd ::Dir.home(new_resource.user)
    user new_resource.user
    group new_resource.user
    environment(
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    code <<~BASH
      #{new_resource.command}
    BASH
    # not_if { ::File.exist?(extract_path) }
    live_stream true
  end
end

