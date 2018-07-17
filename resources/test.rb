
action :run do
  bash "status" do
    guard_interpreter :bash
    vagrant = 'vagrant'
    flags "--login"
    cwd ::Dir.home(vagrant)
    user vagrant
    group vagrant
    environment(
      'USER': vagrant,
      'USERNAME': vagrant,
      'LOGNAME': vagrant
    )

    code <<~BASH
      whoami
      env
      type -t rvm
      rvm use
    BASH
    
    live_stream true
  end
end

