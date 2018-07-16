
property :command, String, name_property: true
property :user, String
property :group, String

action :run do
  bash command do
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
