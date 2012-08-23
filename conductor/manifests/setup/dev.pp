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

  exec { "setup database":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle exec rake db:setup",
    require => Exec["migrate database"]
  }

  exec { "create admin":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle exec 'rake dc:create_admin_user'",
    require => Exec["setup database"]
  }
}
