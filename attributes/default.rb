
default[:rvm] = {
  keys: { 
    "Michal Papis": {
      keyserver: "hkp://keys.gnupg.net",
      short_id: "3804BB82D39DC0E3",
      fingerprint: "409B6B1796C275462A1703113804BB82D39DC0E3",
      src: 'https://rvm.io/mpapis.asc',
      name: "Michal Papis (RVM signing)",
      email: "mpapis@gmail.com"
    },
    "Piotr Kuczynski": {
      keyserver: "hkp://keys.gnupg.net",
      short_id: "105BD0E739499BDB",
      fingerprint: "7D2BAF1CF37B13E2069D6956105BD0E739499BDB",
      name: "Piotr Kuczynski",
      email: "<piotr.kuczynski@gmail.com>"
    }
  },
  git: {
    repo: 'https://github.com/rvm/rvm.git',
    version: 'stable'
  },
  rubies: %w(ruby-2.5.1),
  use: "ruby-2.5.1",
  user: 'vagrant',
  group: 'vagrant'
}


