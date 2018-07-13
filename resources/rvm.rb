
property :user, String, name_property: true
property :group, String, default: 'vagrant'
property :repo, String, default: 'https://github.com/rvm/rvm.git'
property :version, String, default: 'stable'
# default[:rvm][:rubies] = %w(ruby-2.4.4 ruby-2.5.1)
# default[:rvm][:use] = "ruby-2.4.4"

# new_resource 

def env
  { 
    'HOME' => "/home/#{new_resource.user}", 
    'USER' => new_resource.user,
    'USERNAME' => new_resource.user,
    'LOGNAME' => new_resource.user 
  }
end


action :install do
  home_dir = "/home/#{new_resource.user}"
  rvm_dir = "#{home_dir}/.rvm"
  directory rvm_dir do
    user new_resource.user
    group new_resource.user
    mode '0755'
  end

  gnupg_dir = "#{home_dir}/.gnupg"
  directory gnupg_dir do
    user new_resource.user
    group new_resource.user
    mode '0700'
  end

  key_file = "#{rvm_dir}/mpapis.asc"
  remote_file key_file do
    source 'https://rvm.io/mpapis.asc'
    owner new_resource.user
    group new_resource.user
    mode '0644'
    action :create
  end

  execute 'install mpapis public keys' do
    cwd home_dir
    user new_resource.user
    group new_resource.user
    environment(env)
    command "gpg --import #{key_file}"
    live_stream true
  end

  src_dir = "#{rvm_dir}/src"

  git src_dir do
    repository new_resource.repo
    revision new_resource.version
    user new_resource.user
    group new_resource.user
  end

  execute 'install rvm' do
    cwd src_dir
    user new_resource.user
    group new_resource.user
    environment(env)
    command "./install"
    creates "#{rvm_dir}/installed.at"
    live_stream true
  end

end

