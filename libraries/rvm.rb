
require 'pathname'

module RVM
  def rvm_node
    @rvm_node ||= node['rvm'] || {}
  end

  def rvm_user 
    @rvm_user ||= rvm_node['user'] || 'vagrant'
  end

  def rvm_group
    @rvm_group ||= rvm_node['group'] || rvm_user
  end

  def home
    @home ||= Pathname.new(::Dir.home(rvm_user))
  end

  def rvm_dir
    @rvm_dir ||= home.join('.rvm')
  end

  def src_dir
    @src_dir ||= rvm_dir.join('src')
  end

  def bin_dir
    @bin_dir ||= rvm_dir.join('bin')
  end

  def rvm_bin
    @rvm_bin ||= bin_dir.join('rvm')
  end

  def installed_file
    @installed_file ||= rvm_dir.join("installed.at")
  end

  def rvm_installed? 
    installed_file.exist? 
  end

  def key_file
    @key_file ||= rvm_dir.join("mpapis.asc")
  end

  def rvm_repo
    @rvm_repo ||= 'https://github.com/rvm/rvm.git'
  end

  def revision 
    @revision ||= 'stable'
  end

  def key_source
    @key_source ||= 'https://rvm.io/mpapis.asc'
  end

  def install_rvm
    directory rvm_dir.to_s do
      user self.rvm_user
      group self.rvm_group
      mode '0755'
    end

    remote_file key_file.to_s do
      source self.key_source
      owner self.rvm_user
      group self.rvm_group
      mode '0644'
      action :create
    end

    rvm_key rvm_user do
      key_file self.key_file.to_s
      action :import
    end

    git src_dir.to_s do
      repository self.rvm_repo
      revision self.revision
      user self.rvm_user
      group self.rvm_group
    end

    execute 'install rvm' do
      cwd src_dir.to_s
      user self.rvm_user
      group self.rvm_user
      environment(
        'USER': self.rvm_user,
        'USERNAME': self.rvm_user,
        'LOGNAME': self.rvm_user
      )
      command "./install"
      creates installed_file.to_s
      live_stream true
    end
  end

  def rvm_exec *cmd
    execute "rvm #{cmd.join(' ')}" do
      cwd self.home.to_s
      user self.rvm_user
      group self.rvm_user
      environment(
        'USER': self.rvm_user,
        'USERNAME': self.rvm_user,
        'LOGNAME': self.rvm_user
      )
      command([rvm_bin.to_s, *cmd].join(' '))
      live_stream true
    end
  end

  def rvm_install *rubies
    rvm_exec 'install', *rubies
  end

  def rvm_use ruby
    rvm_exec 'use', ruby
  end
end
