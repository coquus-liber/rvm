property :name, String, name_property: true
property :user, String
property :group, String, default: lazy {|r| r.user }
property :home, String, default: lazy {|r| ::Dir.home(r.user) }
property :cwd, String, default: lazy {|r| r.home }
property :env, Hash, default: lazy { |r|
  { 
    'HOME': r.home, 
    'USER': r.user, 
    'USERNAME': r.user, 
    'LOGNAME': r.user
  }
}
property :command
property :creates

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
  execute new_resource.name do
    cwd new_resource.cwd
    user new_resource.user
    group new_resource.group
    environment new_resource.env
    command new_resource.command
    creates new_resource.creates
  end
end
