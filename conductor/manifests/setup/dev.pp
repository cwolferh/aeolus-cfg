class conductor::setup::dev {
  require conductor::config::dev
  require bundler

  $dependencies = [
		   "libffi-devel",  #ffi  
                   "libxml2-devel", #nokogiri
                   "libxslt-devel", #nokogiri
                   "sqlite-devel"  #sqlite3
                  ]
  
  package { $dependencies: }

  exec { "bundle install":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle install --path bundle",
    logoutput => on_failure,
    require => Package[$dependencies]
  }

  exec { "install local aeolus-image-rubygem":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/gem install --install-dir /tmp/conductor/src/bundle/ruby/1* /tmp/aeolus-image-rubygem/*.gem",
    logoutput => on_failure,
    onlyif => "/bin/ls /tmp/aeolus-image-rubygem/*.gem",
    require => Exec["bundle install"]
  }

  exec { "migrate database":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle exec rake db:migrate",
    require => Exec["install local aeolus-image-rubygem"]
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
  exec { "compass compile":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle exec 'compass compile'",
    require => Exec["bundle install"]
  }
}
