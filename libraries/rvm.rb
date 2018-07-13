
module RVM
  def install_rvm
    directory rvm_dir do
      user new_resource.user
      group new_resource.group
      mode '0755'
    end

    remote_file key_file do
      source new_resource.key_source
      owner new_resource.user
      group new_resource.group
      mode '0644'
      action :create
    end

    rvm_key user do
      key_file new_resource.key_file
      action :import
    end

    git src_dir do
      repository repo
      revision new_resource.revision
      user new_resource.user
      group new_resource.group
    end

    execute 'install rvm' do
      cwd src_dir
      user new_resource.user
      group new_resource.user
      environment(
        'USER': new_resource.user,
        'USERNAME': new_resource.user,
        'LOGNAME': new_resource.user
      )
      command "./install"
      creates installed
      live_stream true
    end
  end

end
