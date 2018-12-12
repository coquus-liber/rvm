
property :command
property :creates

property :user, String, default: lazy{ |r| ::Etc.getpwuid(1000).name }
property :usr, Etc::Passwd, default: lazy{ |r| ::Etc.getpwnam(r.user) }
property :grp, Etc::Group, default: lazy{ |r| ::Etc.getgrgid(r.usr.gid) }
property :group, String, default: lazy {|r| r.grp.name }
property :home, String, default: lazy {|r| r.usr.dir }
property :cwd, String, default: lazy {|r| r.home }
property :env, Hash, default: lazy { |r|
      { 
        'HOME': r.home, 
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
  execute new_resource.name do
    cwd new_resource.cwd
    user new_resource.user
    group new_resource.group
    environment new_resource.env
    command new_resource.command
    creates new_resource.creates
  end
end
