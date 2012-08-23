class conductor::setup::dev {
  require conductor::config::dev
  require bundler

  $dependencies = [
                   "libxml2-devel", #nokogiri
                   "libxslt-devel", #nokogiri
                   "sqlite-devel"   #sqlite3
                  ]
  
  package { $dependencies: }

  exec { "bundle install":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle install --path bundle",
    logoutput => on_failure,
    require => Package[$dependencies]
  }

  exec { "migrate database":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle exec rake db:migrate",
    require => Exec["bundle install"]
  }
}
