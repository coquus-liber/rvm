
property :user, String, name_property: true
property :group, String
property :key_file, String, default: '/home/vagrant/.rvm/mpapis.asc'
property :gnupg_dir, String, default: "/home/vagrant/.gnupg"
property :home_dir, String, default: '/home/vagrant' #lazy { "/home/#{new_resource.user}" }

action :import do
  directory new_resource.gnupg_dir do
    user new_resource.user
    group new_resource.group
    mode '0700'
  end

  execute 'install mpapis public keys' do
    cwd new_resource.home_dir
    user new_resource.user
    group new_resource.group
    environment(
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    command "gpg --import #{new_resource.key_file}"
    live_stream true
  end
end
