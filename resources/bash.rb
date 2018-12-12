
property :code, String, name_property: true
property :user, String, default: lazy{ |r| ::Etc.getpwuid(1000).name }
property :usr, Etc::Passwd, default: lazy{ |r| ::Etc.getpwnam(r.user) }
property :grp, Etc::Group, default: lazy{ |r| ::Etc.getgrgid(r.usr.gid) }
property :group, String, default: lazy {|r| r.grp.name }
property :home, String, default: lazy {|r| r.usr.dir }
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

action :run do
  bash new_resource.name do
    guard_interpreter :bash
    flags "--login"
    cwd new_resource.home
    user new_resource.user
    group new_resource.user
    environment new_resource.env
    code new_resource.code
    live_stream true
  end
end
