
install_rvm "vagrant" # install rvm for user 'vagrant'
rvm_bash "env"
rvm_bash "rvm info"
rvm_install 'ruby'
rvm_use_default 'ruby'
rvm_gem "rails"

