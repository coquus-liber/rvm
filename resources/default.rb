
property :command, [String, Array], name_property: true
property :user, String
property :group, String
property :repo, String, default: 'https://github.com/rvm/rvm.git'
property :revision, String, default: 'stable'
property :home_dir, String
property :rvm_dir, String
property :installed, String
property :key_source, String, default: 'https://rvm.io/mpapis.asc'
property :key_file, String
property :src_dir, String
property :ruby, [String, Array]
property :version, [String, Array]

# default[:rvm][:rubies] = %w(ruby-2.4.4 ruby-2.5.1)
# default[:rvm][:use] = "ruby-2.4.4"

action_class do 
  def rvm_installed? 
    ::File.exists? installed
  end

  include InstallRVM
end

load_current_value do
  rvm = node['rvm']
  user(rvm['user'] || vagrant) unless property_is_set? :user
  group(rvm['group'] || user) unless property_is_set? :group
  home_dir(rvm['home_dir'] || "/home/#{user}") unless property_is_set? :home_dir
  rvm_dir(rvm['rvm_dir'] || home_dir + '/.rvm' ) unless property_is_set? :rvm_dir
  src_dir(rvm['src_dir'] || rvm_dir + '/src' ) unless property_is_set? :src_dir
  installed(rvm['installed'] || "#{rvm_dir}/installed.at" ) unless property_is_set? :installed
  key_file(rvm['key_file'] || "#{rvm_dir}/mpapis.asc" ) unless property_is_set? :key_file
  install_rvm unless rvm_installed?
end

action :run do
  execute "rvm #{new_resource.command}" do
    cwd new_resource.home_dir
    user new_resource.user
    group new_resource.user
    environment(
      'USER': new_resource.user,
      'USERNAME': new_resource.user,
      'LOGNAME': new_resource.user
    )
    command "~/.rvm/bin/rvm #{new_resource.command}"
    live_stream true
  end
end


