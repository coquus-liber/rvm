
property :user, String, name_property: true
property :group, String
property :home, String
property :rvm_dir, String
property :src_dir, String
property :bin_dir, String
property :installed_file, String
property :rvm_repo, String, default: 'https://github.com/rvm/rvm.git'
property :revision, String, default: 'stable'
property :key_source, String, default: 'https://rvm.io/mpapis.asc'

# load the current state of the node from the system
load_current_value do
  user(node[:rvm][:user]) unless property_is_set? :user
  group(node[:rvm][:group] || user) unless property_is_set? :group
  home(::Dir.home(user)) unless property_is_set? :home
end

# define methods that are available in the actions
action_class do
  # require
  # include
  # def methods

  def rvm_dir
    @rvm_dir ||= ::File.join(new_resource.home, '.rvm')
  end

  def gnupg_dir
    @rvm_dir ||= ::File.join(new_resource.home, '.gnupg')
  end

  def key_file
    @key_file ||= ::File.join(rvm_dir,'mpapis.asc')
  end

  def src_dir
    @src_dir ||= ::File.join(rvm_dir, 'src')
  end

  def bin_dir
    @bin_dir ||= ::File.join(rvm_dir, 'bin')
  end

  def rvm_bin
    @rvm_bin ||= ::File.join(bin_dir, 'rvm')
  end

  def installed_file
    @installed_file ||= ::File.join(rvm_dir, "installed.at")
  end
end

action :run do
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
    sensitive true
  end

  directory gnupg_dir do
    user new_resource.user
    group new_resource.group
    mode '0700'
  end

  execute 'install mpapis public keys' do
    cwd new_resource.home
    user new_resource.user
    group new_resource.group
    environment(
      'HOME': new_resource.home,
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    command "gpg --import #{key_file}"
    live_stream true
  end

  git src_dir do
    repository new_resource.rvm_repo
    revision new_resource.revision
    user new_resource.user
    group new_resource.group
  end

  execute 'install rvm' do
    cwd src_dir
    user new_resource.user
    group new_resource.group
    environment(
      'HOME': new_resource.home,
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    command "./install"
    creates installed_file
    live_stream true
  end

  bash new_resource.name do
    guard_interpreter :bash
    flags "--login"
    cwd new_resource.home
    user new_resource.user
    group new_resource.group
    environment(
      'HOME': new_resource.home,
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    code <<~BASH
      rvm use #{new_resource.ruby} || \
      rvm install #{new_resource.ruby} && \
      rvm use --default #{new_resource.ruby} 
      gem install #{new_resource.gems}
    BASH
    # not_if { ::File.exist?(extract_path) }
    live_stream true
  end
end

