property :user, String, name_property: true
property :group, String, default: lazy {|r| r.user }
property :home, String, default: lazy {|r| ::Dir.home(r.user) }
property :env, Hash, default: lazy { |r|
  { 
    'HOME': r.home, 
    'USER': r.user, 
    'USERNAME': r.user, 
    'LOGNAME': r.user
  }
}

load_current_value do 
end

action_class do
end

action :run do
  user new_resource.user do
    home new_resource.home
    shell '/bin/bash'
    manage_home true
  end

  group new_resource.group do
    members new_resource.user
  end

  group 'sudoers' do
    members new_resource.user
  end

  directory new_resource.home do
    owner new_resource.user
    group new_resource.group
  end
    
  file "/etc/sudoers.d/99_#{new_resource.user}" do
    content "#{new_resource.user} ALL=(ALL) NOPASSWD:ALL"
  end
end

