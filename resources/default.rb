
property :user, String, name_property: true
property :group, String, default: lazy {|r| r.user }
property :home_dir, String, default: lazy {|r| ::Dir.home(r.user) }
property :rvm_dir, String, default: lazy {|r| ::File.join(r.home_dir, '.rvm')}
property :src_dir, String, default: lazy {|r| ::File.join(r.rvm_dir, 'src')} 
property :bin_dir, String, default: lazy {|r| ::File.join(r.rvm_dir, 'bin')} 
property :rvm_bin, String, default: lazy {|r| ::File.join(r.bin_dir, 'rvm')} 
property :gnupg_dir, String, default: lazy {|r| ::File.join(r.home_dir, '.gnupg')} 
property :key_file, String, default: lazy {|r| ::File.join(r.rvm_dir, 'mpapis.asc')} 
property :installed_file, String, default: lazy {|r| ::File.join(r.rvm_dir, 'installed.at')} 
property :ruby, String, default: 'ruby'
property :gems, Array, default: %w(rails)
property :rvm_repo, String, default: 'https://github.com/rvm/rvm.git'
property :revision, String, default: 'stable'
property :key_source, String, default: 'https://rvm.io/mpapis.asc'
property :env, Hash, default: lazy { |r|
  { 
    'HOME': r.home_dir, 
    'USER': r.user, 
    'USERNAME': r.user, 
    'LOGNAME': r.user
  }
}

# load the current state of the node from the system
load_current_value do 
end

# define methods that are available in the actions
action_class do
  # require
  # include
  # def methods
end

action :run do
  raise "group is nil" unless new_resource.group

  directory new_resource.rvm_dir do # '.rvm' do
    user new_resource.user
    group new_resource.group
    mode '0755'
  end

  remote_file new_resource.key_file do
    source new_resource.key_source
    owner new_resource.user
    group new_resource.group
    mode '0644'
    action :create
    sensitive true
  end

  directory new_resource.gnupg_dir do
    user new_resource.user
    group new_resource.group
    mode '0700'
  end

  execute 'install mpapis public keys' do
    cwd new_resource.home_dir
    user new_resource.user
    group new_resource.group
    environment new_resource.env
    command "gpg --import #{new_resource.key_file}"
    live_stream true
  end

  git new_resource.src_dir do
    repository new_resource.rvm_repo
    revision new_resource.revision
    user new_resource.user
    group new_resource.group
  end

  execute 'install rvm' do
    cwd new_resource.src_dir
    user new_resource.user
    group new_resource.group
    environment new_resource.env
    command "./install"
    creates new_resource.installed_file
    live_stream true
  end

  bash new_resource.name do
    guard_interpreter :bash
    flags "--login"
    cwd new_resource.home_dir
    user new_resource.user
    group new_resource.group
    environment new_resource.env
    code <<~BASH
      rvm use #{new_resource.ruby} || \
      rvm install #{new_resource.ruby} && \
      rvm use --default #{new_resource.ruby} 
      gem install #{new_resource.gems.join(' ')}
    BASH
    # not_if { ::File.exist?(extract_path) }
    live_stream true
  end
end

