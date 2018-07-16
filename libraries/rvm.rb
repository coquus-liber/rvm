
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
end
