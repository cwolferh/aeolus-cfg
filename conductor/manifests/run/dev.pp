class conductor::run::dev {
  require conductor::setup::dev

  exec { "conductor rails server":
    cwd => '/tmp/conductor/src',
    command => '/usr/bin/bundle exec "rails server --daemon"'
    unless => '/usr/bin/curl http://0.0.0.0:3000/'
  }
}
