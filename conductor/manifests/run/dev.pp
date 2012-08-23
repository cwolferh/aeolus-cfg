class conductor::run::dev {
  require conductor::setup::dev

  exec { "conductor rails server":
    cwd => '/tmp/conductor',
    command => '/usr/bin/bundle exec rails server'
  }
}
